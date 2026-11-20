"""Verify release APKs and freeze their optional patch baselines before upload."""

import argparse
import re
import sys
import tempfile
from pathlib import Path
from urllib.error import HTTPError

from android_apk import asset_sha, download_asset, file_sha, inspect_apk
from apk_delta import create_patch
from generate_update_manifest import (
    FULL_UPDATES,
    VERSION,
    asset_target,
    fetch_releases,
    patch_name,
    previous_android,
    version_key,
    write_manifest,
)

MIN_SAVINGS_PERCENT = 20


def optional_patch(apk, target, prior):
    version, asset = prior
    if not asset_sha(asset):
        raise ValueError("Missing published baseline digest")
    with tempfile.TemporaryDirectory(dir=apk.parent) as folder:
        base = Path(folder) / "base.apk"
        digest = download_asset(asset, base)
        old = inspect_apk(base, version, target["arch"])
        if old["build"] >= target["build"]:
            raise ValueError("Baseline is not an older Android build")
        patch = Path(folder) / "change.nld1"
        create_patch(base, apk, patch)
        size = patch.stat().st_size
        if size * 100 > target["size"] * (100 - MIN_SAVINGS_PERCENT):
            return
        sha = file_sha(patch)
        output = apk.parent / "patches"
        output.mkdir(exist_ok=True)
        patch.replace(output / patch_name(apk.name, digest, target["sha256"]))
        return {
            "format": "nld1",
            "from_version": version,
            "from_build": old["build"],
            "from_sha256": digest,
            "sha256": sha,
            "size": size,
        }


def prepare(directory, tag):
    if not re.fullmatch("v" + VERSION, tag):
        raise ValueError("Expected a stable version tag")
    version = tag[1:]
    prefix = f"nodelane-comics-{tag}-"
    releases = None
    apks = sorted(directory.glob(prefix + "*.apk"))
    if apks and version not in FULL_UPDATES and version_key(version) > (0, 2, 0):
        try:
            releases = fetch_releases()
        except Exception as error:
            print(f"Full APKs only: release history unavailable ({type(error).__name__})", file=sys.stderr)
    for apk in apks:
        suffix = apk.name.removeprefix(prefix)
        target = asset_target(suffix)
        if not target:
            raise ValueError(f"Unrecognized release APK: {apk.name}")
        # A bad NEW artifact is a release failure, even on a full-only release.
        record = inspect_apk(apk, version, target[1])
        if releases is not None:
            try:
                prior = previous_android(releases, version, suffix)
                if prior is None:
                    print(f"{apk.name}: full APK only (no matching baseline)", file=sys.stderr)
                elif delta := optional_patch(apk, record, prior):
                    record["delta"] = delta
            except Exception as error:
                reason = f"HTTP {error.code}" if isinstance(error, HTTPError) else type(error).__name__
                print(f"{apk.name}: skipping optional patch ({reason})", file=sys.stderr)
        write_manifest(apk.with_name(apk.name + ".json"), record)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    parser.add_argument("tag")
    args = parser.parse_args()
    prepare(args.directory, args.tag)
