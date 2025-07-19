# Pixelbook-Specific Hyprland Setup Fixes

This document outlines all the fixes applied to make Hyprland work properly on the Pixelbook (Chromebook).

## Critical Fixes Applied

### 1. Touchscreen Disable (Broken Hardware)
The Pixelbook has a broken touchscreen causing cursor jumping and random clicks.

**Fix applied in `hyprland.conf`:**
```bash
# Disable broken touchscreen
device {
    name = acpi0c50:00-0483:1058-touchscreen
    enabled = false
}

# Also disabled via xinput on startup
exec-once = xinput disable "ACPI0C50:00 0483:1058 Touchscreen" 2>/dev/null || true
```

### 2. Hardware Cursor Fix
Added environment variable to fix cursor rendering issues:
```bash
env = WLR_NO_HARDWARE_CURSORS,1
```

### 3. Waybar Configuration Path
LightDM was loading system waybar config instead of user config.

**Fix applied in `hyprland.conf`:**
```bash
exec-once = waybar -c ~/.config/waybar/config.json
```

### 4. GTK Theme for nm-applet (WiFi Dropdown)
nm-applet showed white text on white background in dropdown.

**Fix applied:**
- Set GTK theme to Adwaita-dark in `gtk-3.0/settings.ini`
- Added GTK environment variables in `hyprland.conf`:
```bash
env = GTK_THEME,Adwaita:dark
env = QT_QPA_PLATFORMTHEME,qt5ct
```
- Applied gsettings for dark theme preference:
```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### 5. LightDM Wayland Session Support
LightDM needed to be configured to show Wayland sessions.

**Fix required in `/etc/lightdm/lightdm.conf`:**
```bash
# Uncomment this line:
sessions-directory=/usr/share/lightdm/sessions:/usr/share/xsessions:/usr/share/wayland-sessions
```

## Required Packages

### Core Wayland/Hyprland
- hyprland
- waybar
- wofi
- mako
- xdg-desktop-portal-hyprland
- qt5-wayland
- qt6-wayland
- wl-clipboard

### Terminal and Tools
- kitty
- yazi
- starship

### System Integration
- polkit-gnome
- network-manager-applet
- pavucontrol
- pipewire
- pipewire-pulse
- wireplumber

### Themes
- gnome-themes-extra (for Adwaita-dark)
- breeze-gtk (alternative dark theme)
- bibata-cursor-theme (optional)

## Installation Order

1. Install all packages
2. Copy configurations to ~/.config/
3. Edit /etc/lightdm/lightdm.conf to enable Wayland sessions
4. Apply gsettings for dark theme
5. Restart LightDM or reboot

## Testing

From TTY2:
```bash
Hyprland
```

Or select "Hyprland" from LightDM session dropdown after configuration.