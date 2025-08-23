#!/usr/bin/env bash

# Clamshell mode script for Hyprland
# Manages display configuration when laptop lid is opened/closed

ACTION="$1"
LAPTOP_DISPLAY="eDP-1"

# Function to check if external monitor is connected
has_external_monitor() {
    hyprctl monitors | grep -qE "Monitor (DP-|HDMI-)" 
}

# Function to get external monitor name
get_external_monitor() {
    hyprctl monitors | grep -E "Monitor (DP-|HDMI-)" | awk '{print $2}'
}

case "$ACTION" in
    "close")
        # Lid closed - disable laptop display only if external monitor is connected
        if has_external_monitor; then
            echo "Lid closed - disabling laptop display"
            hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
            
            # Ensure external monitor is primary
            EXTERNAL=$(get_external_monitor)
            if [ -n "$EXTERNAL" ]; then
                # Move all workspaces to external monitor
                for i in {1..9}; do
                    hyprctl dispatch moveworkspacetomonitor "$i $EXTERNAL"
                done
            fi
        else
            echo "Lid closed - no external monitor, keeping laptop display active"
        fi
        ;;
        
    "open")
        # Lid opened - re-enable laptop display
        echo "Lid opened - enabling laptop display"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,2256x1504@60,0x0,1.566667"
        
        # If external monitor exists, position it to the right
        if has_external_monitor; then
            EXTERNAL=$(get_external_monitor)
            if [ -n "$EXTERNAL" ]; then
                # Position external monitor to the right of laptop
                hyprctl keyword monitor "$EXTERNAL,preferred,2256x0,1"
            fi
        fi
        ;;
        
    "status")
        # Show current monitor configuration
        echo "Current monitor configuration:"
        hyprctl monitors
        ;;
        
    *)
        echo "Usage: $0 {close|open|status}"
        exit 1
        ;;
esac