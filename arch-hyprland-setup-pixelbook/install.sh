#!/bin/bash
# Pixelbook Hyprland Setup Script
# This script installs and configures Hyprland with all Pixelbook-specific fixes

set -e

echo "=== Pixelbook Hyprland Setup ==="
echo "This will install Hyprland and apply Pixelbook-specific fixes"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run as root. Script will use sudo when needed."
   exit 1
fi

# Update system
echo "==> Updating system..."
sudo pacman -Syu --noconfirm

# Install packages
echo "==> Installing required packages..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    waybar \
    wofi \
    mako \
    kitty \
    yazi \
    starship \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    wl-clipboard \
    polkit-gnome \
    network-manager-applet \
    pavucontrol \
    pipewire \
    pipewire-pulse \
    wireplumber \
    gnome-themes-extra \
    breeze-gtk \
    bibata-cursor-theme \
    grim \
    slurp \
    swaylock-effects \
    swayidle \
    cliphist \
    ttf-jetbrains-mono-nerd

# Backup existing configs
echo "==> Backing up existing configurations..."
backup_dir="$HOME/config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
for config in hypr waybar kitty wofi yazi mako gtk-3.0; do
    if [ -d "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$backup_dir/"
    fi
done
if [ -f "$HOME/.config/starship.toml" ]; then
    cp "$HOME/.config/starship.toml" "$backup_dir/"
fi

# Copy configurations
echo "==> Installing configurations..."
cp -r configs/* ~/.config/

# Apply GTK dark theme settings
echo "==> Applying GTK dark theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Create local bin directory
mkdir -p ~/.local/bin

# Configure LightDM for Wayland sessions
echo "==> Configuring LightDM..."
if [ -f /etc/lightdm/lightdm.conf ]; then
    echo "LightDM configuration found. You need to manually edit it:"
    echo "1. Edit /etc/lightdm/lightdm.conf with sudo"
    echo "2. Uncomment the line: sessions-directory=/usr/share/lightdm/sessions:/usr/share/xsessions:/usr/share/wayland-sessions"
    echo ""
    read -p "Press Enter to continue..."
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "1. Edit /etc/lightdm/lightdm.conf to enable Wayland sessions (see above)"
echo "2. Log out and select 'Hyprland' from the session dropdown"
echo "3. Or test immediately: Switch to TTY2 (Ctrl+Alt+F2) and run 'Hyprland'"
echo ""
echo "Your old configs are backed up in: $backup_dir"
echo ""
echo "Pixelbook-specific fixes applied:"
echo "- Broken touchscreen disabled"
echo "- Hardware cursor workaround enabled"
echo "- GTK dark theme for proper dropdown visibility"
echo "- Waybar configured with correct config path"