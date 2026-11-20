import gzip
import hashlib
import io
import json
import os
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest
from unittest.mock import patch
from urllib.error import HTTPError
from zipfile import ZIP_DEFLATED, ZipFile

from apk_delta import create_patch
import generate_update_manifest as feed
from test_generate_update_manifest import release
import prepare_update_deltas as publisher
import android_apk


class DeltaReleaseTests(unittest.TestCase):
    def test_target_inspection_uses_apk_metadata_and_checks_the_release_signer(self):
        package = f"package: name='{feed.APP_ID}' versionCode='7421' versionName='0.2.0'\n"
        native = "native-code: 'arm64-v8a'\n"
        cert = "Signer #1 certificate SHA-256 digest: " + android_apk.SIGNER_SHA256
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "target.apk"
            p.write_bytes(b"package fixture")
            with patch.object(android_apk, "tool_output", side_effect=[package + native, cert]):
                self.assertEqual(android_apk.inspect_apk(p, "0.2.0", "arm64-v8a")["build"], 7421)
            for badging, signer in [
                (package + native, "Signer #1 certificate SHA-256 digest: " + "0" * 64),
                (package + native + "application-debuggable\n", cert),
                (package.replace("0.2.0", "0.1.4") + native, cert),
                (package.replace(feed.APP_ID, "different.package") + native, cert),
                (package + "native-code: 'x86_64'\n", cert),
            ]:
                with (
                    self.subTest(badging=badging, signer=signer),
                    patch.object(android_apk, "tool_output", side_effect=[badging, signer]),
                    self.assertRaises(ValueError),
                ):
                    android_apk.inspect_apk(p, "0.2.0", "arm64-v8a")

    def test_target_policy_barriers_and_manifest_asset_identity(self):
        suffix = "android-arm64-v8a.apk"
        old, base, target = [release(v, suffix) for v in ("0.1.4", "0.2.0", "0.2.2")]

        def asset_hash(digit):
            return {"digest": "sha256:" + digit * 64, "size": 1000}

        base["assets"][0].update(asset_hash("a"))
        apk = target["assets"][0]
        apk.update(asset_hash("b"))
        delta = {
            **apk,
            **asset_hash("c"),
            "size": 810,
            "name": feed.patch_name(apk["name"], "a" * 64, "b" * 64),
        }
        sidecar = {**apk, "name": apk["name"] + ".json"}
        target["assets"].extend([sidecar, delta])
        record = {
            "version": "0.2.2",
            "arch": "arm64-v8a",
            "abis": ["arm64-v8a"],
            "package": feed.APP_ID,
            "size": 1000,
            "sha256": "b" * 64,
            "build": 7333,
            "delta": {
                "format": "nld1",
                "from_version": "0.2.0",
                "from_build": 4321,
                "from_sha256": "a" * 64,
                "sha256": "c" * 64,
                "size": 810,
            },
        }
        all_releases = [old, target, base]

        def entry(mirror="https://cdn.test/packages"):
            with patch.object(feed, "read_record", return_value=record):
                return feed.build_manifest(all_releases, download_base_url=mirror)["updates"][0]

        self.assertEqual(entry()["build"], 7333)
        self.assertEqual(entry()["delta"]["from_build"], 4321)
        self.assertTrue(entry()["delta"]["url"].endswith("/v0.2.2/" + delta["name"]))
        self.assertEqual(entry()["delta"]["from_sha256"], "a" * 64)
        self.assertTrue(entry()["url"].endswith(".apk"))
        # Backfilling the previously absent intermediate ABI does not rewrite this recipe's base.
        before = entry()
        all_releases.append(release("0.2.1", suffix))
        self.assertEqual(before, entry())
        with patch.dict(apk, {"digest": "sha256:" + "d" * 64}):
            with self.assertRaises(ValueError):
                entry()
        for field, bad in [("state", "starter"), ("size", 801), ("digest", None)]:
            with patch.dict(delta, {field: bad}):
                self.assertNotIn("delta", entry())
        with patch.dict(delta, {"browser_download_url": ""}):
            self.assertNotIn("delta", entry(mirror=None))
        with patch.object(feed, "FULL_UPDATES", {"0.2.0", "0.2.2"}):
            self.assertTrue(entry()["full_only"])
            self.assertNotIn("delta", entry())
            self.assertIsNone(feed.previous_android([old, base], "0.2.3", suffix))
            self.assertEqual(feed.previous_android([old, base, target], "0.2.3", suffix)[0], "0.2.2")
        with patch.object(feed, "FULL_UPDATES", {"0.2.0", "0.2.1"}):
            self.assertNotIn("delta", entry())
        self.assertIsNone(feed.previous_android([old], "0.2.1", suffix))

    def test_release_pipeline_skips_full_only_and_unprofitable_patches(self):
        def package(payload):
            buf = io.BytesIO()
            with ZipFile(buf, "w", ZIP_DEFLATED) as apk:
                apk.writestr("engine.so", payload)
            return buf.getvalue()

        shared = os.urandom(160000)
        old = package(shared)
        prior = release("0.2.0", "android-arm64-v8a.apk")
        prior["assets"][0]["digest"] = "sha256:" + hashlib.sha256(old).hexdigest()

        def inspect(path, version, arch):
            return {
                "build": 350 if version == "0.2.0" else 900,
                "size": path.stat().st_size,
                "sha256": android_apk.file_sha(path),
                "version": version,
                "arch": arch,
                "abis": [arch],
                "package": feed.APP_ID,
            }

        with (
            tempfile.TemporaryDirectory() as tmp,
            patch.object(publisher, "fetch_releases", return_value=[prior]) as fetch,
            patch.object(publisher, "inspect_apk", side_effect=inspect),
        ):
            folder = Path(tmp)
            target = folder / "nodelane-comics-v0.2.1-android-arm64-v8a.apk"
            target.write_bytes(package(shared) + b"target")
            with patch.object(publisher, "FULL_UPDATES", {"0.2.1"}):
                publisher.prepare(folder, "v0.2.1")
                fetch.assert_not_called()
            for reuse in (False, True):
                target.write_bytes((old if reuse else package(os.urandom(160000))) + b"signed bytes")
                with patch.object(android_apk, "urlopen", return_value=io.BytesIO(old)):
                    publisher.prepare(folder, "v0.2.1")
                self.assertEqual(bool(list(folder.glob("patches/*.nld1"))), reuse)
                record = json.loads(target.with_suffix(".apk.json").read_bytes())
                self.assertEqual(record["build"], 900)
                self.assertEqual("delta" in record, reuse)
                if reuse:
                    self.assertEqual(record["delta"]["from_build"], 350)

    def test_old_tag_reissue_and_policy_change_round_trip_through_release_assets(self):
        def inspect(path, version, arch):
            return {
                "package": feed.APP_ID,
                "version": version,
                "arch": arch,
                "abis": [arch],
                "build": {"0.1.4": 257, "0.2.0": 6131, "0.2.1": 6143}[version],
                "sha256": android_apk.file_sha(path),
                "size": path.stat().st_size,
            }

        with (
            tempfile.TemporaryDirectory() as tmp,
            patch.object(publisher, "inspect_apk", side_effect=inspect),
        ):
            folder = Path(tmp)

            def make_release(version, patch_size):
                suffix = "android-x86_64.apk"
                rel = release(version, suffix)
                apk = folder / rel["assets"][0]["name"]
                apk.write_bytes(version.encode().ljust(1000, b"x"))
                with patch.object(
                    publisher,
                    "create_patch",
                    side_effect=lambda a, b, out: out.write_bytes(b"p" * patch_size),
                ):
                    publisher.prepare(folder, rel["tag_name"])
                paths = [apk, apk.with_suffix(".apk.json"), *(folder / "patches").glob(apk.name + "*.nld1")]
                rel["assets"] = [
                    {
                        "name": p.name,
                        "state": "uploaded",
                        "browser_download_url": "https://assets.example/" + p.name,
                        "digest": "sha256:" + android_apk.file_sha(p),
                        "size": p.stat().st_size,
                    }
                    for p in paths
                ]
                return rel

            with patch.object(
                publisher, "fetch_releases", side_effect=AssertionError("legacy/full-only needs no baseline")
            ):
                legacy = make_release("0.1.4", 0)
                base = make_release("0.2.0", 0)

            def read_local(request, timeout):
                return (folder / request.rsplit("/", 1)[1]).open("rb")

            with (
                patch.object(feed, "urlopen", side_effect=read_local),
                patch.object(android_apk, "urlopen", side_effect=read_local),
                patch.object(publisher, "fetch_releases", return_value=[legacy, base]),
            ):

                def entry(rel):
                    return feed.build_manifest([rel])["updates"][0]

                self.assertEqual(entry(legacy)["build"], 257)
                self.assertTrue(entry(base)["full_only"])
                self.assertNotIn("delta", entry(make_release("0.2.1", 810)))
                with patch.object(publisher, "MIN_SAVINGS_PERCENT", 19):
                    target = make_release("0.2.1", 810)
                patch_info = entry(target)["delta"]
                self.assertEqual(
                    (patch_info["from_version"], patch_info["from_build"], patch_info["size"]),
                    ("0.2.0", 6131, 810),
                )
                target["assets"].pop()  # Optional upload failed; keep the verified full target.
                self.assertEqual((entry(target)["build"], entry(target).get("delta")), (6143, None))

    def test_optional_baseline_failure_only_removes_that_patch_but_bad_target_blocks_release(self):
        def inspect(path, version, arch):
            return {
                "package": feed.APP_ID,
                "version": version,
                "arch": arch,
                "build": 4010 if version == "0.2.1" else 4009,
                "sha256": android_apk.file_sha(path),
                "size": path.stat().st_size,
            }

        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp)
            targets = [
                folder / f"nodelane-comics-v0.2.1-android-{arch}.apk" for arch in ("arm64-v8a", "x86_64")
            ]
            old = release("0.2.0", "android-arm64-v8a.apk", "android-x86_64.apk")
            for a in old["assets"]:
                a["digest"] = "sha256:" + "b" * 64
            for target in targets:
                target.write_bytes(b"valid target fixture")
            with (
                patch.object(publisher, "fetch_releases", return_value=[old]),
                patch.object(publisher, "inspect_apk", side_effect=inspect),
                patch.object(
                    android_apk,
                    "urlopen",
                    side_effect=[
                        HTTPError("https://cdn.test/base", 503, "unavailable", {}, None),
                        io.BytesIO(b"wrong baseline"),
                    ],
                ),
                patch.object(publisher, "create_patch") as patcher,
            ):
                publisher.prepare(folder, "v0.2.1")
                patcher.assert_not_called()
                for target in targets:
                    self.assertNotIn("delta", json.loads(target.with_suffix(".apk.json").read_bytes()))
            with (
                patch.object(publisher, "fetch_releases", side_effect=OSError("history unavailable")),
                patch.object(publisher, "inspect_apk", side_effect=inspect),
            ):
                publisher.prepare(folder, "v0.2.1")
                self.assertEqual(json.loads(targets[0].with_suffix(".apk.json").read_bytes())["build"], 4010)
            with (
                patch.object(publisher, "fetch_releases", return_value=[old]),
                patch.object(publisher, "inspect_apk", side_effect=ValueError("wrong signing certificate")),
                self.assertRaisesRegex(ValueError, "wrong signing"),
            ):
                publisher.prepare(folder, "v0.2.1")

    def test_android_decoder_round_trip_and_rejection(self):
        # Exercise the production decoder with the production writer, not a Python facsimile.
        with tempfile.TemporaryDirectory() as tmp:
            d = Path(tmp)
            a, b, delta, output = (d / name for name in ("base.apk", "target.apk", "patch", "result.apk"))
            shared = os.urandom(200000)
            for path, changed in [(a, b"old"), (b, b"new")]:
                with ZipFile(path, "w", ZIP_DEFLATED) as z:
                    z.writestr("classes.dex", changed * 1000)
                    z.writestr("lib/engine.so", shared)
                with path.open("ab") as f:
                    f.write(changed + b" trailing bytes")
            create_patch(a, b, delta)
            self.assertLess(delta.stat().st_size, b.stat().st_size // 4)
            harness = d / "DeltaCheck.java"
            harness.write_text("""
import com.nodelane.comics.ApkDelta;
import java.io.File;
public class DeltaCheck {
 public static void main(String[] a) throws Exception {
  ApkDelta.apply(new File(a[0]),new File(a[1]),new File(a[2]),Long.parseLong(a[3]),a[4]);
 }
}""")
            decoder = feed.ROOT / "android/app/src/main/java/com/nodelane/comics/ApkDelta.java"
            subprocess.run(["javac", "-d", str(d), str(decoder), str(harness)], check=True)
            size = b.stat().st_size
            digest = hashlib.sha256(b.read_bytes()).hexdigest()

            def apply(length=size, sha=digest):
                return subprocess.run(
                    ["java", "-cp", str(d), "DeltaCheck", str(a), str(delta), str(output), str(length), sha],
                    capture_output=True,
                ).returncode

            self.assertEqual(apply(), 0)
            self.assertEqual(b.read_bytes(), output.read_bytes())
            for length, sha in [(size - 1, digest), (size + 1, digest), (size, "0" * 64)]:
                self.assertNotEqual(apply(length, sha), 0)
                self.assertFalse(output.exists())
            intact = delta.read_bytes()
            for damaged in [
                intact[:-6],
                b"not a patch",
                gzip.compress(b"NLD1C" + struct.pack(">QQ", size + 1, 32)),
                gzip.compress(b"NLD1L" + struct.pack(">Q", size + 1)),
                gzip.compress(b"NLD1E"),
            ]:
                delta.write_bytes(damaged)
                self.assertNotEqual(apply(), 0)
                self.assertFalse(output.exists())
            delta.write_bytes(intact)
            a.write_bytes(b"wrong base")
            self.assertNotEqual(apply(), 0)
            self.assertFalse(output.exists())
