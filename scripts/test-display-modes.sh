#!/usr/bin/env bash

# Display Mode Testing Script for Framework 13
# Tests all clamshell and multi-monitor scenarios

set -e

CLAMSHELL_SCRIPT="/home/fschulz/dotfiles/home-manager/scripts/clamshell-mode.sh"

echo "🖥️  Display Mode Testing Suite"
echo "==============================="
echo ""

# Function to wait for user confirmation
confirm() {
    echo -n "Press ENTER when ready to continue..."
    read
}

# Function to check current display state
check_state() {
    echo ""
    echo "📊 Current Display State:"
    echo "------------------------"
    hyprctl monitors | grep -E "Monitor|focused|active workspace"
    echo ""
    echo "Workspaces:"
    hyprctl workspaces | grep -E "workspace ID" | head -5
    echo ""
}

echo "⚠️  IMPORTANT: Save all work before testing!"
echo "This test will manipulate displays and workspaces."
echo ""
confirm

echo "Test 1: Current State Check"
echo "----------------------------"
check_state

echo "Test 2: Emergency Recovery"
echo "--------------------------"
echo "Testing display recovery mechanism..."
$CLAMSHELL_SCRIPT recover
sleep 2
check_state
echo "✅ Recovery test complete"
echo ""
confirm

echo "Test 3: Lid Close Simulation (with external monitor)"
echo "-----------------------------------------------------"
echo "Connect an external monitor if available, then continue."
confirm
echo "Simulating lid close..."
$CLAMSHELL_SCRIPT close
sleep 2
check_state
echo "Check: All workspaces should be on external monitor"
echo ""
confirm

echo "Test 4: Lid Open Simulation"
echo "----------------------------"
echo "Simulating lid open..."
$CLAMSHELL_SCRIPT open
sleep 2
check_state
echo "Check: Laptop display should be active, workspaces distributed"
echo ""
confirm

echo "Test 5: Dock Change Simulation"
echo "-------------------------------"
echo "Simulating dock/undock event..."
$CLAMSHELL_SCRIPT dock-change
sleep 2
check_state
echo "Check: Appropriate display configuration based on dock state"
echo ""
confirm

echo "Test 6: Manual Workspace Migration"
echo "-----------------------------------"
echo "Testing workspace movement commands..."

# Get monitor names
MONITORS=($(hyprctl monitors | grep "Monitor" | awk '{print $2}'))

if [ ${#MONITORS[@]} -gt 1 ]; then
    echo "Found ${#MONITORS[@]} monitors: ${MONITORS[*]}"
    echo "Moving workspace 1 to second monitor..."
    hyprctl dispatch moveworkspacetomonitor 1 ${MONITORS[1]}
    sleep 1
    echo "Moving it back to first monitor..."
    hyprctl dispatch moveworkspacetomonitor 1 ${MONITORS[0]}
    echo "✅ Workspace migration test complete"
else
    echo "Only one monitor detected, skipping migration test"
fi
echo ""
confirm

echo "Test 7: DPMS Power Management"
echo "-----------------------------"
echo "Testing display sleep/wake..."
echo "Turning displays OFF in 3 seconds..."
sleep 3
hyprctl dispatch dpms off
echo "Displays should be OFF. Press ENTER to wake them..."
confirm
hyprctl dispatch dpms on
echo "✅ DPMS test complete"
echo ""

echo "Test 8: Hyprland Reload"
echo "-----------------------"
echo "Reloading Hyprland configuration..."
hyprctl reload
sleep 2
check_state
echo "✅ Reload test complete"
echo ""

echo "📋 Test Summary"
echo "==============="
echo ""
echo "Please verify the following worked correctly:"
echo "1. ✓ Display recovery restored laptop screen"
echo "2. ✓ Lid close moved all workspaces to external monitor"
echo "3. ✓ Lid open restored laptop display"
echo "4. ✓ Dock changes were detected properly"
echo "5. ✓ Workspace migration worked"
echo "6. ✓ DPMS sleep/wake functioned"
echo "7. ✓ Configuration reload preserved display state"
echo ""
echo "If any test failed, check journalctl for errors:"
echo "  journalctl -xe | grep -E 'clamshell|hyprland|display'"
echo ""
echo "For persistent issues, try:"
echo "  1. Rebuild NixOS: ./rebuild.sh"
echo "  2. Restart display services: systemctl --user restart display-recovery lid-handler"
echo "  3. Emergency recovery: $CLAMSHELL_SCRIPT recover"
echo ""