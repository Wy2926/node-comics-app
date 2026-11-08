"""Generate a public update feed for manual upload; never deploy to a server."""

import argparse
import json
import os
import re
import sys
import tempfile
from pathlib import Path
from urllib.parse import quote, urlsplit
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parent.parent
REPOSITORY = "Wy2926/node-comics-app"
VERSION = r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"


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
    candidates = {}
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
            if mirror is not None:
                path = f"{mirror.path.rstrip('/')}/{quote(tag, safe='')}/{quote(name, safe='')}"
                url = mirror._replace(path=path).geturl()
            else:
                url = asset.get("browser_download_url")
                web_url(url)
            page_url = "" if mirror is not None else release.get("html_url") or ""
            if page_url:
                web_url(page_url)
            candidate = (order, -rank, {
                "platform": platform, "arch": arch, "version": version,
                "notes": release.get("body") or "",
                "page_url": page_url, "url": url,
            })
            key = platform, arch
            existing = candidates.get(key)
            if existing is None or candidate[:2] > existing[:2]:
                candidates[key] = candidate
            elif candidate[:2] == existing[:2] and candidate[2] != existing[2]:
                raise ValueError(f"Conflicting release assets for {key} at {version}")

    builds = {}
    updates = []
    for key in sorted(candidates):
        entry = candidates[key][2]
        version = entry["version"]
        if version not in builds:
            builds[version] = build_for_version(version)
        build = builds[version]
        if type(build) is not int or build <= 0:
            raise ValueError(f"Invalid build number for {version}")
        updates.append({**entry, "build": build})
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
