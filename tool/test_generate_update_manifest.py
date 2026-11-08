"""Generator contract, target isolation and failure recovery."""
import copy
import io
import json
import tempfile
import unittest
from contextlib import redirect_stderr, redirect_stdout
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError

import generate_update_manifest as generator


def release(version, *suffixes):
    tag = f"v{version}"
    return {
        "tag_name": tag, "draft": False, "prerelease": False, "body": f"更新 {version}",
        "html_url": f"https://github.com/{generator.REPOSITORY}/releases/tag/{tag}",
        "assets": [{
            "name": f"nodelane-comics-{tag}-{suffix}", "state": "uploaded",
            "browser_download_url": f"https://github.com/{generator.REPOSITORY}/releases/download/{tag}/nodelane-comics-{tag}-{suffix}",
        } for suffix in suffixes],
    }


def fixture_releases():
    return [
        release("0.1.0", "android-universal.apk", "windows.zip", "windows.exe", "linux.deb", "linux.AppImage"),
        release("0.2.0", "android-arm64-v8a.apk", "android-armeabi-v7a.apk", "ios.ipa"),
        release("0.3.0", "android-x86_64.apk", "android-tv-arm64-v8a.apk", "macos.dmg"),
    ]


class ManifestTests(unittest.TestCase):
    def test_generated_contract_keeps_latest_per_target_and_is_deterministic(self):
        releases = fixture_releases()
        ignored = release("9.0.0", "ios.ipa")
        ignored["draft"] = True
        pending = release("8.0.0", "android-arm64-v8a.apk")
        pending["assets"][0]["state"] = "starter"
        beta = release("7.0.0-beta", "ios.ipa")
        prerelease = release("6.0.0", "ios.ipa")
        prerelease["prerelease"] = True
        no_package = release("5.0.0", "source.tar.gz")
        reader = lambda version: int(version.split(".")[1])
        manifest = generator.build_manifest(releases + [ignored, pending, beta, prerelease, no_package], reader)
        fixture = generator.ROOT / "test/fixtures/app_update_manifest.json"
        self.assertEqual(manifest, json.loads(fixture.read_text()))
        self.assertEqual(manifest, generator.build_manifest(list(reversed(releases)), reader))
        self.assertEqual(generator.build_manifest([]), {"schema": 1, "updates": []})

    def test_invalid_metadata_or_network_never_overwrites_existing_file(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "index.json"
            target.write_text("previous feed")
            for value in [None, "file:///a.apk"]:
                with self.subTest(url=value):
                    candidate = release("0.2.0", "android-arm64-v8a.apk")
                    candidate["assets"][0]["browser_download_url"] = value
                    with patch.object(generator, "fetch_releases", return_value=[candidate]), redirect_stderr(io.StringIO()):
                        self.assertEqual(generator.main(["--output", str(target)]), 1)
                    self.assertEqual(target.read_text(), "previous feed")
            with patch.object(generator, "fetch_releases", side_effect=TimeoutError("offline")), redirect_stderr(io.StringIO()):
                self.assertEqual(generator.main(["--output", str(target)]), 1)
            self.assertEqual(target.read_text(), "previous feed")
            with patch.object(generator, "fetch_releases", return_value=[]), redirect_stdout(io.StringIO()):
                self.assertEqual(generator.main(["--output", str(target)]), 0)
            self.assertEqual(json.loads(target.read_text()), {"schema": 1, "updates": []})

    def test_cli_uses_source_urls_or_download_mirror(self):
        candidate = release("0.2.0", "macos.dmg")
        asset_url = "https://cdn.example:8443/get?package=app.dmg#download"
        page_url = "http://example.org:8080/updates?version=0.2.0"
        candidate["assets"][0]["browser_download_url"] = asset_url
        candidate["html_url"] = page_url
        for mirror in [None, "http://cdn.example:8080/packages?key=example"]:
            with self.subTest(mirror=mirror), tempfile.TemporaryDirectory() as directory:
                target = Path(directory) / "index.json"
                args = ["--output", str(target)]
                if mirror is not None:
                    args += ["--download-base-url", mirror]
                with patch.object(generator, "fetch_releases", return_value=[candidate]), \
                        patch.object(generator, "urlopen", return_value=io.BytesIO(b"version: 0.2.0+2\n")), \
                        redirect_stdout(io.StringIO()):
                    self.assertEqual(generator.main(args), 0)
                entry = json.loads(target.read_text())["updates"][0]
                self.assertEqual(entry["url"], asset_url if mirror is None else
                    "http://cdn.example:8080/packages/v0.2.0/nodelane-comics-v0.2.0-macos.dmg?key=example")
                self.assertEqual(entry["page_url"], page_url if mirror is None else "")

    def test_pagination_failure_does_not_return_partial_releases(self):
        first = [copy.deepcopy(release("0.1.0", "ios.ipa")) for _ in range(100)]
        error = HTTPError("https://api.github.com/", 503, "Unavailable", {}, None)
        with patch.object(generator, "urlopen", side_effect=[io.BytesIO(json.dumps(first).encode()), error]):
            with self.assertRaises(HTTPError):
                generator.fetch_releases()
        with patch.object(generator, "urlopen", side_effect=[io.BytesIO(json.dumps(first).encode()), io.BytesIO(b"[]")]) as fetch:
            self.assertEqual(generator.fetch_releases(), first)
            self.assertIn("page=2", fetch.call_args.args[0].full_url)

    def test_build_number_comes_from_matching_tag(self):
        with patch.object(generator, "urlopen", return_value=io.BytesIO(b"version: 0.2.0+27\n")) as fetch:
            self.assertEqual(generator.read_build("0.2.0"), 27)
            self.assertIn("refs/tags/v0.2.0/pubspec.yaml", fetch.call_args.args[0].full_url)
        with patch.object(generator, "urlopen", return_value=io.BytesIO(b"version: 0.1.0+27\n")):
            with self.assertRaises(ValueError):
                generator.read_build("0.2.0")

    def test_failed_replace_preserves_file_and_removes_temporary_file(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "index.json"
            target.write_text("previous feed")
            with patch.object(Path, "replace", side_effect=OSError("disk error")):
                with self.assertRaises(OSError):
                    generator.write_manifest(target, {"schema": 1, "updates": []})
            self.assertEqual(target.read_text(), "previous feed")
            self.assertEqual(list(target.parent.iterdir()), [target])


if __name__ == "__main__":
    unittest.main()
