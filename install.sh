#!/bin/bash
set -eu

# so it works no matter where you run it from
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
UNIT_DIR="$HOME/.config/systemd/user"

for cmd in playerctl brightnessctl; do
	if ! command -v "$cmd" >/dev/null; then
		echo "Missing requirement: $cmd. Please install it and try again." >&2
		exit 1
	fi
done

mkdir -p "$BIN_DIR" "$UNIT_DIR"

cp "$SCRIPT_DIR/kbd-video.sh" "$BIN_DIR/kbd-video.sh"
chmod +x "$BIN_DIR/kbd-video.sh"

cat > "$UNIT_DIR/kbd-video.service" <<EOF
[Unit]
Description=Turn off keyboard backlight while media is playing
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=%h/.local/bin/kbd-video.sh
ExecStopPost=$(command -v brightnessctl) -d '*kbd_backlight' -r
Restart=on-failure
RestartSec=3

[Install]
WantedBy=graphical-session.target
EOF

systemctl --user daemon-reload

echo "Installed. Enable it with:"
echo "  systemctl --user enable --now kbd-video.service"
