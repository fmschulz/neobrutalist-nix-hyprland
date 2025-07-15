#!/usr/bin/env bash

# Script to clean up old NixOS and Home Manager generations
# Keeps only the current and previous 2 generations

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== NixOS Generation Cleanup ===${NC}"
echo ""

# Function to get current generation number
get_current_generation() {
    local profile="$1"
    sudo nix-env --list-generations --profile "$profile" | grep '(current)' | awk '{print $1}'
}

# Function to list generations to keep
get_generations_to_keep() {
    local profile="$1"
    local current="$2"
    local keep_count="$3"
    
    # Get all generation numbers in descending order
    sudo nix-env --list-generations --profile "$profile" | awk '{print $1}' | sort -nr | head -n "$keep_count"
}

# Clean system generations
echo -e "${YELLOW}System Generations:${NC}"
SYSTEM_PROFILE="/nix/var/nix/profiles/system"

echo "Current generations:"
sudo nix-env --list-generations --profile "$SYSTEM_PROFILE" | tail -10

CURRENT_GEN=$(get_current_generation "$SYSTEM_PROFILE")
echo -e "\n${GREEN}Current generation: $CURRENT_GEN${NC}"

# Get the 3 most recent generations (current + 2 previous)
KEEP_GENS=$(get_generations_to_keep "$SYSTEM_PROFILE" "$CURRENT_GEN" 3)
echo -e "${GREEN}Keeping generations: $(echo $KEEP_GENS | tr '\n' ' ')${NC}"

# Delete old system generations
echo -e "\n${YELLOW}Cleaning up old system generations...${NC}"
# Keep only the last 3 generations
sudo nix-env --delete-generations +3 --profile "$SYSTEM_PROFILE" 2>/dev/null || true

echo -e "${GREEN}✓ System generations cleaned${NC}"

# Clean home-manager generations
echo -e "\n${YELLOW}Home Manager Generations:${NC}"
echo "Current generations:"
if command -v home-manager &> /dev/null; then
    home-manager generations | head -10
else
    nix-env --list-generations --profile "$HOME/.local/state/nix/profiles/home-manager" 2>/dev/null | tail -10 || echo "No home-manager profile found"
fi

echo -e "\n${YELLOW}Cleaning up old home-manager generations...${NC}"
# Keep only the last 3 generations
if [ -e "$HOME/.local/state/nix/profiles/home-manager" ]; then
    # Get all generation numbers
    TOTAL_GENS=$(nix-env --list-generations --profile "$HOME/.local/state/nix/profiles/home-manager" 2>/dev/null | wc -l || echo 0)
    if [ "$TOTAL_GENS" -gt 3 ]; then
        # Delete all but the last 3
        nix-env --delete-generations +3 --profile "$HOME/.local/state/nix/profiles/home-manager" 2>/dev/null || true
    fi
fi

echo -e "${GREEN}✓ Home Manager generations cleaned${NC}"

# Run garbage collection
echo -e "\n${YELLOW}Running garbage collection to free up space...${NC}"
echo "Disk usage before cleanup:"
df -h /nix/store | grep -E "Filesystem|/nix/store"

# Collect garbage
sudo nix-collect-garbage

echo -e "\n${GREEN}Disk usage after cleanup:${NC}"
df -h /nix/store | grep -E "Filesystem|/nix/store"

# Show remaining generations
echo -e "\n${BLUE}=== Remaining Generations ===${NC}"
echo -e "\n${YELLOW}System generations:${NC}"
sudo nix-env --list-generations --profile "$SYSTEM_PROFILE" | tail -5

echo -e "\n${YELLOW}Home Manager generations:${NC}"
if command -v home-manager &> /dev/null; then
    home-manager generations | head -5
else
    nix-env --list-generations --profile "$HOME/.local/state/nix/profiles/home-manager" 2>/dev/null | tail -5 || echo "No home-manager profile found"
fi

echo -e "\n${GREEN}✓ Cleanup complete!${NC}"
echo -e "${YELLOW}Note: The most recent 3 generations have been kept for both system and home-manager.${NC}"