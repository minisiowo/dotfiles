#!/bin/bash
# apply-my-waybar.sh

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
DEFAULT_CONFIG="$HOME/.local/share/omarchy/config/waybar/config.jsonc"
SOURCE_CONFIG="$CONFIG_FILE"
TEMP_FILE=$(mktemp)

if [ -f "$DEFAULT_CONFIG" ]; then
  SOURCE_CONFIG="$DEFAULT_CONFIG"
fi

# Start from the current Omarchy default config, then apply personal layout overrides.
jq '
  ."modules-left" = ["clock", "custom/update", "custom/voxtype", "custom/screenrecording-indicator", "custom/idle-indicator", "custom/notification-silencing-indicator"] |
  ."modules-center" = ["hyprland/workspaces"] |
  ."modules-right" = ["group/tray-expander", "bluetooth", "network", "pulseaudio", "cpu", "battery", "custom/omarchy"] |
  ."custom/omarchy".format = "💀" |
  ."hyprland/workspaces"."format-icons"."10" = ""
' "$SOURCE_CONFIG" > "$TEMP_FILE" && mv "$TEMP_FILE" "$CONFIG_FILE"

omarchy-restart-waybar
echo "Custom Waybar layout applied!"
