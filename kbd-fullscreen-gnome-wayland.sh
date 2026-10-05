#!/bin/bash
set -eu

KBD="*kbd_backlight"
state="on"

for cmd in brightnessctl gdbus; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing requirement: $cmd" >&2
    exit 1
  fi
done

is_fullscreen_focused_window() {
  local out

  out="$(gdbus call --session \
    --dest org.gnome.Shell \
    --object-path /org/gnome/Shell \
    --method org.gnome.Shell.Eval \
    '(() => { const w = global.display.focus_window; return w ? w.is_fullscreen() : false; })()' \
    2>/dev/null || true)"

  case "$out" in
    *"(true, 'true')"*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

set_backlight_off() {
  if [ "$state" = "on" ]; then
    brightnessctl -d "$KBD" -s set 0
    state="off"
  fi
}

restore_backlight() {
  if [ "$state" = "off" ]; then
    brightnessctl -d "$KBD" -r
    state="on"
  fi
}

sync_backlight_with_fullscreen_state() {
  if is_fullscreen_focused_window; then
    set_backlight_off
  else
    restore_backlight
  fi
}

trap restore_backlight EXIT INT TERM

# Initial sync on start.
sync_backlight_with_fullscreen_state

# Event-driven updates: react to GNOME Shell D-Bus signals.
while IFS= read -r line; do
  case "$line" in
    *"signal"*)
      sync_backlight_with_fullscreen_state
      ;;
  esac
done < <(gdbus monitor --session --dest org.gnome.Shell 2>/dev/null)
