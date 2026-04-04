#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_DIR/clamshell.conf"
WAYBAR_APPLY_SCRIPT="$SCRIPT_DIR/apply-waybar-layout.sh"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_FILE="$RUNTIME_DIR/omarchy-clamshell.lock"
SUPPRESS_EVENTS_FILE="$RUNTIME_DIR/omarchy-clamshell.ignore-until"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Missing clamshell config: $CONFIG_FILE" >&2
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

build_workspace_range() {
  local start="$1"
  local count="$2"
  local workspaces=()
  local workspace

  for ((workspace = start; workspace < start + count; workspace++)); do
    workspaces+=("$workspace")
  done

  printf '%s\n' "${workspaces[@]}"
}

readarray -t WORKSPACES_LAPTOP < <(build_workspace_range 1 "$LAPTOP_WORKSPACE_COUNT")
readarray -t WORKSPACES_EXTERNAL < <(build_workspace_range "$((LAPTOP_WORKSPACE_COUNT + 1))" "$EXTERNAL_WORKSPACE_COUNT")
readarray -t WORKSPACES_ALL < <(build_workspace_range 1 "$((LAPTOP_WORKSPACE_COUNT + EXTERNAL_WORKSPACE_COUNT))")

notify_user() {
  notify-send -u low -i "$3" "$1" "$2"
}

suppress_monitor_events() {
  local seconds="$1"
  printf '%s\n' "$(( $(date +%s) + seconds ))" > "$SUPPRESS_EVENTS_FILE"
}

lid_is_open() {
  grep -q "open" /proc/acpi/button/lid/*/state
}

get_monitors_json() {
  hyprctl -j monitors all
}

get_external_display() {
  get_monitors_json | jq -r --arg internal "$INTERNAL_DISPLAY" '
    map(select(.name != $internal and (.disabled | not)))
    | first
    | .name // empty
  '
}

count_active_monitors() {
  get_monitors_json | jq '[.[] | select(.disabled | not)] | length'
}

enable_internal_display() {
  hyprctl keyword monitor "$INTERNAL_DISPLAY, preferred, auto, 1" >/dev/null
}

disable_internal_display() {
  hyprctl keyword monitor "$INTERNAL_DISPLAY, disable" >/dev/null
}

move_workspaces_to_monitor() {
  local monitor="$1"
  shift

  local workspace
  for workspace in "$@"; do
    hyprctl dispatch moveworkspacetomonitor "$workspace $monitor" >/dev/null
  done
}

set_workspace_binding() {
  local workspace="$1"
  local monitor="$2"

  hyprctl keyword workspace "$workspace, monitor:$monitor, persistent:true" >/dev/null
}

set_workspace_bindings() {
  local monitor="$1"
  shift

  local workspace
  for workspace in "$@"; do
    set_workspace_binding "$workspace" "$monitor"
  done
}

sync_waybar() {
  local mode="$1"
  local external_display="${2:-}"
  local restart_mode="${3:-always}"

  "$WAYBAR_APPLY_SCRIPT" "$mode" "$external_display" "$restart_mode" 9>&-
}

apply_single_mode() {
  local target_monitor="$1"
  local restart_mode="${2:-always}"

  set_workspace_bindings "$target_monitor" "${WORKSPACES_ALL[@]}"
  move_workspaces_to_monitor "$target_monitor" "${WORKSPACES_ALL[@]}"
  sync_waybar single "" "$restart_mode"
}

apply_dual_mode() {
  local external_display="$1"
  local restart_mode="${2:-always}"

  set_workspace_bindings "$INTERNAL_DISPLAY" "${WORKSPACES_LAPTOP[@]}"
  set_workspace_bindings "$external_display" "${WORKSPACES_EXTERNAL[@]}"
  move_workspaces_to_monitor "$INTERNAL_DISPLAY" "${WORKSPACES_LAPTOP[@]}"
  move_workspaces_to_monitor "$external_display" "${WORKSPACES_EXTERNAL[@]}"
  sync_waybar dual "$external_display" "$restart_mode"
}

sync_current_layout() {
  local restart_mode="${1:-always}"
  local external_display
  external_display="$(get_external_display)"

  if lid_is_open; then
    enable_internal_display
    sleep 1

    external_display="$(get_external_display)"
    if [[ -n "$external_display" ]]; then
      apply_dual_mode "$external_display" "$restart_mode"
    else
      apply_single_mode "$INTERNAL_DISPLAY" "$restart_mode"
    fi
    return
  fi

  if [[ -n "$external_display" ]]; then
    apply_single_mode "$external_display" "$restart_mode"
    disable_internal_display
    sleep 1
    return
  fi

  enable_internal_display
  sleep 1
  apply_single_mode "$INTERNAL_DISPLAY" "$restart_mode"
}

mode_close() {
  local external_display
  external_display="$(get_external_display)"

  suppress_monitor_events 3

  if [[ -n "$external_display" ]]; then
    apply_single_mode "$external_display"
    disable_internal_display
    sleep 1
    return
  fi

  apply_single_mode "$INTERNAL_DISPLAY"
}

mode_open() {
  suppress_monitor_events 3
  sync_current_layout
}

ACTION="${1:-}"

exec 9>"$LOCK_FILE"
if [[ "$ACTION" == "check" ]]; then
  flock -xn 9 || exit 0
else
  flock -x 9
fi

case "$ACTION" in
  close)
    mode_close
    if [[ $(count_active_monitors) -eq 1 ]]; then
      notify_user "Clamshell Mode" "Single active display synchronized to clamshell layout." "$ICON_MONITOR"
    else
      notify_user "Clamshell Mode" "External monitor active. Laptop screen disabled." "$ICON_MONITOR"
    fi
    ;;
  open)
    mode_open
    notify_user "Laptop Mode" "Laptop screen enabled and workspaces resynchronized." "$ICON_LAPTOP"
    ;;
  check)
    sync_current_layout
    ;;
  startup-check)
    sync_current_layout if-changed
    ;;
  *)
    echo "Usage: $0 [open|close|check|startup-check]"
    exit 1
    ;;
esac
