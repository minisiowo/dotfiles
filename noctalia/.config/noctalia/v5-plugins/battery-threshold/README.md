# Battery Threshold

Noctalia v5 plugin for discovering and managing UPower battery charge thresholds.

## Features

- Automatically discovers internal/system `power_supply` devices whose type is `Battery`.
- Maps every discovered battery to its exact UPower object path.
- Auto-selects the first threshold-capable battery and allows switching batteries in the panel.
- Shows per-battery support for UPower thresholds, kernel threshold files, and `force-discharge`.
- Toggles the existing UPower charging limit.
- Applies custom start/end thresholds or presets:
  - **Longevity:** `40–60%`
  - **Daily:** `70–80%`
  - **Travel:** `90–100%`
- Can force-discharge to the configured end threshold using a managed systemd service.
- Restores system defaults by removing only this plugin's override for the selected battery.

## Compatibility

The threshold controls require UPower to expose `ChargeThresholdSupported` and the kernel to expose:

```text
/sys/class/power_supply/<BATTERY>/charge_control_start_threshold
/sys/class/power_supply/<BATTERY>/charge_control_end_threshold
```

The optional discharge feature additionally requires `force-discharge` in:

```text
/sys/class/power_supply/<BATTERY>/charge_behaviour
```

Unsupported actions are disabled in the panel with an explanation. Bluetooth batteries and other peripheral batteries are ignored because they are not system `power_supply` Battery devices.

## Privileged helper installation

Ordinary UPower threshold toggling does not use the helper. Applying values, restoring defaults, and force-discharge require the fixed root-owned helper and systemd unit shipped under `system/`.

Install them once from this plugin directory:

```bash
sudo ./install-system-helper.sh
```

The installer copies:

```text
/usr/libexec/noctalia-battery-threshold-helper
/usr/lib/systemd/system/noctalia-battery-threshold-discharge@.service
/usr/share/polkit-1/actions/org.noctalia.battery-threshold.policy
```

It then runs `systemctl daemon-reload`. The plugin invokes only the installed helper with typed arguments through `pkexec`; it never sends privileged shell scripts.

A graphical PolicyKit authentication agent is recommended. Without one, Noctalia opens the same fixed `pkexec` helper command in the configured terminal.

## Persistence and reset

Custom values are recorded in root-owned plugin state and rendered to a plugin-owned hwdb file:

```text
/var/lib/noctalia-battery-threshold/overrides.json
/etc/udev/hwdb.d/61-noctalia-battery-threshold.hwdb
```

Multiple battery entries share that file. On first apply, the helper records the battery's original runtime thresholds. **Restore system defaults** removes only the selected battery's entry and restores the effective vendor hwdb values, falling back to those recorded originals when no vendor limit exists. It removes the hwdb file only when no plugin overrides remain; it does not edit distribution files under `/usr/lib/udev`.

## Force-discharge service

The helper starts one hardened service instance per battery:

```text
noctalia-battery-threshold-discharge@BAT0.service
```

The worker returns `charge_behaviour` to `auto` when the target is reached, the service is stopped, it times out, or it receives a normal termination signal. `ExecStopPost` provides a second cleanup path.

## Entries

- `dominik/battery-threshold:service` — discovery, state, and IPC entry.
- `dominik/battery-threshold:widget` — bar widget.
- `dominik/battery-threshold:panel` — controls and capability details.

## IPC

```bash
noctalia msg plugin dominik/battery-threshold:service all refresh
noctalia msg plugin dominik/battery-threshold:service all select BAT0
noctalia msg plugin dominik/battery-threshold:service all enable
noctalia msg plugin dominik/battery-threshold:service all disable
noctalia msg plugin dominik/battery-threshold:service all toggle
noctalia msg plugin dominik/battery-threshold:service all apply 70,85
noctalia msg plugin dominik/battery-threshold:service all preset-longevity
noctalia msg plugin dominik/battery-threshold:service all preset-daily
noctalia msg plugin dominik/battery-threshold:service all preset-travel
noctalia msg plugin dominik/battery-threshold:service all reset
noctalia msg plugin dominik/battery-threshold:service all discharge
noctalia msg plugin dominik/battery-threshold:service all stop-discharge
noctalia msg panel-toggle dominik/battery-threshold:panel
```

## Development validation

```bash
noctalia plugins lint .
python -m unittest discover -s tests -v
python -m py_compile system/noctalia-battery-threshold-helper
systemd-analyze verify system/noctalia-battery-threshold-discharge@.service
```
