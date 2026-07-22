#!/usr/bin/python3
from __future__ import annotations

import importlib.machinery
import importlib.util
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

HELPER = Path(__file__).parents[1] / "system" / "noctalia-battery-threshold-helper"
loader = importlib.machinery.SourceFileLoader("battery_threshold_helper", str(HELPER))
spec = importlib.util.spec_from_loader(loader.name, loader)
helper = importlib.util.module_from_spec(spec)
loader.exec_module(helper)


class HelperTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        root = Path(self.temp.name)
        helper.SYSFS_ROOT = root / "sys"
        helper.STATE_DIR = root / "state"
        helper.STATE_FILE = helper.STATE_DIR / "overrides.json"
        helper.HWDB_FILE = root / "etc" / "61-noctalia-battery-threshold.hwdb"
        helper.RUN_DIR = root / "run"
        helper.LOCK_FILE = helper.STATE_DIR / "operations.lock"
        battery = helper.SYSFS_ROOT / "BAT0"
        battery.mkdir(parents=True)
        (battery / "type").write_text("Battery\n", encoding="ascii")

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_threshold_validation(self) -> None:
        self.assertEqual(helper.validate_thresholds("70", "80"), (70, 80))
        for values in (("80", "80"), ("90", "80"), ("-1", "80"), ("x", "80")):
            with self.assertRaises(helper.HelperError):
                helper.validate_thresholds(*values)

    def test_battery_validation_rejects_non_battery_and_bad_name(self) -> None:
        self.assertEqual(helper.battery_path("BAT0"), helper.SYSFS_ROOT / "BAT0")
        with self.assertRaises(helper.HelperError):
            helper.battery_path("../BAT0")
        ac = helper.SYSFS_ROOT / "AC"
        ac.mkdir()
        (ac / "type").write_text("Mains\n", encoding="ascii")
        with self.assertRaises(helper.HelperError):
            helper.battery_path("AC")

    def test_trigger_passes_sysfs_path_as_positional_device(self) -> None:
        commands = []

        def fake_run(command, *, check=True):
            commands.append(command)
            class Result:
                returncode = 0
                stdout = ""
                stderr = ""
            return Result()

        with patch.object(helper, "run", side_effect=fake_run):
            helper.trigger("BAT0")
        self.assertEqual(
            commands[0],
            [helper.UDEVADM, "trigger", "--action=change", str(helper.SYSFS_ROOT / "BAT0")],
        )
        self.assertNotIn("--path", commands[0])

    def test_threshold_write_preserves_valid_intermediate_order(self) -> None:
        battery = helper.SYSFS_ROOT / "BAT0"
        start_file = battery / "charge_control_start_threshold"
        end_file = battery / "charge_control_end_threshold"
        start_file.write_text("75\n", encoding="ascii")
        end_file.write_text("80\n", encoding="ascii")
        helper.write_sysfs_thresholds("BAT0", 40, 60)
        self.assertEqual(start_file.read_text(encoding="ascii"), "40\n")
        self.assertEqual(end_file.read_text(encoding="ascii"), "60\n")
        helper.write_sysfs_thresholds("BAT0", 90, 100)
        self.assertEqual(start_file.read_text(encoding="ascii"), "90\n")
        self.assertEqual(end_file.read_text(encoding="ascii"), "100\n")

    def test_refuses_unowned_hwdb_file(self) -> None:
        helper.HWDB_FILE.parent.mkdir(parents=True)
        helper.HWDB_FILE.write_text("# administrator file\n", encoding="utf-8")
        with self.assertRaises(helper.HelperError):
            helper.ensure_managed_hwdb()

    def test_state_and_hwdb_are_plugin_scoped(self) -> None:
        devices = {
            "BAT1": {"start": 40, "end": 60},
            "BAT0": {"start": 70, "end": 80, "original_start": 75, "original_end": 80},
        }
        helper.save_state(devices)
        self.assertEqual(helper.load_state(), devices)
        rendered = helper.render_hwdb(devices)
        self.assertIn("battery:BAT0:*:dmi:*\n CHARGE_LIMIT=70,80", rendered)
        self.assertIn("battery:BAT1:*:dmi:*\n CHARGE_LIMIT=40,60", rendered)
        self.assertNotIn("/usr/lib/udev", rendered)


if __name__ == "__main__":
    unittest.main()
