#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'Run this installer as root: sudo %q\n' "$0" >&2
    exit 1
fi

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

install -Dm0755 \
    "$root/system/noctalia-battery-threshold-helper" \
    /usr/libexec/noctalia-battery-threshold-helper
install -Dm0644 \
    "$root/system/noctalia-battery-threshold-discharge@.service" \
    /usr/lib/systemd/system/noctalia-battery-threshold-discharge@.service
install -Dm0644 \
    "$root/system/org.noctalia.battery-threshold.policy" \
    /usr/share/polkit-1/actions/org.noctalia.battery-threshold.policy

systemctl daemon-reload
printf '%s\n' 'Battery Threshold helper installed.'
