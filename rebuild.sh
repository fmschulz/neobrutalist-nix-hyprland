#!/usr/bin/env bash
# Quick rebuild script
# Usage: ./rebuild.sh [system|home|all]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}󱐋${NC} $1"; }
success() { echo -e "${GREEN}${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}${NC} $1"; }

# Get hostname and username
HOST=$(hostname)
USER=$(whoami)

# Parse command
COMMAND=${1:-all}

case $COMMAND in
    "system" | "sys" | "s")
        info "Rebuilding system configuration..."
        sudo nixos-rebuild switch --flake ".#$HOST"
        success "System rebuilt successfully!"
        ;;
    "home" | "h")
        info "Rebuilding home-manager configuration..."
        # Since home-manager is integrated with NixOS, we need to rebuild the system
        # but only the home-manager part will be updated if system hasn't changed
        sudo nixos-rebuild switch --flake ".#$HOST"
        success "Home-manager rebuilt successfully!"
        ;;
    "all" | "a" | *)
        info "Rebuilding system and home-manager..."
        sudo nixos-rebuild switch --flake ".#$HOST"
        success "All configurations rebuilt successfully!"
        ;;
esac

# Show generation info
info "Latest generations:"
if [[ "$COMMAND" =~ ^(system|sys|s|all|a)$ ]] || [[ -z "$COMMAND" ]]; then
    echo "System: $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1 | awk '{print $1}')"
fi
if [[ "$COMMAND" =~ ^(home|h|all|a)$ ]] || [[ -z "$COMMAND" ]]; then
    # Home-manager generations are part of system generations when integrated
    echo "Home: Integrated with system generation"
fi
