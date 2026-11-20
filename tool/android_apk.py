"""Identity of a release artifact, taken from its signed bytes (Android Build Tools on PATH)."""

import hashlib
import re
import shlex
import shutil
import subprocess
import tempfile
from pathlib import Path
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parent.parent
APP_ID = "com.nodelane.comics"
SIGNER_SHA256 = "88e9e506650f50c76cb4ef8bb70ecaf885723d81f12417c6064270e4d5d804bc"
SHA = re.compile(r"[0-9a-f]{64}")


def file_sha(path):
    with path.open("rb") as file:
        return hashlib.file_digest(file, "sha256").hexdigest()


def valid_sha(value):
    return isinstance(value, str) and SHA.fullmatch(value) is not None


def asset_sha(asset):
    digest = asset.get("digest")
    if digest is None:
        return None
    if not isinstance(digest, str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", digest):
        raise ValueError(f"Invalid digest for {asset['name']}")
    return digest[7:]


def download_asset(asset, path):
    with urlopen(asset["browser_download_url"], timeout=90) as response, path.open("wb") as file:
        shutil.copyfileobj(response, file)
    digest = file_sha(path)
    if (asset.get("size") is not None and asset["size"] != path.stat().st_size) or asset_sha(asset) not in (
        None,
        digest,
    ):
        raise ValueError(f"Published bytes do not match {asset['name']}")
    return digest


def tool_output(tool, *args):
    executable = shutil.which(tool)
    if not executable:
        raise RuntimeError(f"Add Android SDK build-tools to PATH: missing {tool}")
    return subprocess.check_output([executable, *args], encoding="utf-8", errors="replace")


def inspect_apk(path, version, arch):
    badging = tool_output("aapt2", "dump", "badging", str(path))
    package = re.search(r"^package: (.*)$", badging, re.M)
    fields = dict(re.findall(r"(\w+)='([^']*)'", package[1])) if package else {}
    native = re.search(r"^native-code:\s*(.*)$", badging, re.M)
    abis = set(shlex.split(native[1])) if native else set()
    build = (int(fields.get("versionCodeMajor", 0)) << 32) | int(fields.get("versionCode", 0))
    if (
        fields.get("name") != APP_ID
        or fields.get("versionName") != version
        or build <= 0
        or not abis
        or (arch == "universal" and len(abis) < 2)
        or (arch != "universal" and abis != {arch})
        or "application-debuggable" in badging.splitlines()
    ):
        raise ValueError(f"APK identity does not match release {version}/{arch}: {path.name}")
    certs = set(
        re.findall(
            r"^.*certificate SHA-256 digest:\s*([0-9a-f]{64})\s*$",
            tool_output("apksigner", "verify", "--print-certs", str(path)),
            re.M,
        )
    )
    if certs != {SIGNER_SHA256}:
        raise ValueError(f"Unexpected release signer: {path.name}")
    return {
        "package": APP_ID,
        "version": version,
        "arch": arch,
        "abis": sorted(abis),
        "build": build,
        "size": path.stat().st_size,
        "sha256": file_sha(path),
    }


def published_apk(asset, version, arch):
    # Legacy releases have no identity record; inspect the APK, never infer the build from its tag.
    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp) / "published.apk"
        download_asset(asset, path)
        return inspect_apk(path, version, arch)
