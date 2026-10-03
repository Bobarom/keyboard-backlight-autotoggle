#!/bin/bash
set -eu

BIN_FILE="$HOME/.local/bin/kbd-video.sh"
UNIT_FILE="$HOME/.config/systemd/user/kbd-video.service"

# stop and disable first, so ExecStopPost restores the backlight
# "|| true" because this fails if the service was never enabled
systemctl --user disable --now kbd-video.service 2>/dev/null || true

rm -f "$BIN_FILE" "$UNIT_FILE"

systemctl --user daemon-reload

echo "Uninstalled kbd-video."
