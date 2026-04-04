#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CLAMSHELL_SCRIPT="$SCRIPT_DIR/clamshell.sh"
RECONNECT_DELAY_SECONDS=1
HOTPLUG_SETTLE_SECONDS=1
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
SUPPRESS_EVENTS_FILE="$RUNTIME_DIR/omarchy-clamshell.ignore-until"

socket_path() {
  printf '%s/hypr/%s/.socket2.sock' "$XDG_RUNTIME_DIR" "$HYPRLAND_INSTANCE_SIGNATURE"
}

handle_event_stream() {
  local line event

  while IFS= read -r line; do
    event="${line%%>>*}"

    case "$event" in
      monitoraddedv2|monitorremovedv2)
        if [[ -f "$SUPPRESS_EVENTS_FILE" ]] && [[ $(date +%s) -lt $(<"$SUPPRESS_EVENTS_FILE") ]]; then
          continue
        fi
        sleep "$HOTPLUG_SETTLE_SECONDS"
        "$CLAMSHELL_SCRIPT" check >/dev/null 2>&1 || true
        ;;
    esac
  done
}

while true; do
  if [[ -z "${XDG_RUNTIME_DIR:-}" || -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    sleep "$RECONNECT_DELAY_SECONDS"
    continue
  fi

  SOCKET_PATH="$(socket_path)"
  if [[ ! -S "$SOCKET_PATH" ]]; then
    sleep "$RECONNECT_DELAY_SECONDS"
    continue
  fi

  handle_event_stream < <(nc -U "$SOCKET_PATH") || true
  sleep "$RECONNECT_DELAY_SECONDS"
done
