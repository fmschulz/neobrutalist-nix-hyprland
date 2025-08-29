#!/usr/bin/env bash

# Fix script for NixOS freeze issues on Framework 13 AMD
# Root cause: AMD GPU driver wedge causing system freeze

set -e

echo "🔧 NixOS Freeze Recovery Script"
echo "================================"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should NOT be run as root"
   exit 1
fi

echo "📋 Detected Issues:"
echo "  • AMD GPU driver wedged and crashed"
echo "  • Audit queue overflow causing freezes"
echo "  • Thermal daemon incompatible with AMD CPU"
echo "  • No swap configured (memory pressure issues)"
echo ""

echo "✅ Applied Fixes:"
echo "  1. Added AMD GPU stability parameters"
echo "  2. Disabled problematic auditd service"
echo "  3. Disabled incompatible thermald"
echo "  4. Configured 16GB swap file"
echo ""

# Create swap file if it doesn't exist
if [[ ! -f /var/lib/swapfile ]]; then
    echo "📝 Creating swap file (requires sudo)..."
    sudo dd if=/dev/zero of=/var/lib/swapfile bs=1M count=16384 status=progress
    sudo chmod 600 /var/lib/swapfile
    sudo mkswap /var/lib/swapfile
    echo "✅ Swap file created"
fi

echo "🔄 Rebuilding NixOS configuration..."
cd ~/dotfiles

# Rebuild with the new configuration
./rebuild.sh

echo ""
echo "🎯 Post-rebuild checks:"
echo ""

# Verify kernel parameters
echo "Checking GPU kernel parameters..."
if cat /proc/cmdline | grep -q "amdgpu.ppfeaturemask"; then
    echo "✅ AMD GPU stability parameters active"
else
    echo "⚠️  GPU parameters not yet active - reboot required"
fi

# Check auditd status
if systemctl is-active auditd >/dev/null 2>&1; then
    echo "⚠️  Auditd still running - may need manual stop"
    echo "   Run: sudo systemctl stop auditd"
else
    echo "✅ Auditd disabled"
fi

# Check swap
if swapon --show | grep -q swapfile; then
    echo "✅ Swap file active"
else
    echo "⚠️  Swap not yet active - will activate on reboot"
fi

echo ""
echo "🚀 Additional Recommendations:"
echo ""
echo "1. Monitor GPU status:"
echo "   journalctl -f | grep amdgpu"
echo ""
echo "2. Check temperatures:"
echo "   sensors"
echo ""
echo "3. Monitor memory usage:"
echo "   free -h"
echo ""
echo "4. If freeze happens again, check:"
echo "   journalctl -b -1 -p err"
echo ""
echo "5. Consider updating firmware:"
echo "   sudo fwupdmgr refresh && sudo fwupdmgr update"
echo ""

echo "⚡ IMPORTANT: Reboot to fully apply all changes"
echo "   sudo reboot"
echo ""