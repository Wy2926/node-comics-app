"""Generate a public update feed for manual upload; never deploy to a server."""

import argparse
import hashlib
import json
import os
import re
import sys
import tempfile
from pathlib import Path
from urllib.parse import quote, urlsplit
from urllib.request import Request, urlopen
from android_apk import APP_ID, ROOT, asset_sha, published_apk, valid_sha

REPOSITORY = "Wy2926/node-comics-app"
VERSION = r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
FULL_UPDATES = set(json.loads((ROOT / "tool/android_full_updates.json").read_text(encoding="utf-8")))


def version_key(version):
    return tuple(map(int, version.split(".")))


def allows_delta(base, version):
    before, after = version_key(base), version_key(version)
    return ((0, 2, 0) <= before < after
            and not any(before < version_key(v) <= after for v in FULL_UPDATES))


def previous_android(releases, version, suffix):
    matches = []
    for release in releases:
        tag = release.get("tag_name", "")
        if (release.get("draft") or release.get("prerelease") or not re.fullmatch("v" + VERSION, tag)
                or not allows_delta(tag[1:], version)):
            continue
        for asset in release.get("assets", []):
            if asset.get("state") == "uploaded" and asset.get("name") == f"nodelane-comics-{tag}-{suffix}":
                matches.append((version_key(tag[1:]), tag[1:], asset))
    return max(matches, key=lambda item: item[0])[1:] if matches else None


def uploaded(release, name):
    return next((a for a in release["assets"] if a.get("state") == "uploaded" and a.get("name") == name), None)


def patch_name(apk, base_sha, target_sha):
    # Rebuilding/replacing a same-tag binary must not republish its old recipe.
    return f"{apk}.from-{base_sha}.to-{target_sha}.nld1"


def asset_url(asset, tag, mirror):
    if mirror is not None:
        path = f"{mirror.path.rstrip('/')}/{quote(tag, safe='')}/{quote(asset['name'], safe='')}"
        return mirror._replace(path=path).geturl()
    url = asset.get("browser_download_url")
    web_url(url)
    return url


def read_record(asset):
    with urlopen(asset["browser_download_url"], timeout=30) as response:
        raw = response.read()
    if (asset_sha(asset) not in (None, hashlib.sha256(raw).hexdigest()) or
            asset.get("size") not in (None, len(raw))):
        raise ValueError(f"Invalid release record: {asset['name']}")
    return json.loads(raw)


def android_delivery(release, asset, arch, mirror):
    tag = release["tag_name"]
    version = tag[1:]
    name = asset["name"]
    sidecar = uploaded(release, name + ".json")
    record = read_record(sidecar) if sidecar else published_apk(asset, version, arch)
    abis = record.get("abis") if isinstance(record, dict) else None
    if (not isinstance(record, dict) or record.get("package") != APP_ID or record.get("version") != version
            or record.get("arch") != arch or type(record.get("build")) is not int or record["build"] <= 0
            or not isinstance(abis, list) or not abis or not all(isinstance(a, str) and a for a in abis)
            or (len(set(abis)) < 2 if arch == "universal" else abis != [arch])
            or type(record.get("size")) is not int or record["size"] <= 0
            or not valid_sha(record.get("sha256"))
            or asset.get("size") not in (None, record["size"]) or asset_sha(asset) not in (None, record["sha256"])):
        raise ValueError(f"APK identity record does not match {name}")
    # Without a remote digest, bind the record to the actual downloadable bytes.
    if sidecar and not asset_sha(asset):
        actual = published_apk(asset, version, arch)
        if any(record[k] != actual[k] for k in actual):
            raise ValueError(f"Unmatched published APK: {name}")
    result = {key: record[key] for key in ("build", "size", "sha256")}
    if arch == "universal":
        result["abis"] = abis
    if version in FULL_UPDATES:
        return {**result, "full_only": True}
    delta = record.get("delta")
    if not isinstance(delta, dict):
        return result
    base = delta.get("from_version")
    if (delta.get("format") != "nld1" or not isinstance(base, str) or not re.fullmatch(VERSION, base)
            or not allows_delta(base, version) or type(delta.get("from_build")) is not int
            or not 0 < delta["from_build"] < record["build"] or not valid_sha(delta.get("from_sha256"))):
        return result
    patch = uploaded(release, patch_name(name, delta["from_sha256"], record["sha256"]))
    if (patch and valid_sha(delta.get("sha256"))
            and patch.get("digest") == "sha256:" + delta["sha256"]
            and type(delta.get("size")) is int and 0 < delta["size"] < record["size"]
            and delta["size"] == patch.get("size")):
        try:
            url = asset_url(patch, tag, mirror)
        except ValueError:
            return result
        result["delta"] = {key: delta[key] for key in
                           ("format", "from_version", "from_build", "from_sha256", "sha256", "size")}
        result["delta"]["url"] = url
    return result


def fetch_releases():
    headers = {"Accept": "application/vnd.github+json", "User-Agent": "nodelane-update-manifest"}
    token = os.environ.get("GH_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    releases = []
    page = 1
    while True:
        url = f"https://api.github.com/repos/{REPOSITORY}/releases?per_page=100&page={page}"
        with urlopen(Request(url, headers=headers), timeout=30) as response:
            batch = json.load(response)
        if not isinstance(batch, list):
            raise ValueError("Expected a GitHub release list")
        releases.extend(batch)
        if len(batch) < 100:
            return releases
        page += 1


def read_build(version):
    # Fetch the tagged source, not the build number in the current checkout.
    url = f"https://raw.githubusercontent.com/{REPOSITORY}/refs/tags/v{version}/pubspec.yaml"
    with urlopen(Request(url, headers={"User-Agent": "nodelane-update-manifest"}), timeout=30) as response:
        source = response.read().decode("utf-8")
    match = re.search(rf"^version:\s*{re.escape(version)}\+([1-9]\d*)\s*$", source, re.MULTILINE)
    if not match:
        raise ValueError(f"Tag v{version} has no matching app version/build")
    return int(match.group(1))


def asset_target(suffix):
    android = re.fullmatch(r"(android(?:-tv)?)-(arm64-v8a|armeabi-v7a|x86_64|x86|universal)\.apk", suffix)
    if android:
        return android.group(1), android.group(2), 0
    # The existing desktop packages don't advertise their CPU architecture.
    for platform, formats in {
        "ios": ["ipa"], "macos": ["dmg", "pkg"],
        "windows": ["exe", "msix", "zip"],
        "linux": ["appimage", "deb", "rpm", "zip"],
    }.items():
        for rank, extension in enumerate(formats):
            if suffix.lower() == f"{platform}.{extension}":
                return platform, "any", rank
    return None


def web_url(value):
    if not isinstance(value, str):
        raise ValueError("Expected an HTTP or HTTPS URL")
    parsed = urlsplit(value)
    if parsed.scheme not in ("http", "https") or not parsed.hostname:
        raise ValueError("Expected an HTTP or HTTPS URL")
    return parsed


def build_manifest(releases, build_for_version=read_build, download_base_url=None):
    mirror = web_url(download_base_url) if download_base_url is not None else None
    builds = {}

    def build_number(version):
        if version not in builds:
            value = build_for_version(version)
            if type(value) is not int or value <= 0:
                raise ValueError(f"Invalid build number for {version}")
            builds[version] = value
        return builds[version]

    candidates = {}
    invalid_urls = False
    for release in releases:
        if release.get("draft") or release.get("prerelease"):
            continue
        tag = release.get("tag_name", "")
        if not re.fullmatch("v" + VERSION, tag):
            continue
        version = tag[1:]
        order = tuple(map(int, version.split(".")))
        prefix = f"nodelane-comics-{tag}-"
        for asset in release.get("assets", []):
            name = asset.get("name", "")
            target = asset_target(name[len(prefix):]) if name.startswith(prefix) else None
            if target is None or asset.get("state") != "uploaded":
                continue
            platform, arch, rank = target
            try:
                url = asset_url(asset, tag, mirror)
                page_url = "" if mirror is not None else release.get("html_url") or ""
                if page_url:
                    web_url(page_url)
            except ValueError:
                invalid_urls = True
                print(f"Skipping {name}: invalid release URL", file=sys.stderr)
                continue
            entry = {
                "platform": platform, "arch": arch, "version": version,
                "notes": release.get("body") or "",
                "page_url": page_url, "url": url,
            }
            candidate = order, -rank, entry, release, asset
            key = platform, arch
            existing = candidates.get(key)
            if existing is None or candidate[:2] > existing[:2]:
                candidates[key] = candidate
            elif candidate[:2] == existing[:2] and (entry != existing[2] or asset != existing[4]):
                raise ValueError(f"Conflicting release assets for {key} at {version}")

    if invalid_urls and not candidates:
        raise ValueError("No release targets have valid URLs")
    updates = []
    for key in sorted(candidates):
        _, _, entry, release, asset = candidates[key]
        if entry["platform"] in ("android", "android-tv"):
            entry.update(android_delivery(release, asset, entry["arch"], mirror))
        else:
            entry["build"] = build_number(entry["version"])
        updates.append(entry)
    return {"schema": 1, "updates": updates}


def write_manifest(path, manifest):
    content = json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as file:
            temporary = Path(file.name)
            file.write(content)
        temporary.replace(path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build/app-updates/stable/index.json")
    parser.add_argument("--download-base-url", help="Serve packages from this URL under <tag>/<filename>")
    args = parser.parse_args(argv)
    try:
        manifest = build_manifest(fetch_releases(), download_base_url=args.download_base_url)
        write_manifest(args.output, manifest)
    except Exception as error:
        print(f"Update manifest generation failed: {error}", file=sys.stderr)
        return 1
    print(f"Generated {args.output} ({len(manifest['updates'])} targets). Upload this file manually.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
