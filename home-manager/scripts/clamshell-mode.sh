#!/usr/bin/env bash

# Clamshell mode script for Hyprland
# Manages display configuration when laptop lid is opened/closed
# FIXED: Handles undocking with lid closed to prevent black screen
# FIXED: Proper workspace migration and display recovery

ACTION="$1"
LAPTOP_DISPLAY="eDP-1"
LAPTOP_RESOLUTION="2880x1920@120"  # Framework 13 native resolution
LAPTOP_SCALE="1.5"  # Default scale for Framework 13

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
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,0x0,$LAPTOP_SCALE"
        # Wake display from DPMS sleep
        hyprctl dispatch dpms on
    fi
}

# Function to wake all displays
wake_displays() {
    echo "Waking all displays from sleep"
    hyprctl dispatch dpms on
    sleep 0.5  # Give displays time to wake
}

case "$ACTION" in
    "close")
        # Lid closed - disable laptop display only if external monitor is connected
        if has_external_monitor; then
            echo "Lid closed - switching to clamshell mode"
            
            # Get external monitor name
            EXTERNAL=$(get_external_monitor)
            if [ -n "$EXTERNAL" ]; then
                # First ensure external monitor is properly configured
                hyprctl keyword monitor "$EXTERNAL,preferred,0x0,1"
                sleep 0.5  # Give monitor time to initialize
                
                # Move all workspaces to external monitor BEFORE disabling laptop
                echo "Moving workspaces to external monitor: $EXTERNAL"
                for i in {1..9}; do
                    hyprctl dispatch moveworkspacetomonitor $i $EXTERNAL
                done
                
                # Now safe to disable laptop display
                hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
            fi
        else
            echo "Lid closed - no external monitor, keeping laptop display active"
        fi
        
        # Always ensure at least one display is active
        ensure_display_active
        ;;
        
    "open")
        # Lid opened - re-enable laptop display with proper recovery
        echo "Lid opened - recovering display"
        
        # Wake displays first
        wake_displays
        
        # Re-enable laptop display with correct resolution
        echo "Enabling laptop display with resolution $LAPTOP_RESOLUTION"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,0x0,$LAPTOP_SCALE"
        
        # Force display refresh
        hyprctl dispatch dpms off
        sleep 0.2
        hyprctl dispatch dpms on
        
        # If external monitor exists, configure multi-monitor setup
        if has_external_monitor; then
            EXTERNAL=$(get_external_monitor)
            if [ -n "$EXTERNAL" ]; then
                # Position external monitor to the right of laptop
                LAPTOP_WIDTH=1920  # Effective width after scaling (2880/1.5)
                hyprctl keyword monitor "$EXTERNAL,preferred,${LAPTOP_WIDTH}x0,1"
                
                # Redistribute workspaces
                echo "Setting up multi-monitor workspace distribution"
                # Workspaces 1-5 on laptop, 6-9 on external
                for i in {1..5}; do
                    hyprctl dispatch moveworkspacetomonitor $i $LAPTOP_DISPLAY
                done
                for i in {6..9}; do
                    hyprctl dispatch moveworkspacetomonitor $i $EXTERNAL
                done
            fi
        else
            # Single monitor - ensure all workspaces are on laptop
            echo "Single monitor mode - moving all workspaces to laptop"
            for i in {1..9}; do
                hyprctl dispatch moveworkspacetomonitor $i $LAPTOP_DISPLAY
            done
        fi
        ;;
        
    "dock-change")
        # Called when dock connection changes
        echo "Dock connection changed - reconfiguring displays"
        
        # Wake displays first
        wake_displays
        
        # If no external monitor and laptop display is disabled, enable it
        if ! has_external_monitor; then
            echo "No external monitor detected - ensuring laptop display is active"
            hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,0x0,$LAPTOP_SCALE"
            
            # Move all workspaces back to laptop
            for i in {1..9}; do
                hyprctl dispatch moveworkspacetomonitor $i $LAPTOP_DISPLAY
            done
        else
            # External monitor connected - check lid state
            LID_STATE=$(cat /proc/acpi/button/lid/LID0/state 2>/dev/null | awk '{print $2}')
            if [ "$LID_STATE" = "closed" ]; then
                # Apply clamshell mode
                $0 close
            else
                # Apply dual monitor mode
                $0 open
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
        
    "recover")
        # Emergency recovery mode
        echo "Emergency display recovery initiated"
        wake_displays
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,0x0,$LAPTOP_SCALE"
        hyprctl dispatch dpms on
        hyprctl reload
        echo "Recovery complete - display should be active"
        ;;
        
    *)
        echo "Usage: $0 {close|open|dock-change|status|recover}"
        echo "  close      - Called when lid is closed"
        echo "  open       - Called when lid is opened"
        echo "  dock-change - Called when dock connection changes"
        echo "  status     - Show current display configuration"
        echo "  recover    - Emergency display recovery"
        exit 1
        ;;
esac