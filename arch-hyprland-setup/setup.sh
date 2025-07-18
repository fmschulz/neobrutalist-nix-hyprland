#!/bin/bash

# Arch Linux Hyprland Setup Script
# Extracted from NixOS configuration for neo-brutalist Hyprland environment
# Run as regular user (not root)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Neo-brutalist banner
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${NC}  ${PURPLE}▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${NC}  ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}  ${PURPLE}█${NC} ${CYAN}ARCH LINUX HYPRLAND SETUP${NC} ${PURPLE}█${NC}                        ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}  ${PURPLE}█${NC} ${GREEN}Neo-Brutalist Theme${NC} ${PURPLE}█${NC}                              ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}  ${PURPLE}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}  ${YELLOW}║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should NOT be run as root!${NC}"
   echo -e "${YELLOW}Please run as your regular user account.${NC}"
   exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🚀 Starting Arch Linux Hyprland setup...${NC}"
echo

# Function to print step headers
print_step() {
    echo -e "${PURPLE}▶ $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update system
print_step "Updating system packages"
sudo pacman -Syu --noconfirm

# Install base-devel if not present (needed for AUR)
print_step "Installing base development tools"
sudo pacman -S --needed --noconfirm base-devel git

# Install yay AUR helper if not present
if ! command_exists yay; then
    print_step "Installing yay AUR helper"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
else
    echo -e "${GREEN}✓ yay already installed${NC}"
fi

# Install official packages
print_step "Installing official repository packages"
if [[ -f "packages/pacman-packages.txt" ]]; then
    sudo pacman -S --needed --noconfirm $(cat packages/pacman-packages.txt)
else
    echo -e "${RED}❌ packages/pacman-packages.txt not found${NC}"
    exit 1
fi

# Install AUR packages
print_step "Installing AUR packages"
if [[ -f "packages/aur-packages.txt" ]]; then
    yay -S --needed --noconfirm $(cat packages/aur-packages.txt)
else
    echo -e "${YELLOW}⚠ packages/aur-packages.txt not found, skipping AUR packages${NC}"
fi

# Create necessary directories
print_step "Creating configuration directories"
mkdir -p ~/.config
mkdir -p ~/.local/share
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/Pictures/screenshots

# Copy configurations
print_step "Installing configuration files"
if [[ -d "configs" ]]; then
    cp -r configs/* ~/.config/
    echo -e "${GREEN}✓ Configuration files copied${NC}"
else
    echo -e "${RED}❌ configs directory not found${NC}"
    exit 1
fi

# Make scripts executable
print_step "Setting up scripts"
if [[ -d ~/.config/scripts ]]; then
    chmod +x ~/.config/scripts/*
    echo -e "${GREEN}✓ Scripts made executable${NC}"
fi

# Copy wallpapers
print_step "Installing wallpapers"
if [[ -d "wallpapers" ]]; then
    cp wallpapers/* ~/Pictures/wallpapers/
    echo -e "${GREEN}✓ Wallpapers copied${NC}"
else
    echo -e "${YELLOW}⚠ wallpapers directory not found${NC}"
fi

# Set up shell configuration
print_step "Setting up shell configuration"
if [[ -f ~/.config/bash/bashrc ]]; then
    # Backup existing bashrc
    if [[ -f ~/.bashrc ]]; then
        cp ~/.bashrc ~/.bashrc.backup
        echo -e "${YELLOW}⚠ Backed up existing ~/.bashrc to ~/.bashrc.backup${NC}"
    fi

    # Create new bashrc that sources our config
    cat > ~/.bashrc << 'EOF'
# Arch Linux Hyprland Setup - Custom bashrc
# Source the custom configuration
if [ -f ~/.config/bash/bashrc ]; then
    source ~/.config/bash/bashrc
fi

# Set up starship prompt
if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    eval "$(starship init bash)"
fi
EOF
    echo -e "${GREEN}✓ Shell configuration set up${NC}"
fi

# Enable and start services
print_step "Enabling system services"
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager

# Set up fonts
print_step "Refreshing font cache"
fc-cache -fv

# Create desktop entry for Hyprland (if using a display manager)
print_step "Setting up Hyprland desktop entry"
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

echo
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${NC}                        ${CYAN}NEXT STEPS${NC}                           ${YELLOW}║${NC}"
echo -e "${YELLOW}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${YELLOW}║${NC} 1. ${GREEN}Reboot your system${NC}                                    ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC} 2. ${GREEN}Select 'Hyprland' from your display manager${NC}          ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC} 3. ${GREEN}Press Super+Return to open terminal${NC}                  ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC} 4. ${GREEN}Press Super+D to open application launcher${NC}           ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC} 5. ${GREEN}Check docs/keybindings.md for all shortcuts${NC}          ${YELLOW}║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "   • Keybindings: ${SCRIPT_DIR}/docs/keybindings.md"
echo -e "   • Troubleshooting: ${SCRIPT_DIR}/docs/troubleshooting.md"
echo
echo -e "${PURPLE}🎨 Theme switching:${NC}"
echo -e "   • Kitty themes: Ctrl+Alt+1-8"
echo -e "   • Wallpapers: Super+W, Super+Shift+W, Super+Ctrl+W"
echo
echo -e "${CYAN}Enjoy your neo-brutalist Hyprland setup! 🚀${NC}"
