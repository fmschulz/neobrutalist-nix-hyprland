#!/usr/bin/env bash

# Clamshell mode script for Hyprland
# Manages display configuration when laptop lid is opened/closed
# FIXED: Handles undocking with lid closed to prevent black screen

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

# Function to ensure at least one display is active
ensure_display_active() {
    # Count active monitors
    MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")
    
    if [ "$MONITOR_COUNT" -eq 0 ]; then
        echo "WARNING: No active monitors! Emergency enabling laptop display"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,2256x1504@60,0x0,1.566667"
    fi
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
        
        # Always ensure at least one display is active
        ensure_display_active
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
        
    "dock-change")
        # Called when dock connection changes
        echo "Dock connection changed - checking display configuration"
        
        # If no external monitor and laptop display is disabled, enable it
        if ! has_external_monitor; then
            LAPTOP_STATUS=$(hyprctl monitors | grep "$LAPTOP_DISPLAY" || echo "")
            if [ -z "$LAPTOP_STATUS" ]; then
                echo "Dock removed - enabling laptop display"
                hyprctl keyword monitor "$LAPTOP_DISPLAY,2256x1504@60,0x0,1.566667"
            fi
        fi
        
        # Always ensure at least one display is active
        ensure_display_active
        ;;
        
    "status")
        # Show current monitor configuration
        echo "Current monitor configuration:"
        hyprctl monitors
        echo ""
        echo "External monitor connected: $(has_external_monitor && echo 'yes' || echo 'no')"
        ;;
        
    *)
        echo "Usage: $0 {close|open|dock-change|status}"
        echo "  close      - Called when lid is closed"
        echo "  open       - Called when lid is opened"
        echo "  dock-change - Called when dock connection changes"
        echo "  status     - Show current display configuration"
        exit 1
        ;;
esac