#!/usr/bin/env bash

set -euo pipefail

MODE="${1:-single}"
EXTERNAL_DISPLAY="${2:-}"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$CONFIG_DIR/clamshell.conf"

CONFIG_FILE_OUT="$HOME/.config/waybar/config.jsonc"
DEFAULT_CONFIG="$HOME/.local/share/omarchy/config/waybar/config.jsonc"
TEMP_FILE="$(mktemp)"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Missing clamshell config: $CONFIG_FILE" >&2
  exit 1
fi

if [[ ! -f "$DEFAULT_CONFIG" ]]; then
  echo "Missing Waybar base config: $DEFAULT_CONFIG" >&2
  exit 1
fi

if [[ "$MODE" == "dual" && -z "$EXTERNAL_DISPLAY" ]]; then
  echo "Dual mode requires external display name" >&2
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

build_json_range() {
  local start="$1"
  local count="$2"
  local values=()
  local workspace

  for ((workspace = start; workspace < start + count; workspace++)); do
    values+=("$workspace")
  done

  printf '[%s]' "$(IFS=,; printf '%s' "${values[*]}")"
}

build_ignore_regex() {
  local start="$1"
  local count="$2"
  local values=()
  local visible=()
  local workspace

  for ((workspace = start; workspace < start + count; workspace++)); do
    visible+=("$workspace")
  done

  for workspace in {1..10}; do
    local keep=false
    local current
    for current in "${visible[@]}"; do
      if [[ "$workspace" -eq "$current" ]]; then
        keep=true
        break
      fi
    done

    if [[ "$keep" == false ]]; then
      values+=("$workspace")
    fi
  done

  printf '["^(%s)$"]' "$(IFS='|'; printf '%s' "${values[*]}")"
}

LAPTOP_JSON="$(build_json_range 1 "$LAPTOP_WORKSPACE_COUNT")"
EXTERNAL_JSON="$(build_json_range "$((LAPTOP_WORKSPACE_COUNT + 1))" "$EXTERNAL_WORKSPACE_COUNT")"
ALL_JSON="$(build_json_range 1 "$((LAPTOP_WORKSPACE_COUNT + EXTERNAL_WORKSPACE_COUNT))")"
LAPTOP_IGNORE_JSON="$(build_ignore_regex 1 "$LAPTOP_WORKSPACE_COUNT")"
EXTERNAL_IGNORE_JSON="$(build_ignore_regex "$((LAPTOP_WORKSPACE_COUNT + 1))" "$EXTERNAL_WORKSPACE_COUNT")"
ALL_IGNORE_JSON="$(build_ignore_regex 1 "$((LAPTOP_WORKSPACE_COUNT + EXTERNAL_WORKSPACE_COUNT))")"

jq \
  --arg mode "$MODE" \
  --arg internal "$INTERNAL_DISPLAY" \
  --arg external "$EXTERNAL_DISPLAY" \
  --argjson laptop "$LAPTOP_JSON" \
  --argjson external_workspaces "$EXTERNAL_JSON" \
  --argjson all "$ALL_JSON" \
  --argjson laptop_ignore "$LAPTOP_IGNORE_JSON" \
  --argjson external_ignore "$EXTERNAL_IGNORE_JSON" \
  --argjson all_ignore "$ALL_IGNORE_JSON" \
  '
    def base_bar:
      .
      | ."modules-left" = ["clock", "custom/update", "custom/voxtype", "custom/screenrecording-indicator", "custom/idle-indicator", "custom/notification-silencing-indicator"]
      | ."modules-right" = ["group/tray-expander", "bluetooth", "network", "pulseaudio", "cpu", "battery", "custom/omarchy"]
      | del(."hyprland/workspaces")
      | ."custom/omarchy".format = "💀";

    def workspace_module($persistent; $ignored; $output_name): {
      "on-click": "activate",
      "move-to-monitor": true,
      "all-outputs": false,
      "sort-by": "number",
      "format": "{icon}",
      "ignore-workspaces": $ignored,
      "format-icons": {
        "default": "",
        "1": "1",
        "2": "2",
        "3": "3",
        "4": "4",
        "5": "5",
        "6": "6",
        "7": "7",
        "8": "8",
        "9": "9",
        "10": "",
        "active": "󱓻"
      },
      "persistent-workspaces": {
        ($output_name): $persistent
      }
    };

    if $mode == "dual" then
      [
        (
          base_bar
          | .output = [$internal]
          | ."modules-center" = ["hyprland/workspaces#laptop"]
          | ."hyprland/workspaces#laptop" = workspace_module($laptop; $laptop_ignore; $internal)
        ),
        (
          base_bar
          | .output = [$external]
          | ."modules-center" = ["hyprland/workspaces#external"]
          | ."hyprland/workspaces#external" = workspace_module($external_workspaces; $external_ignore; $external)
        )
      ]
    else
      base_bar
      | ."modules-center" = ["hyprland/workspaces"]
      | ."hyprland/workspaces" = workspace_module($all; $all_ignore; "*")
    end
  ' "$DEFAULT_CONFIG" > "$TEMP_FILE"

install -m 600 "$TEMP_FILE" "$CONFIG_FILE_OUT"
rm -f "$TEMP_FILE"
omarchy-restart-waybar
