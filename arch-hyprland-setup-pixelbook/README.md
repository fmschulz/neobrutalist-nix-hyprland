# Arch Hyprland Setup - Pixelbook Edition

This is a customized version of the Hyprland configuration specifically tailored for Google Pixelbook (and similar Chromebooks) running Arch Linux.

## Features

- **Neo-brutalist themed** Hyprland configuration
- **Pixelbook hardware fixes** including touchscreen disable
- **Complete desktop environment** with waybar, wofi, kitty, and more
- **Pre-configured workspace assignments** for common applications
- **Working WiFi management** with proper GTK theming
- **All necessary workarounds** for Chromebook hardware quirks

## Quick Install

```bash
cd arch-hyprland-setup-pixelbook
./install.sh
```

## What's Included

- **Window Manager**: Hyprland with Pixelbook-specific fixes
- **Status Bar**: Waybar with workspace indicators, system monitoring
- **Launcher**: Wofi with neo-brutalist styling
- **Terminal**: Kitty with 8 switchable color themes
- **File Manager**: Yazi with custom theme
- **Prompt**: Starship multi-segment prompt
- **Notifications**: Mako
- **Network Manager**: nm-applet with dark theme fix
- **Audio Control**: PulseAudio with pavucontrol

## Pixelbook-Specific Fixes

1. **Broken touchscreen disabled** - Prevents cursor jumping
2. **Hardware cursor workaround** - Fixes cursor rendering
3. **GTK dark theme** - Makes dropdown menus readable
4. **Waybar config path** - Ensures correct config loads

## Key Bindings

- `Super + Enter` - Open terminal
- `Super + D` - Application launcher
- `Super + 1-9` - Switch workspaces
- `Super + Shift + Q` - Close window
- `Super + Shift + E` - Exit Hyprland
- `Ctrl + Alt + 1-8` - Switch Kitty terminal themes

## Manual Steps Required

After running the install script, you need to:

1. Edit `/etc/lightdm/lightdm.conf` with sudo
2. Uncomment the line containing `sessions-directory` to enable Wayland sessions
3. Restart LightDM or reboot

## Troubleshooting

See `PIXELBOOK-FIXES.md` for detailed information about all fixes applied.

## Credits

Based on the original neo-brutalist NixOS configuration, adapted for Arch Linux and Pixelbook hardware.