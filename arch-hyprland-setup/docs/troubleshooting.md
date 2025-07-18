# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Package Installation Fails
```bash
# Update package databases
sudo pacman -Syu

# Clear package cache if needed
sudo pacman -Scc

# For AUR packages, rebuild yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### Missing Dependencies
```bash
# Install base development tools
sudo pacman -S base-devel git

# Install missing dependencies manually
sudo pacman -S <package-name>
```

### Hyprland Issues

#### Hyprland Won't Start
1. Check if you're using a compatible GPU driver:
   ```bash
   lspci | grep VGA
   # For AMD: install mesa, vulkan-radeon
   # For NVIDIA: install nvidia, nvidia-utils
   ```

2. Check Hyprland logs:
   ```bash
   journalctl --user -u hyprland -f
   ```

3. Try starting from TTY:
   ```bash
   # Switch to TTY (Ctrl+Alt+F2)
   Hyprland
   ```

#### Black Screen on Login
1. Check if all required packages are installed:
   ```bash
   pacman -Q hyprland waybar kitty wofi
   ```

2. Reset Hyprland config:
   ```bash
   mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
   cp /path/to/arch-hyprland-setup/configs/hypr/hyprland.conf ~/.config/hypr/
   ```

#### Window Rules Not Working
1. Check window class names:
   ```bash
   hyprctl clients
   ```

2. Update window rules in `~/.config/hypr/hyprland.conf`

### Audio Issues

#### No Audio Output
1. Check PipeWire status:
   ```bash
   systemctl --user status pipewire pipewire-pulse
   ```

2. Restart audio services:
   ```bash
   systemctl --user restart pipewire pipewire-pulse wireplumber
   ```

3. Check audio devices:
   ```bash
   wpctl status
   pactl list sinks
   ```

#### Audio Crackling
1. Increase buffer size in PipeWire config
2. Check for conflicting audio systems:
   ```bash
   pulseaudio --check -v  # Should show "not running"
   ```

### Display Issues

#### Wrong Resolution/Scaling
1. Check available monitors:
   ```bash
   hyprctl monitors
   ```

2. Update monitor config in `~/.config/hypr/hyprland.conf`:
   ```
   monitor = eDP-1,1920x1080@60,0x0,1.0
   ```

#### Multiple Monitor Issues
1. Use monitor connection script:
   ```bash
   ~/.config/scripts/monitor-connect.sh
   ```

2. Check display configuration:
   ```bash
   wlr-randr
   ```

### Theme Issues

#### Kitty Themes Not Working
1. Check if remote control is enabled:
   ```bash
   grep "allow_remote_control" ~/.config/kitty/kitty.conf
   ```

2. Test theme switching manually:
   ```bash
   kitty @ set-colors ~/.config/kitty/themes/Neo-Brutalist-Blue.conf
   ```

#### Waybar Not Showing
1. Check Waybar status:
   ```bash
   pgrep waybar
   ```

2. Restart Waybar:
   ```bash
   pkill waybar && waybar &
   ```

3. Check Waybar logs:
   ```bash
   waybar -l debug
   ```

### Network Issues

#### WiFi Not Working
1. Check NetworkManager status:
   ```bash
   sudo systemctl status NetworkManager
   ```

2. Enable NetworkManager:
   ```bash
   sudo systemctl enable --now NetworkManager
   ```

3. Use nmcli for connection:
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "SSID" password "password"
   ```

#### Bluetooth Issues
1. Check Bluetooth service:
   ```bash
   sudo systemctl status bluetooth
   ```

2. Enable Bluetooth:
   ```bash
   sudo systemctl enable --now bluetooth
   ```

3. Use bluetoothctl:
   ```bash
   bluetoothctl
   power on
   scan on
   ```

### Performance Issues

#### High CPU Usage
1. Check running processes:
   ```bash
   htop
   ```

2. Disable animations temporarily:
   ```bash
   # Add to hyprland.conf
   animations {
       enabled = false
   }
   ```

#### Memory Issues
1. Check memory usage:
   ```bash
   free -h
   ```

2. Enable zram swap:
   ```bash
   sudo systemctl enable --now systemd-zram-setup@zram0.service
   ```

### Application Issues

#### VS Code Theme Switching Not Working
1. Check if jq is installed:
   ```bash
   pacman -Q jq
   ```

2. Check VS Code settings file:
   ```bash
   ls -la ~/.config/Code/User/settings.json
   ```

#### File Manager Issues
1. For Dolphin issues, install KDE dependencies:
   ```bash
   sudo pacman -S kdeconnect dolphin-plugins
   ```

2. For Yazi issues, check configuration:
   ```bash
   yazi --debug
   ```

## Log Files and Debugging

### Important Log Locations
- Hyprland: `journalctl --user -u hyprland`
- Waybar: `~/.cache/waybar/waybar.log`
- System: `journalctl -xe`
- Xorg (if using): `~/.local/share/xorg/Xorg.0.log`

### Debug Commands
```bash
# Check Hyprland version
hyprctl version

# Check system info
fastfetch

# Check graphics info
glxinfo | grep "OpenGL"

# Check Wayland session
echo $XDG_SESSION_TYPE

# Check environment variables
env | grep -E "(WAYLAND|XDG|QT)"
```

### Reset Configuration
If all else fails, reset to default configuration:
```bash
# Backup current config
cp -r ~/.config ~/.config.backup

# Remove problematic configs
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty

# Reinstall from setup
cd /path/to/arch-hyprland-setup
cp -r configs/* ~/.config/
```

## Getting Help

1. **Check Arch Wiki**: https://wiki.archlinux.org/title/Hyprland
2. **Hyprland Documentation**: https://hyprland.org/
3. **Community Forums**: 
   - r/hyprland on Reddit
   - Hyprland Discord server
   - Arch Linux forums

## Reporting Issues

When reporting issues, include:
1. System information (`fastfetch` output)
2. Hyprland version (`hyprctl version`)
3. Relevant log files
4. Steps to reproduce the issue
5. Expected vs actual behavior
