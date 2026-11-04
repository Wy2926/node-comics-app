"""Generate the NodeLane sideloading source from its public stable IPA releases."""

import json
import plistlib
import re
import sys
import tempfile
from datetime import datetime
from pathlib import Path
from urllib.parse import quote
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parent.parent


def load_config(config_path: Path) -> dict:
    return json.loads(config_path.read_text(encoding="utf-8"))


def fetch_all_releases(repo_url: str) -> list:
    """Fetch every page once; an inaccessible repository is an error, not empty."""
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "nodelane-comics-source",
    }
    # Public requests also ensure published download links need no credentials.
    releases = []
    page = 1
    while True:
        url = f"https://api.github.com/repos/{repo_url}/releases?per_page=100&page={page}"
        with urlopen(Request(url, headers=headers), timeout=30) as response:
            batch = json.load(response)
        if not isinstance(batch, list):
            raise ValueError("GitHub releases response must be a list")
        releases.extend(batch)
        if len(batch) < 100:
            return releases
        page += 1


def format_description(description: str) -> str:
    # Keep URLs, hyphens and Markdown bullets intact.
    description = re.sub(r"<[^<]+?>", "", description)
    return re.sub(r"^#{1,6}\s+", "", description, flags=re.MULTILINE).strip()


def find_ipa(config: dict, release: dict):
    tag = release["tag_name"]
    name = f"{config['app_slug']}-{tag}-ios.ipa"
    matches = [asset for asset in release["assets"] if asset["name"] == name]
    if not matches:
        return None
    if len(matches) != 1:
        raise ValueError(f"Ambiguous IPA assets for {tag}")
    asset = matches[0]
    expected_url = (
        f"https://github.com/{config['repo_url']}/releases/download/"
        f"{quote(tag, safe='')}/{quote(name, safe='')}"
    )
    if (
        asset["browser_download_url"] != expected_url
        or asset.get("state") != "uploaded"
        or type(asset["size"]) is not int
        or asset["size"] <= 0
    ):
        raise ValueError(f"Invalid NodeLane IPA asset for {tag}")
    return asset


def app_permissions() -> dict:
    """Use native declarations, not the inherited upstream permission list."""
    with (ROOT / "ios/Runner/Info.plist").open("rb") as file:
        info = plistlib.load(file)
    with (ROOT / "ios/Runner/NodeLane.entitlements").open("rb") as file:
        entitlements = plistlib.load(file)
    return {
        "entitlements": sorted(entitlements),
        "privacy": {
            key: value for key, value in info.items() if key.endswith("UsageDescription")
        },
    }


def build_source(config: dict, releases: list) -> dict:
    """Rebuild instead of merging old apps, versions or news into a new identity."""
    repository = f"https://github.com/{config['repo_url']}"
    icon = (
        f"https://raw.githubusercontent.com/{config['repo_url']}/refs/heads/main/"
        f"{config['icon_path']}"
    )
    source = {
        "name": config["app_name"],
        "identifier": f"{config['app_id']}.source",
        "website": repository,
        "iconURL": icon,
        "subtitle": config["subtitle"],
        "description": config["description"],
        "tintColor": config["tint_colour"],
        "apps": [],
        "news": [],
    }

    candidates = []
    for release in releases:
        if release["draft"] or release["prerelease"]:
            continue
        match = re.fullmatch(
            r"v?((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))",
            release["tag_name"],
        )
        if not match:
            continue
        asset = find_ipa(config, release)
        if asset is None:
            continue
        date = datetime.fromisoformat(release["published_at"].replace("Z", "+00:00"))
        if date.tzinfo is None:
            raise ValueError("Release date must include a timezone")
        version = match.group(1)
        candidates.append(
            (tuple(map(int, version.split("."))), date, version, release, asset)
        )

    # A later backport must not become an update over a higher version.
    candidates.sort(key=lambda item: (item[0], item[1]), reverse=True)
    versions = []
    seen = set()
    for _, _, version, release, asset in candidates:
        if version in seen:
            continue
        seen.add(version)
        description = format_description(release["body"] or "")
        versions.append({
            "version": version,
            "date": release["published_at"],
            "localizedDescription": description,
            "downloadURL": asset["browser_download_url"],
            "size": asset["size"],
            "minOSVersion": config["min_os_version"],
        })
        source["news"].append({
            "appID": config["app_id"],
            "title": f"{config['app_name']} {version}",
            "identifier": f"{config['app_slug']}-release-{version}",
            "caption": config["caption"],
            "date": release["published_at"],
            "tintColor": config["tint_colour"],
            "notify": True,
            "url": f"{repository}/releases/tag/{quote(release['tag_name'], safe='')}",
        })

    # An app without a downloadable version is not an installable listing.
    if versions:
        latest = versions[0]
        source["apps"] = [{
            "name": config["app_name"],
            "bundleIdentifier": config["app_id"],
            "developerName": config["developer_name"],
            "subtitle": config["subtitle"],
            "localizedDescription": config["description"],
            "iconURL": icon,
            "tintColor": config["tint_colour"],
            "category": "entertainment",
            "versions": versions,
            "appPermissions": app_permissions(),
            # Retain the legacy fields used by older sideloading clients.
            "version": latest["version"],
            "versionDate": latest["date"],
            "versionDescription": latest["localizedDescription"],
            "downloadURL": latest["downloadURL"],
            "size": latest["size"],
        }]
    return source


def update_json_file(config: dict, releases: list) -> None:
    content = json.dumps(build_source(config, releases), ensure_ascii=False, indent=2) + "\n"
    target = ROOT / config["json_file"]
    # Do not truncate the existing feed if fetching, validation or writing fails.
    temp_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", encoding="utf-8", dir=target.parent, delete=False
        ) as file:
            temp_path = Path(file.name)
            file.write(content)
        temp_path.replace(target)
    finally:
        if temp_path is not None:
            temp_path.unlink(missing_ok=True)


def main() -> int:
    try:
        config = load_config(ROOT / "repo/config.json")
        releases = fetch_all_releases(config["repo_url"])
        update_json_file(config, releases)
    except Exception as error:
        print(f"Source update failed: {error}", file=sys.stderr)
        return 1
    print(f"Updated {config['json_file']} from public NodeLane releases.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
