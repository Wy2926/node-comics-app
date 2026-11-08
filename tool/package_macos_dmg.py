"""Package the built NodeLane macOS app as an installable disk image."""

import argparse
from pathlib import Path
import plistlib
import re
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]


def package_dmg(app: Path, output_dir: Path) -> Path:
    app = app.resolve()
    info = plistlib.loads((app / "Contents/Info.plist").read_bytes())
    if info.get("CFBundleIdentifier") != "com.nodelane.comics":
        raise ValueError("Expected the NodeLane macOS bundle identifier")
    version = info.get("CFBundleShortVersionString", "")
    if not re.fullmatch(r"(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)", version):
        raise ValueError("Expected a stable app version")
    if not re.fullmatch(r"[1-9]\d*", info.get("CFBundleVersion", "")):
        raise ValueError("Expected a positive build number")
    icon = app / "Contents/Resources/AppIcon.icns"
    if not icon.is_file():
        raise ValueError("The macOS app icon is missing")
    subprocess.run(["codesign", "--verify", "--deep", "--strict", str(app)], check=True)

    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    target = output_dir / f"nodelane-comics-v{version}-macos.dmg"
    with tempfile.TemporaryDirectory(prefix=".nodelane-dmg-", dir=output_dir) as temporary:
        staging = Path(temporary)
        volume = staging / "volume"
        volume.mkdir()
        subprocess.run(["ditto", str(app), str(volume / "nodelane-comics.app")], check=True)
        (volume / "Applications").symlink_to("/Applications", target_is_directory=True)
        shutil.copyfile(icon, volume / ".VolumeIcon.icns")

        # Keep attribution outside the signed app bundle.
        legal = volume / "Licenses"
        legal.mkdir()
        for source in (
            ROOT / "LICENSE",
            ROOT / "UPSTREAM.md",
            ROOT / "assets/brand/LICENSE-GPL-3.0-only",
            ROOT / "docs/design/nodelane-brand-assets.md",
        ):
            shutil.copyfile(source, legal / source.name)

        writable = staging / "writable.dmg"
        subprocess.run(
            [
                "hdiutil", "create", "-quiet", "-fs", "HFS+", "-format", "UDRW",
                "-volname", f"nodelane-comics-v{version}",
                "-srcfolder", str(volume), str(writable),
            ],
            check=True,
        )
        mount = staging / "mount"
        mount.mkdir()
        subprocess.run(
            ["hdiutil", "attach", "-quiet", "-nobrowse", "-mountpoint", str(mount), str(writable)],
            check=True,
        )
        try:
            subprocess.run(["xcrun", "SetFile", "-a", "C", str(mount)], check=True)
        finally:
            detached = subprocess.run(["hdiutil", "detach", "-quiet", str(mount)])
            if detached.returncode:
                subprocess.run(["hdiutil", "detach", "-quiet", "-force", str(mount)], check=True)
        image = staging / target.name
        subprocess.run(
            ["hdiutil", "convert", "-quiet", str(writable), "-format", "UDZO", "-o", str(image)],
            check=True,
        )
        subprocess.run(["hdiutil", "verify", "-quiet", str(image)], check=True)
        image.replace(target)
    return target


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--app", type=Path,
        default=ROOT / "build/macos/Build/Products/Release/nodelane-comics.app",
    )
    parser.add_argument("--output-dir", type=Path, default=ROOT / "build/macos/dmg")
    args = parser.parse_args()
    print(package_dmg(args.app, args.output_dir))


if __name__ == "__main__":
    main()
