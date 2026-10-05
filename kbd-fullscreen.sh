#!/bin/bash
KBD="*kbd_backlight"
state="on"

# Poll interval in seconds
poll_interval=1

restore_backlight() {
  if [ "$state" = "off" ]; then
    brightnessctl -d "$KBD" -r
    state="on"
  fi
}

trap restore_backlight EXIT INT TERM

while true; do
  active_window="$(xdotool getactivewindow 2>/dev/null || true)"

  if [ -n "$active_window" ] && xprop -id "$active_window" _NET_WM_STATE 2>/dev/null | grep -q "_NET_WM_STATE_FULLSCREEN"; then
    if [ "$state" = "on" ]; then
      brightnessctl -d "$KBD" -s set 0
      state="off"
    fi
  elif [ "$state" = "off" ]; then
    brightnessctl -d "$KBD" -r
    state="on"
  fi

  sleep "$poll_interval"
done
