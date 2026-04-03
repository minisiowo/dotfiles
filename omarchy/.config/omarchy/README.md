# Omarchy Clamshell

Small Omarchy/Hyprland clamshell project for dynamic monitor and workspace routing.

## What It Does

- Handles lid close and lid open through Hyprland `bindl` events.
- Handles monitor hotplug through Hyprland `socket2` events.
- Keeps Hyprland workspace bindings and Waybar workspace display in sync.
- Prevents overlapping runs with a runtime lock.
- Gives direct lid actions (`open` and `close`) priority over background `check` runs.
- Supports three modes:
  - laptop only
  - external monitor only
  - dual monitor

## Layout Rules

- Internal display is configured in `clamshell.conf`.
- Laptop gets the first workspace block.
- External display gets the next workspace block.
- Default setup in this repo:
  - laptop: `1-4`
  - external: `5-8`
- Extra dynamic workspaces can stay outside the main split.
- Default extra dynamic workspace in this repo:
  - `10` for Telegram

When only one display is active, the active display gets the full workspace range.

## Files

- `clamshell.conf`: device-specific settings
- `scripts/clamshell.sh`: main controller
- `scripts/clamshell-events.sh`: Hyprland socket2 listener
- `scripts/apply-waybar-layout.sh`: regenerates Waybar config for single or dual mode
- `examples/`: installation snippets and sample config

## Event Model

- Lid close and open are handled directly by Hyprland `bindl` events.
- Monitor hotplug is handled by `clamshell-events.sh` through Hyprland `socket2`.
- The listener reacts only to `monitoraddedv2` and `monitorremovedv2`.
- Hotplug events are briefly suppressed after explicit lid actions to avoid duplicate Waybar restarts.
- Background `check` runs are skipped if another clamshell action is already in progress.

## Runtime Integration

The scripts live in dotfiles, but runtime paths should always use `~/.config/omarchy/...`.

Expected runtime paths after stow:

- `~/.config/omarchy/clamshell.conf`
- `~/.config/omarchy/scripts/clamshell.sh`
- `~/.config/omarchy/scripts/clamshell-events.sh`
- `~/.config/omarchy/scripts/apply-waybar-layout.sh`

## Required Hyprland Integration

Add lid bindings:

```conf
bindl = , switch:on:Lid Switch, exec, ~/.config/omarchy/scripts/clamshell.sh close
bindl = , switch:off:Lid Switch, exec, ~/.config/omarchy/scripts/clamshell.sh open
```

Add autostart entries:

```conf
exec = ~/.config/omarchy/scripts/clamshell.sh check
exec = pgrep -f "\.config/omarchy/scripts/clamshell-events\.sh" >/dev/null || ~/.config/omarchy/scripts/clamshell-events.sh
```

## Config

Example `clamshell.conf`:

```bash
INTERNAL_DISPLAY="eDP-1"
LAPTOP_WORKSPACE_COUNT=4
EXTERNAL_WORKSPACE_COUNT=4
EXTRA_DYNAMIC_WORKSPACES="10"

ICON_LAPTOP="computer-laptop"
ICON_MONITOR="video-display"
```

Only `INTERNAL_DISPLAY` is usually device-specific.

## Manual Commands

```bash
~/.config/omarchy/scripts/clamshell.sh check
~/.config/omarchy/scripts/clamshell.sh open
~/.config/omarchy/scripts/clamshell.sh close
```

## Debug

Useful commands:

```bash
hyprctl monitors all
hyprctl workspaces
pgrep -af "clamshell-events.sh"
```

If the bar looks wrong, run:

```bash
~/.config/omarchy/scripts/clamshell.sh check
```

## Assumptions

- One internal display.
- Zero or one external display is treated as the main external target.
- Workspace display in Waybar depends on dynamic Hyprland workspace bindings set by `clamshell.sh`.
- Extra dynamic workspaces such as Telegram on `10` are visible when active, but are not part of the persistent `1-8` split.
