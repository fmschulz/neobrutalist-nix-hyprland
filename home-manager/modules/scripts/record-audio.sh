#!/usr/bin/env bash
# Simple audio recorder for quick recordings

set -euo pipefail

# Configuration
RECORDINGS_DIR="${RECORDINGS_DIR:-$HOME/Documents/recordings}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FORMAT="${1:-mp3}"
OUTPUT_FILE="$RECORDINGS_DIR/recording_${TIMESTAMP}.${FORMAT}"

# Create directory
mkdir -p "$RECORDINGS_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Recording to:${NC} $OUTPUT_FILE"
echo -e "${BLUE}Press Ctrl+C to stop recording...${NC}"
echo ""

# Try PulseAudio first, fallback to ALSA
if command -v pactl &> /dev/null && pactl info &> /dev/null; then
    ffmpeg -f pulse -i default -acodec libmp3lame -ab 128k -ar 44100 "$OUTPUT_FILE" 2>/dev/null
else
    ffmpeg -f alsa -i default -acodec libmp3lame -ab 128k -ar 44100 "$OUTPUT_FILE" 2>/dev/null
fi

echo -e "\n${GREEN}Recording saved:${NC} $OUTPUT_FILE"