#!/usr/bin/env bash

# Framework 13 AMD Audio Setup Script
# Configures optimal audio settings for Framework laptop

echo "🎵 Framework 13 AMD Audio Setup"
echo "================================="
echo ""

# Check current audio status
echo "Current audio device status:"
wpctl status | grep -A 10 "Audio"
echo ""

# Set microphone gain to 20% (recommended for Framework 13)
echo "🎤 Setting microphone gain to 20% (recommended for Framework 13)..."
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 20%
echo "New microphone volume: $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
echo ""

# Set speaker volume to reasonable level
echo "🔊 Setting speaker volume to 50%..."
wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
echo "New speaker volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
echo ""

# Check if audio enhancement is available
echo "🔧 Checking audio enhancements..."
if command -v pulseeffects >/dev/null 2>&1; then
    echo "PulseEffects available for audio enhancement"
elif command -v easyeffects >/dev/null 2>&1; then
    echo "EasyEffects available for audio enhancement"
else
    echo "No audio effects software detected"
fi
echo ""

# Test audio devices
echo "🧪 Testing audio devices..."
echo "Available audio sinks:"
wpctl status | grep -A 5 "Sinks:"
echo ""

echo "Available audio sources:"
wpctl status | grep -A 5 "Sources:"
echo ""

# Framework-specific recommendations
echo "📋 Framework 13 AMD Audio Recommendations:"
echo "1. Microphone gain set to 20% (done)"
echo "2. Enable 'Linux Audio Compatibility' in BIOS (manual step)"
echo "3. Use balanced power profile for optimal audio (current: $(powerprofilesctl get 2>/dev/null || echo 'unknown'))"
echo "4. Consider using noise cancellation software for video calls"
echo ""

# Save settings note
echo "💾 Note: These settings are temporary and will reset on reboot."
echo "To make permanent, add to NixOS configuration or create a startup script."
echo ""

echo "✅ Audio setup complete!"