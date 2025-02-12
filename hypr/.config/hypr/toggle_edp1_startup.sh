#!/bin/bash

# Sprawdzamy stan pokrywy
LID_STATUS=$(grep -o "closed" /proc/acpi/button/lid/LID/state)

if [ "$LID_STATUS" == "closed" ]; then
    hyprctl keyword monitor "eDP-1, disable"
else
    hyprctl keyword monitor "eDP-1, 2560x1600, 0x0, 1"
fi

