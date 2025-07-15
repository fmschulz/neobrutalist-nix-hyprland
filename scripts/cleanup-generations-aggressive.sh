#!/usr/bin/env bash

# Aggressive cleanup script - keeps only current + 2 previous generations
# WARNING: This will delete all other generations permanently!

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}=== AGGRESSIVE GENERATION CLEANUP ===${NC}"
echo -e "${YELLOW}WARNING: This will delete all but the 3 most recent generations!${NC}"
echo -e "${YELLOW}This action cannot be undone.${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/N): " -r
echo

if [[ ! $REPLY =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Function to cleanup generations keeping only the specified number
cleanup_generations() {
    local profile="$1"
    local profile_name="$2"
    local keep_count=3
    
    echo -e "\n${BLUE}=== Cleaning $profile_name ===${NC}"
    
    # List current generations
    echo -e "${YELLOW}Current generations:${NC}"
    if [[ "$profile_name" == "System" ]]; then
        sudo nix-env --list-generations --profile "$profile" || return 1
    else
        nix-env --list-generations --profile "$profile" 2>/dev/null || home-manager generations || return 1
    fi
    
    # Get all generation numbers
    if [[ "$profile_name" == "System" ]]; then
        local all_gens=$(sudo nix-env --list-generations --profile "$profile" | awk '{print $1}' | sort -n)
        local total_gens=$(echo "$all_gens" | wc -l)
        local current_gen=$(sudo nix-env --list-generations --profile "$profile" | grep '(current)' | awk '{print $1}')
    else
        # For home-manager, we need to handle it differently
        if command -v home-manager &> /dev/null; then
            local gen_list=$(home-manager generations 2>/dev/null)
        else
            local gen_list=$(nix-env --list-generations --profile "$profile" 2>/dev/null)
        fi
        local total_gens=$(echo "$gen_list" | wc -l)
        local current_gen="current"
    fi
    
    echo -e "${GREEN}Total generations: $total_gens${NC}"
    echo -e "${GREEN}Keeping: $keep_count most recent${NC}"
    
    if [ "$total_gens" -le "$keep_count" ]; then
        echo -e "${YELLOW}Already at or below $keep_count generations. Nothing to delete.${NC}"
        return 0
    fi
    
    # Calculate how many to delete
    local to_delete=$((total_gens - keep_count))
    echo -e "${RED}Deleting: $to_delete old generations${NC}"
    
    # Delete old generations
    if [[ "$profile_name" == "System" ]]; then
        # For system profile, we need to be more careful
        # Get generations to delete (all except the last 3)
        local gens_to_delete=$(sudo nix-env --list-generations --profile "$profile" | awk '{print $1}' | sort -nr | tail -n +4)
        
        if [ -n "$gens_to_delete" ]; then
            echo -e "${YELLOW}Deleting system generations: $gens_to_delete${NC}"
            for gen in $gens_to_delete; do
                echo "Deleting generation $gen..."
                sudo nix-env --delete-generations "$gen" --profile "$profile" || true
            done
        fi
    else
        # For home-manager
        echo -e "${YELLOW}Deleting old home-manager generations...${NC}"
        # Try different methods if home-manager command exists
        if command -v home-manager &> /dev/null; then
            home-manager expire-generations "-0 seconds" 2>/dev/null || true
        fi
        
        # Keep only the last 3
        local home_profile="$HOME/.local/state/nix/profiles/home-manager"
        if [ -e "$home_profile" ]; then
            local gens_to_delete=$(nix-env --list-generations --profile "$home_profile" 2>/dev/null | awk '{print $1}' | sort -nr | tail -n +4)
            for gen in $gens_to_delete; do
                echo "Deleting home-manager generation $gen..."
                nix-env --delete-generations "$gen" --profile "$home_profile" 2>/dev/null || true
            done
        fi
    fi
    
    echo -e "${GREEN}✓ $profile_name cleanup complete${NC}"
}

# Clean system generations
cleanup_generations "/nix/var/nix/profiles/system" "System"

# Clean home-manager generations  
cleanup_generations "$HOME/.local/state/nix/profiles/home-manager" "Home Manager"

# Clean root profile if it exists
if [ -e "/nix/var/nix/profiles/per-user/root/profile" ]; then
    echo -e "\n${BLUE}=== Cleaning Root Profile ===${NC}"
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/per-user/root/profile 2>/dev/null || true
fi

# Clean user profile
if [ -e "/nix/var/nix/profiles/per-user/$USER/profile" ]; then
    echo -e "\n${BLUE}=== Cleaning User Profile ===${NC}"
    nix-env --delete-generations old --profile /nix/var/nix/profiles/per-user/$USER/profile 2>/dev/null || true
fi

# Aggressive garbage collection
echo -e "\n${YELLOW}Running aggressive garbage collection...${NC}"
echo "Disk usage before:"
df -h /nix/store | grep -E "Filesystem|/nix/store"

# Run garbage collection with aggressive options
sudo nix-collect-garbage -d
sudo nix-store --optimize

echo -e "\n${GREEN}Disk usage after:${NC}"
df -h /nix/store | grep -E "Filesystem|/nix/store"

# Show what's left
echo -e "\n${BLUE}=== Remaining Generations ===${NC}"
echo -e "\n${YELLOW}System:${NC}"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -5

echo -e "\n${YELLOW}Home Manager:${NC}"
if command -v home-manager &> /dev/null; then
    home-manager generations 2>/dev/null | head -5
else
    nix-env --list-generations --profile "$HOME/.local/state/nix/profiles/home-manager" 2>/dev/null | tail -5 || echo "No home-manager generations found"
fi

echo -e "\n${GREEN}✓ Aggressive cleanup complete!${NC}"
echo -e "${YELLOW}Only the 3 most recent generations have been kept.${NC}"