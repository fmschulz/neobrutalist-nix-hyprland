#!/usr/bin/env bash
# Meeting recorder and transcriber using Whisper
# Records audio and transcribes it after the meeting ends

set -euo pipefail

# Configuration
RECORDINGS_DIR="$HOME/Documents/meetings"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEFAULT_FORMAT="mp3"
DEFAULT_MODEL="base"  # Options: tiny, base, small, medium, large

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_help() {
    echo "Meeting Recorder and Transcriber"
    echo ""
    echo "Usage: $0 [OPTIONS] [meeting-name]"
    echo ""
    echo "Options:"
    echo "  -m MODEL      Whisper model to use (default: $DEFAULT_MODEL)"
    echo "                Options: tiny, base, small, medium, large"
    echo "  -f FORMAT     Audio format (default: $DEFAULT_FORMAT)"
    echo "  -d DIRECTORY  Output directory (default: $RECORDINGS_DIR)"
    echo "  -h            Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 team-standup"
    echo "  $0 -m small client-call"
    echo "  $0 -m large -f wav important-meeting"
}

# Parse arguments
MODEL="$DEFAULT_MODEL"
FORMAT="$DEFAULT_FORMAT"
OUTPUT_DIR="$RECORDINGS_DIR"

while getopts "m:f:d:h" opt; do
    case $opt in
        m) MODEL="$OPTARG" ;;
        f) FORMAT="$OPTARG" ;;
        d) OUTPUT_DIR="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done
shift $((OPTIND-1))

MEETING_NAME="${1:-meeting}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# File paths
AUDIO_FILE="$OUTPUT_DIR/${MEETING_NAME}_${TIMESTAMP}.${FORMAT}"
TRANSCRIPT_FILE="$OUTPUT_DIR/${MEETING_NAME}_${TIMESTAMP}.txt"
SUMMARY_FILE="$OUTPUT_DIR/${MEETING_NAME}_${TIMESTAMP}_summary.md"

# Check if required tools are available
if ! command -v ffmpeg &> /dev/null; then
    log_error "ffmpeg is not installed"
    exit 1
fi

if ! command -v whisper &> /dev/null; then
    log_error "whisper is not installed"
    exit 1
fi

# Get available audio devices
log_info "Available audio input devices:"
ffmpeg -f pulse -list_devices true -i "" 2>&1 | grep -E "^\[|alsa_input" || true
echo ""

# Start recording
log_info "Starting recording: $MEETING_NAME"
log_info "Output: $AUDIO_FILE"
log_info "Press Ctrl+C to stop recording..."
echo ""

# Set up signal handling
RECORDING_STOPPED=false
cleanup() {
    echo ""
    log_info "Recording stopped by user"
    RECORDING_STOPPED=true
    # Kill any running ffmpeg processes
    pkill -f "ffmpeg.*$AUDIO_FILE" 2>/dev/null || true
}
trap cleanup INT

# Record audio using PulseAudio (default input)
if command -v pactl &> /dev/null && pactl info &> /dev/null; then
    ffmpeg -f pulse -i default -acodec libmp3lame -ab 128k -ar 44100 "$AUDIO_FILE" 2>/dev/null
else
    # Fallback to ALSA if PulseAudio not available
    log_warning "PulseAudio not available, using ALSA..."
    ffmpeg -f alsa -i default -acodec libmp3lame -ab 128k -ar 44100 "$AUDIO_FILE" 2>/dev/null
fi

# Check if recording was interrupted or failed
if [ "$RECORDING_STOPPED" = true ]; then
    log_info "Recording was stopped by user"
    # Clean up partial file
    rm -f "$AUDIO_FILE" 2>/dev/null
    exit 0
fi

if [ ! -f "$AUDIO_FILE" ] || [ ! -s "$AUDIO_FILE" ]; then
    log_error "Recording failed or produced empty file"
    exit 1
fi

# Get audio duration
DURATION=$(ffmpeg -i "$AUDIO_FILE" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)
log_success "Recording saved: $AUDIO_FILE (Duration: $DURATION)"

# Transcribe audio
log_info "Transcribing audio using Whisper model: $MODEL"
log_info "This may take a while depending on the recording length..."

whisper "$AUDIO_FILE" \
    --model "$MODEL" \
    --output_dir "$OUTPUT_DIR" \
    --output_format txt \
    --language en \
    --task transcribe \
    --verbose False

# Rename whisper output to our naming convention
if [ -f "$OUTPUT_DIR/${MEETING_NAME}_${TIMESTAMP}.txt" ]; then
    WHISPER_OUTPUT="$OUTPUT_DIR/${MEETING_NAME}_${TIMESTAMP}.${FORMAT}.txt"
    if [ -f "$WHISPER_OUTPUT" ]; then
        mv "$WHISPER_OUTPUT" "$TRANSCRIPT_FILE"
    fi
fi

# Create summary file with metadata
cat > "$SUMMARY_FILE" << EOF
# Meeting Notes: $MEETING_NAME

**Date:** $(date +"%Y-%m-%d %H:%M:%S")
**Duration:** $DURATION
**Audio File:** $AUDIO_FILE
**Whisper Model:** $MODEL

## Transcript

$(cat "$TRANSCRIPT_FILE" 2>/dev/null || echo "Transcript not available")

## Notes

_Add your meeting notes and action items here_

### Action Items
- [ ] 

### Key Decisions
- 

### Follow-up Required
- 

EOF

log_success "Transcription complete!"
log_info "Files created:"
echo "  - Audio: $AUDIO_FILE"
echo "  - Transcript: $TRANSCRIPT_FILE"
echo "  - Summary: $SUMMARY_FILE"
echo ""
log_info "Opening summary file for editing..."

# Open the summary file in the default editor
if [ -n "${EDITOR:-}" ]; then
    $EDITOR "$SUMMARY_FILE"
else
    nano "$SUMMARY_FILE"
fi