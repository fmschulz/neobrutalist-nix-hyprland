#!/usr/bin/env bash

# Fix touchpad click issues after dock/undock on Framework 13

echo "🖱️ Fixing touchpad click functionality..."

# Method 1: Reload touchpad via Hyprland
echo "Reloading Hyprland input configuration..."
hyprctl reload

# Method 2: Reset touchpad settings
echo "Applying touchpad settings..."
hyprctl keyword input:touchpad:clickfinger_behavior 1
hyprctl keyword input:touchpad:tap-to-click 1
hyprctl keyword input:touchpad:drag_lock 0
hyprctl keyword input:touchpad:natural_scroll 1
hyprctl keyword input:touchpad:disable_while_typing 1

# Method 3: Restart input module if needed
if command -v libinput &> /dev/null; then
    echo "Checking libinput status..."
    libinput list-devices | grep -i touchpad
fi

echo "✅ Touchpad fix applied!"
echo ""
echo "Test the following:"
echo "1. Tap to click"
echo "2. Physical click"
echo "3. Two-finger right-click"
echo "4. Two-finger scroll"
echo ""
echo "If still not working, try:"
echo "  hyprctl dispatch exit  # Then log back in"