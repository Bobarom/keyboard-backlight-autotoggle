# Keyboard backlight autotoggle
A background service that checks if you have a video playing and turns off your backlit keyboard automatically for you.

## Dependencies
- `playerctl`
- `brightnessctl`

## Installation
Before installation you can configure which players are ignored by changing the ignoreplayers= line in `kbd-video.sh`

To install just run `./install.sh` from inside the repo

To uninstall just run `./uninstall.sh` from inside the repo

## Usage
You can enable the service with
```bash
systemctl --user enable --now kbd-video.service
```
Stop it with
```bash
systemctl --user stop kbd-video.service
```
Or disable it entirely with
```bash
systemctl --user disable --now kbd-video.service
```

For other service managers use a command according to their docs
