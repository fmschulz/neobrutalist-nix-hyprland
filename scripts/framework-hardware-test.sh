#!/usr/bin/env bash

# Framework 13 AMD Hardware Diagnostic Script
# Tests webcam, speakers, microphone, and other hardware components

echo "🔧 Framework 13 AMD Hardware Diagnostic Test"
echo "=============================================="
echo ""

# Check if running on Framework hardware
echo "📋 Hardware Information:"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Hardware: $(cat /sys/class/dmi/id/product_name 2>/dev/null || echo 'Unknown')"
echo "BIOS: $(cat /sys/class/dmi/id/bios_version 2>/dev/null || echo 'Unknown')"
echo ""

# Audio System Check
echo "🔊 Audio System Status:"
echo "PipeWire status:"
systemctl --user status pipewire | grep -E "(Active|Main PID)"
echo ""

echo "Audio devices:"
wpctl status | grep -A 20 "Audio"
echo ""

# Test speakers
echo "🔊 Speaker Test:"
echo "Current speaker volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
echo "Available audio sinks:"
wpctl status | grep -A 10 "Sinks:"
echo ""

# Test microphone
echo "🎤 Microphone Test:"
echo "Current microphone volume: $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
echo "Available audio sources:"
wpctl status | grep -A 10 "Sources:"
echo ""

# Test webcam
echo "📹 Webcam Test:"
echo "Video devices:"
ls -la /dev/video*
echo ""

echo "V4L2 devices:"
v4l2-ctl --list-devices 2>/dev/null || echo "v4l2-ctl not available"
echo ""

echo "PipeWire video devices:"
wpctl status | grep -A 20 "Video"
echo ""

# Hardware checks
echo "🖥️ Hardware Status:"
echo "Graphics cards:"
lspci | grep -i vga
echo ""

echo "Audio controllers:"
lspci | grep -i audio
echo ""

echo "USB devices:"
lsusb | grep -i -E "(camera|audio|mic)"
echo ""

# Battery and power
echo "🔋 Power Status:"
acpi -b 2>/dev/null || echo "ACPI not available"
echo ""

echo "Power profile:"
powerprofilesctl get 2>/dev/null || echo "Power profiles not available"
echo ""

# Framework-specific tools
echo "🔧 Framework Tools:"
if command -v framework_tool >/dev/null 2>&1; then
    echo "Framework tool available"
    sudo framework_tool --version 2>/dev/null || echo "Framework tool needs sudo"
else
    echo "Framework tool not available"
fi
echo ""

# Bluetooth
echo "📡 Bluetooth Status:"
systemctl status bluetooth | grep -E "(Active|Main PID)"
echo ""

# Fingerprint reader
echo "👆 Fingerprint Reader:"
systemctl status fprintd | grep -E "(Active|Main PID)"
echo ""

# Test suggestions
echo "📝 Manual Test Suggestions:"
echo "1. Test speakers: speaker-test -t wav -c 2 -l 1"
echo "2. Test microphone recording: arecord -f cd -t wav -d 5 /tmp/mic_test.wav"
echo "3. Test webcam: ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -f image2 /tmp/webcam_test.jpg"
echo "4. Test webcam with GUI: cheese"
echo "5. Adjust volumes: wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%"
echo "6. Mute/unmute: wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
echo ""

echo "✅ Hardware diagnostic complete!"
echo "Report any issues found to ensure proper Framework 13 AMD configuration."