#!/bin/bash
KBD="*kbd_backlight"
state="on"

# List of ignored players, separated by commas, like in a .csv file
# Customize to your liking :)
ignoreplayers=spotify

playerctl --ignore-player=$ignoreplayers --follow status 2>/dev/null | while read -r s; do
  if [ "$s" = "Playing" ] && [ "$state" = "on" ]; then
    brightnessctl -d "$KBD" -s set 0
    state="off"
  elif [ "$s" != "Playing" ] && [ "$state" = "off" ]; then
    brightnessctl -d "$KBD" -r
    state="on"
  fi
done
