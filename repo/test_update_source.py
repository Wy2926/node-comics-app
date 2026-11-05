"""Release isolation, deterministic regeneration and failure recovery checks."""

import copy
import io
import json
import tempfile
import unittest
from contextlib import redirect_stderr
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError

import update_source as updater


class SourceUpdaterTests(unittest.TestCase):
    def setUp(self):
        self.config = updater.load_config(updater.ROOT / "repo/config.json")
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.target = Path(self.temp.name) / "source.json"
        self.config["json_file"] = str(self.target)

    def release(self, tag="v0.1.0", date="2026-11-01T10:00:00Z"):
        name = f"nodelane-comics-{tag}-ios.ipa"
        return {
            "tag_name": tag,
            "published_at": date,
            "draft": False,
            "prerelease": False,
            "body": "## Changes\n- See https://github.com/Wy2926/node-comics-app/issues/1",
            "assets": [{
                "name": name,
                "state": "uploaded",
                "size": 123456,
                "browser_download_url": (
                    "https://github.com/Wy2926/node-comics-app/releases/download/"
                    f"{tag}/{name}"
                ),
            }],
        }

    def test_only_stable_own_ipas_are_listed_and_latest_fields_agree(self):
        stable = self.release("v0.2.0")
        backport = self.release(date="2026-11-02T10:00:00Z")
        draft = self.release("v0.3.0")
        draft["draft"] = True
        prerelease = self.release("v0.4.0")
        prerelease["prerelease"] = True
        beta_tag = self.release("v0.5.0-beta")
        missing = self.release("v0.6.0")
        missing["assets"] = []
        upstream = self.release("v0.9.9")
        upstream["assets"][0]["name"] = "Mangayomi-v0.9.9-ios.ipa"
        releases = [missing, upstream, draft, prerelease, beta_tag, stable, backport]
        source = updater.build_source(self.config, releases)
        app = source["apps"][0]
        self.assertEqual([v["version"] for v in app["versions"]], ["0.2.0", "0.1.0"])
        self.assertEqual(app["bundleIdentifier"], "com.nodelane.comics")
        for legacy, current in (("version", "version"), ("versionDate", "date"),
                                ("downloadURL", "downloadURL"), ("size", "size"),
                                ("versionDescription", "localizedDescription")):
            self.assertEqual(app[legacy], app["versions"][0][current])
        self.assertEqual(len(source["news"]), 2)
        self.assertTrue(all(n["appID"] == app["bundleIdentifier"] for n in source["news"]))
        self.assertIn("node-comics-app/issues/1", app["versionDescription"])
        permissions = app["appPermissions"]
        self.assertIn("NSFaceIDUsageDescription", permissions["privacy"])
        self.assertNotIn("aps-environment", permissions["entitlements"])

    def test_regeneration_removes_old_entries_and_is_repeatable(self):
        self.target.write_text('{"apps":[{"name":"Mangayomi"}],"news":[{}]}')
        release = self.release()
        # Duplicate tags for one version resolve to the newer publication.
        duplicate = self.release("0.1.0", "2026-11-02T10:00:00Z")
        updater.update_json_file(self.config, [release, duplicate])
        first = self.target.read_bytes()
        updater.update_json_file(self.config, [duplicate, release])
        self.assertEqual(first, self.target.read_bytes())
        data = json.loads(first)
        self.assertEqual(len(data["apps"][0]["versions"]), 1)
        self.assertEqual(len(data["news"]), 1)
        self.assertEqual(data["apps"][0]["versionDate"], duplicate["published_at"])
        self.assertNotIn("Mangayomi", first.decode())
        # A withdrawn final IPA must leave no stale download or news entry.
        updater.update_json_file(self.config, [])
        empty = json.loads(self.target.read_text())
        self.assertEqual(empty["apps"], [])
        self.assertEqual(empty["news"], [])

    def test_invalid_asset_preserves_existing_file(self):
        self.target.write_text("previous feed")
        for field, value in (
            ("browser_download_url", "https://github.com/kodjodevf/mangayomi/releases/download/v0.1.0/old.ipa"),
            ("size", 0),
            ("state", "starter"),
        ):
            with self.subTest(field=field):
                release = self.release()
                release["assets"][0][field] = value
                with self.assertRaises(ValueError):
                    updater.update_json_file(self.config, [release])
                self.assertEqual(self.target.read_text(), "previous feed")

    def test_failed_file_replace_preserves_feed_and_cleans_temporary_file(self):
        self.target.write_text("previous feed")
        with patch.object(Path, "replace", side_effect=OSError("disk error")):
            with self.assertRaises(OSError):
                updater.update_json_file(self.config, [self.release()])
        self.assertEqual(self.target.read_text(), "previous feed")
        self.assertEqual(list(self.target.parent.iterdir()), [self.target])

    def test_fetches_all_pages_once_without_credentials(self):
        first = [copy.deepcopy(self.release()) for _ in range(100)]
        last = self.release("v0.2.0")
        responses = [io.BytesIO(json.dumps(page).encode()) for page in (first, [last])]
        with patch.object(updater, "urlopen", side_effect=responses) as fetch:
            result = updater.fetch_all_releases(self.config["repo_url"])
        self.assertEqual(len(result), 101)
        self.assertEqual(result[-1], last)
        for index, call in enumerate(fetch.call_args_list, start=1):
            self.assertIn(f"page={index}", call.args[0].full_url)
            self.assertNotIn("Authorization", call.args[0].headers)
            self.assertEqual(call.kwargs["timeout"], 30)

    def test_fetch_failure_exits_unsuccessfully_and_preserves_feed(self):
        self.target.write_text("previous feed")
        errors = [
            HTTPError("https://api.github.com/", 404, "Not Found", {}, None),
            TimeoutError("request timed out"),
            ValueError("invalid JSON"),
        ]
        for error in errors:
            with self.subTest(error=type(error).__name__):
                with patch.object(updater, "load_config", return_value=self.config), \
                     patch.object(updater, "urlopen", side_effect=error), \
                     redirect_stderr(io.StringIO()):
                    self.assertEqual(updater.main(), 1)
                self.assertEqual(self.target.read_text(), "previous feed")


if __name__ == "__main__":
    unittest.main()
