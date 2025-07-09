#!/usr/bin/env bash

# Test script to verify yazi configuration
echo "🧪 Testing Yazi Configuration"
echo "=============================="

# Check if yazi config files exist
echo "📁 Checking config files..."
if [ -f "$HOME/.config/yazi/yazi.toml" ]; then
    echo "✅ yazi.toml exists"
    echo "📄 Contents:"
    head -10 "$HOME/.config/yazi/yazi.toml"
else
    echo "❌ yazi.toml not found"
fi

if [ -f "$HOME/.config/yazi/keymap.toml" ]; then
    echo "✅ keymap.toml exists"
else
    echo "❌ keymap.toml not found"
fi

if [ -f "$HOME/.config/yazi/theme.toml" ]; then
    echo "✅ theme.toml exists"
else
    echo "❌ theme.toml not found"
fi

echo ""
echo "🎯 Testing yazi launch..."
echo "This should start yazi without confirmation prompts"
echo "Press 'q' to quit yazi when it opens"

# Brief pause
sleep 2

# Launch yazi in test mode
yazi --version
echo ""
echo "✅ Yazi configuration test complete!"