#!/usr/bin/env bash

# Clear all persistent notifications
echo "🔄 Clearing all notifications..."

# Kill and restart mako (notification daemon)
pkill mako
sleep 0.5
mako &

# Clear any lingering notifications
makoctl dismiss --all

echo "✅ All notifications cleared and mako restarted"