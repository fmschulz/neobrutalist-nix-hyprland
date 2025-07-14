#!/bin/bash

# eGPU Setup Script for Framework 13 AMD + AMD RX 7800 XT
# This script applies the eGPU configuration and provides testing commands

set -e

echo "🚀 Setting up eGPU support for Framework 13 AMD..."
echo

# Check if we're in the dotfiles directory
if [[ ! -f "flake.nix" ]]; then
    echo "❌ Please run this script from the dotfiles directory"
    exit 1
fi

# Skip validation for faster deployment (files are staged in git)
echo "1. Skipping validation (git files staged)..."
echo "✅ Configuration files prepared"
echo

# Build system configuration
echo "2. Building system configuration..."
if ! sudo nixos-rebuild switch --flake .#framework-nixos; then
    echo "❌ System rebuild failed"
    exit 1
fi
echo "✅ System configuration applied"
echo

# Build home-manager configuration
echo "3. Building home-manager configuration..."
if ! home-manager switch --flake .#fschulz@framework-nixos; then
    echo "❌ Home-manager rebuild failed"
    exit 1
fi
echo "✅ Home-manager configuration applied"
echo

# Check if eGPU is connected
echo "4. Checking eGPU status..."
echo "Thunderbolt devices:"
if command -v boltctl > /dev/null; then
    boltctl list || echo "No Thunderbolt devices found or boltctl failed"
else
    echo "boltctl not available (will be available after reboot)"
fi
echo

echo "DRI devices:"
ls -la /dev/dri/ || echo "No DRI devices found"
echo

# Provide next steps
echo "🎉 eGPU configuration has been applied!"
echo
echo "📋 Next steps:"
echo "1. Reboot your system: sudo reboot"
echo "2. Connect your eGPU to one of the back two USB-C ports"
echo "3. Power on the eGPU"
echo "4. Run the test commands below"
echo
echo "🧪 Testing commands (run after reboot and eGPU connection):"
echo "# Check eGPU detection:"
echo "boltctl list"
echo "ls /dev/dri/"
echo "lspci | grep -i vga"
echo
echo "# Test eGPU performance:"
echo "egpu-test"
echo
echo "# Monitor eGPU status:"
echo "egpu-monitor"
echo
echo "# Check GPU environment variables:"
echo "echo \$WLR_DRM_DEVICES"
echo "echo \$DRI_PRIME"
echo
echo "# Quick performance comparison:"
echo "glmark2 --size 800x600 --run-forever false"
echo "DRI_PRIME=1 glmark2 --size 800x600 --run-forever false"
echo
echo "📖 Troubleshooting tips:"
echo "- If eGPU is not detected, check Thunderbolt connection"
echo "- Use 'egpu-detect' to check GPU card assignments"
echo "- Performance should be much higher with DRI_PRIME=1"
echo "- Check logs with: journalctl -f | grep -i 'egpu\\|thunderbolt\\|amdgpu'"

echo
echo "🔧 Based on Reddit solutions, expected behavior:"
echo "- Integrated GPU: ~18,000 glmark2 score"
echo "- eGPU (RX 7800 XT): Should achieve much higher scores when working properly"
echo "- If eGPU scores are low (~600), environment variables may need adjustment"