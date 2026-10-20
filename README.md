# cfgs

Personal configuration dotfiles.

### Modern SwayFX Desktop Setup
- **Window Manager**: `sway/` (SwayFX with frosted blur, custom shadows, and dual-monitor support)
- **Bar**: `waybar/` (Frosted slate status bar with grouped hardware, audio, and system capsules)
- **Application Launcher**: `rofi/` (Mars Twilight theme, optimized ~50ms launch, cached drun mode)
- **Notification Daemon**: `swaync/` (Control center and notification styling)
- **OSD**: `swayosd/` (Volume, brightness, and caps lock overlays)
- **Terminal**: `foot/` (Minimal, fast Wayland terminal with matching slate palette)
- **File Manager**: `yazi/` (Clean sharp corners and dark theme)
- **Browser Flags**: `helium/` (Smooth Wayland video decoding & background throttling prevention)
- **Desktop Helpers**: `scripts/` (Sway launcher, audio toggle, power menu, wallpaper manager)

---

### Legacy Install Scripts
```bash
sudo apt install git -y
sudo dnf in git -y

git clone https://github.com/suichanwa/cfgs
sudo chmod 555 debDistroConfigureScript.sh
sudo chmod 555 rpmDistroConfigureScript.sh

./debDistroConfigureScript.sh
# or
./rpmDistroConfigureScript.sh
```
