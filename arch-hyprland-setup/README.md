# Arch Linux Hyprland Setup

This directory contains a complete Arch Linux setup extracted from your NixOS configuration, designed to replicate your neo-brutalist Hyprland environment on Arch Linux.

## Quick Start

1. **Run the setup script** (as a regular user, not root):
   ```bash
   cd arch-hyprland-setup
   chmod +x setup.sh
   ./setup.sh
   ```

2. **Reboot and select Hyprland** from your display manager

3. **Enjoy your neo-brutalist Hyprland setup!**

## What's Included

### Core Components
- **Hyprland**: Wayland compositor with your exact configuration
- **Kitty**: Terminal with 8 neo-brutalist color themes
- **Waybar**: Status bar with neo-brutalist styling
- **Starship**: Shell prompt with custom neo-brutalist theme
- **Yazi**: File manager with custom theme and keybindings
- **Mako**: Notification daemon with neo-brutalist styling

### Additional Tools
- **Wofi**: Application launcher
- **Swww**: Wallpaper daemon
- **Hyprlock/Hypridle**: Screen locking and idle management
- **All your development tools**: Git, Docker, Python, Node.js, Rust, etc.
- **Media tools**: MPV, ImageMagick, FFmpeg
- **System monitoring**: btop, htop, fastfetch

### Features Replicated
- ✅ All keybindings from your NixOS setup
- ✅ Workspace auto-assignment for applications
- ✅ Multi-monitor support
- ✅ Screenshot functionality
- ✅ Clipboard history
- ✅ Theme switching for Kitty and VS Code
- ✅ Custom scripts and aliases
- ✅ Neo-brutalist color scheme throughout

## Directory Structure

```
arch-hyprland-setup/
├── setup.sh                 # Main installation script
├── configs/                 # All configuration files
│   ├── hypr/               # Hyprland configuration
│   ├── kitty/              # Kitty terminal configuration
│   ├── waybar/             # Waybar configuration
│   ├── starship/           # Starship prompt configuration
│   ├── yazi/               # Yazi file manager configuration
│   ├── mako/               # Mako notification configuration
│   ├── wofi/               # Wofi launcher configuration
│   └── scripts/            # Custom scripts
├── wallpapers/             # Wallpaper files
├── packages/               # Package lists
│   ├── aur-packages.txt    # AUR packages to install
│   └── pacman-packages.txt # Official repo packages
└── docs/                   # Documentation
    ├── keybindings.md      # Keyboard shortcuts reference
    └── troubleshooting.md  # Common issues and solutions
```

## Manual Installation Steps

If you prefer to install manually or the script fails:

1. **Install packages**:
   ```bash
   # Install official packages
   sudo pacman -S --needed $(cat packages/pacman-packages.txt)
   
   # Install AUR helper (yay)
   git clone https://aur.archlinux.org/yay.git
   cd yay && makepkg -si
   
   # Install AUR packages
   yay -S --needed $(cat packages/aur-packages.txt)
   ```

2. **Copy configurations**:
   ```bash
   cp -r configs/* ~/.config/
   chmod +x ~/.config/scripts/*
   ```

3. **Set up wallpapers**:
   ```bash
   mkdir -p ~/Pictures/wallpapers
   cp wallpapers/* ~/Pictures/wallpapers/
   ```

4. **Enable services**:
   ```bash
   systemctl --user enable --now pipewire pipewire-pulse
   ```

## Customization

### Changing Themes
- **Kitty themes**: Use `Ctrl+Alt+1-8` to switch between 8 neo-brutalist themes
- **Wallpapers**: Use `Super+W`, `Super+Shift+W`, `Super+Ctrl+W` to cycle wallpapers

### Adding Your Own Configurations
- Edit files in `~/.config/` after installation
- Your custom bashrc is at `~/.config/bash/bashrc`
- Scripts are in `~/.config/scripts/`

## Differences from NixOS

- Package management uses pacman/yay instead of Nix
- Configuration files are in standard locations (`~/.config/`)
- Some NixOS-specific features are replaced with Arch equivalents
- Manual package updates required (not automatic like NixOS)

## Support

If you encounter issues:
1. Check `docs/troubleshooting.md`
2. Verify all packages installed correctly
3. Check logs: `journalctl --user -f`
4. For Hyprland issues: `hyprctl version`

## Credits

Extracted from NixOS configuration with neo-brutalist theme by fschulz.
