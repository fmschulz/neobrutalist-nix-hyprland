#!/usr/bin/env bash

# Monitor connection helper script
# This script helps handle external monitor connection issues

echo "🖥️  Monitor Connection Helper"
echo "=============================="

# Check current monitors
echo "📊 Current monitors:"
hyprctl monitors

echo ""
echo "🔄 Refreshing wallpaper on all monitors..."
swww img ~/dotfiles/home-manager/wallpapers/wp0.png --outputs all

echo ""
echo "🔧 Monitor troubleshooting tips:"
echo "- If scaling errors appear, disconnect and reconnect the monitor"
echo "- If wallpaper is wrong, run: swww img ~/dotfiles/home-manager/wallpapers/wp0.png --outputs all"
echo "- If notification persists, try: killall mako && mako &"
echo "- For persistent scaling issues, check hyprland monitor config"

echo ""
echo "🎛️  Available commands:"
echo "- monitor-connect: Run this script"
echo "- hyprctl monitors: Check current monitors"
echo "- swww img <path> --outputs all: Set wallpaper on all monitors"
echo "- hyprctl reload: Reload Hyprland config"