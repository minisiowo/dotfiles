#!/bin/bash

# Sprawdzamy status eDP-1
LID_STATUS=$(grep -o "closed" /proc/acpi/button/lid/LID/state)

if [ "$LID_STATUS" == "closed" ]; then
    hyprctl keyword monitor "eDP-1, disable"
else
    hyprctl keyword monitor "eDP-1, 2560x1440, auto, 1.25"
fi

