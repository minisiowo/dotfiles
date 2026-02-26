#!/bin/bash
# apply-my-waybar.sh

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
TEMP_FILE=$(mktemp)

# Use jq to update specific keys to match user preference
jq '
  ."modules-left" = ["clock", "custom/update", "custom/voxtype", "custom/screenrecording-indicator", "custom/idle-indicator", "custom/notification-silencing-indicator"] |
  ."modules-center" = ["hyprland/workspaces"] |
  ."modules-right" = ["group/tray-expander", "bluetooth", "network", "pulseaudio", "cpu", "battery", "custom/omarchy"] |
  ."custom/omarchy".format = "💀" |
  ."hyprland/workspaces"."format-icons"."10" = ""
' "$CONFIG_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$CONFIG_FILE"

omarchy-restart-waybar
echo "Custom Waybar layout applied!"
