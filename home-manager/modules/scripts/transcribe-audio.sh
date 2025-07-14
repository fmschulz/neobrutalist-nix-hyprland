#!/usr/bin/env bash
# Transcribe audio files using Whisper

set -euo pipefail

# Configuration
DEFAULT_MODEL="base"  # Options: tiny, base, small, medium, large
DEFAULT_LANGUAGE="en"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    echo "Audio Transcriber using Whisper"
    echo ""
    echo "Usage: $0 [OPTIONS] <audio-file>"
    echo ""
    echo "Options:"
    echo "  -m MODEL      Whisper model (default: $DEFAULT_MODEL)"
    echo "                Options: tiny, base, small, medium, large"
    echo "  -l LANGUAGE   Language code (default: $DEFAULT_LANGUAGE)"
    echo "  -t            Translate to English"
    echo "  -h            Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 recording.mp3"
    echo "  $0 -m small meeting.wav"
    echo "  $0 -m large -l es spanish-audio.mp3"
    echo "  $0 -t -l ja japanese-audio.mp3  # Translate Japanese to English"
}

# Parse arguments
MODEL="$DEFAULT_MODEL"
LANGUAGE="$DEFAULT_LANGUAGE"
TASK="transcribe"

while getopts "m:l:th" opt; do
    case $opt in
        m) MODEL="$OPTARG" ;;
        l) LANGUAGE="$OPTARG" ;;
        t) TASK="translate" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done
shift $((OPTIND-1))

if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No audio file specified${NC}"
    show_help
    exit 1
fi

AUDIO_FILE="$1"

if [ ! -f "$AUDIO_FILE" ]; then
    echo -e "${RED}Error: File not found: $AUDIO_FILE${NC}"
    exit 1
fi

# Get output directory and base filename
OUTPUT_DIR=$(dirname "$AUDIO_FILE")
BASE_NAME=$(basename "$AUDIO_FILE" | sed 's/\.[^.]*$//')

echo -e "${BLUE}Transcribing:${NC} $AUDIO_FILE"
echo -e "${BLUE}Model:${NC} $MODEL"
echo -e "${BLUE}Language:${NC} $LANGUAGE"
echo -e "${BLUE}Task:${NC} $TASK"
echo ""

# Run Whisper
whisper "$AUDIO_FILE" \
    --model "$MODEL" \
    --output_dir "$OUTPUT_DIR" \
    --output_format all \
    --language "$LANGUAGE" \
    --task "$TASK" \
    --verbose False

echo -e "\n${GREEN}Transcription complete!${NC}"
echo -e "${BLUE}Output files:${NC}"
echo "  - ${OUTPUT_DIR}/${BASE_NAME}.txt (Plain text)"
echo "  - ${OUTPUT_DIR}/${BASE_NAME}.srt (Subtitles with timestamps)"
echo "  - ${OUTPUT_DIR}/${BASE_NAME}.vtt (WebVTT format)"
echo "  - ${OUTPUT_DIR}/${BASE_NAME}.json (Detailed output)"

# Display the transcript
echo -e "\n${BLUE}Transcript:${NC}"
echo "----------------------------------------"
cat "${OUTPUT_DIR}/${BASE_NAME}.txt" 2>/dev/null || echo "Transcript file not found"