#!/usr/bin/env bash
# Deploy script for updating NixOS configurations
# Handles both system and home-manager updates

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
HOST_NAME=$(hostname)
UPDATE_FLAKE=false
REBUILD_SYSTEM=false
REBUILD_HOME=false
FORCE=false

show_help() {
    echo "NixOS Dotfiles Deploy Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --system       Rebuild NixOS system configuration"
    echo "  -h, --home         Rebuild Home Manager configuration"
    echo "  -a, --all          Rebuild both system and home (default)"
    echo "  -u, --update       Update flake inputs before rebuilding"
    echo "  -f, --force        Skip confirmation prompts"
    echo "  --host HOST        Target host (default: current hostname)"
    echo "  --help             Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                 # Rebuild both system and home with prompts"
    echo "  $0 -s              # Only rebuild system"
    echo "  $0 -h              # Only rebuild home"
    echo "  $0 -u -a           # Update flake and rebuild all"
    echo "  $0 -f -a           # Rebuild all without prompts"
}

parse_args() {
    # Default to rebuild all if no specific options given
    local has_specific_target=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -s|--system)
                REBUILD_SYSTEM=true
                has_specific_target=true
                shift
                ;;
            -h|--home)
                REBUILD_HOME=true
                has_specific_target=true
                shift
                ;;
            -a|--all)
                REBUILD_SYSTEM=true
                REBUILD_HOME=true
                has_specific_target=true
                shift
                ;;
            -u|--update)
                UPDATE_FLAKE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            --host)
                HOST_NAME="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Default to rebuild all if no specific target given
    if [[ "$has_specific_target" == false ]]; then
        REBUILD_SYSTEM=true
        REBUILD_HOME=true
    fi
}

check_repo_status() {
    log_info "Checking repository status..."
    
    cd "$REPO_DIR"
    
    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "You have uncommitted changes:"
        git status --porcelain
        echo ""
        
        if [[ "$FORCE" == false ]]; then
            read -p "Continue anyway? (y/N) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi
    
    # Check if we're ahead of remote
    if git status | grep -q "ahead"; then
        log_warning "Local branch is ahead of remote. Consider pushing changes."
    fi
    
    log_success "Repository status OK"
}

update_flake() {
    if [[ "$UPDATE_FLAKE" == true ]]; then
        log_info "Updating flake inputs..."
        cd "$REPO_DIR"
        
        # Show what will be updated
        log_info "Current flake.lock:"
        nix flake metadata --json | jq -r '.locks.nodes.root.inputs | keys[]' || echo "Failed to show current inputs"
        
        # Update
        nix flake update
        
        # Show what changed
        if git diff --quiet flake.lock; then
            log_info "No updates available"
        else
            log_info "Updated inputs:"
            git diff flake.lock
        fi
        
        log_success "Flake updated"
    fi
}

check_configuration() {
    log_info "Checking configuration validity..."
    cd "$REPO_DIR"
    
    # Check flake
    if ! nix flake check; then
        log_error "Flake check failed!"
        exit 1
    fi
    
    # Dry build system if we're going to rebuild it
    if [[ "$REBUILD_SYSTEM" == true ]]; then
        log_info "Checking system configuration..."
        if ! nixos-rebuild dry-build --flake ".#$HOST_NAME"; then
            log_error "System configuration is invalid!"
            exit 1
        fi
    fi
    
    # Check home configuration if we're going to rebuild it
    if [[ "$REBUILD_HOME" == true ]]; then
        log_info "Checking home configuration..."
        if ! home-manager build --flake ".#$(whoami)@$HOST_NAME"; then
            log_error "Home configuration is invalid!"
            exit 1
        fi
    fi
    
    log_success "Configuration is valid"
}

rebuild_system() {
    if [[ "$REBUILD_SYSTEM" == true ]]; then
        log_info "Rebuilding NixOS system configuration..."
        
        if [[ "$FORCE" == false ]]; then
            echo ""
            log_warning "This will rebuild your NixOS system."
            read -p "Continue? (y/N) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Skipping system rebuild"
                return
            fi
        fi
        
        cd "$REPO_DIR"
        if sudo nixos-rebuild switch --flake ".#$HOST_NAME"; then
            log_success "System rebuilt successfully!"
        else
            log_error "System rebuild failed!"
            exit 1
        fi
    fi
}

rebuild_home() {
    if [[ "$REBUILD_HOME" == true ]]; then
        log_info "Rebuilding Home Manager configuration..."
        
        cd "$REPO_DIR"
        if home-manager switch --flake ".#$(whoami)@$HOST_NAME"; then
            log_success "Home Manager rebuilt successfully!"
        else
            log_error "Home Manager rebuild failed!"
            exit 1
        fi
    fi
}

show_generation_info() {
    log_info "Generation information:"
    
    if [[ "$REBUILD_SYSTEM" == true ]]; then
        echo "System generations:"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -3
    fi
    
    if [[ "$REBUILD_HOME" == true ]]; then
        echo "Home generations:"
        home-manager generations | tail -3
    fi
}

commit_changes() {
    cd "$REPO_DIR"
    
    # Check if flake.lock was updated
    if ! git diff --quiet flake.lock; then
        if [[ "$FORCE" == false ]]; then
            read -p "Commit flake.lock updates? (y/N) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git add flake.lock
                git commit -m "Update flake.lock - $(date)"
                log_success "Committed flake.lock updates"
            fi
        else
            git add flake.lock
            git commit -m "Update flake.lock - $(date)"
            log_success "Committed flake.lock updates"
        fi
    fi
}

main() {
    echo "🚀 NixOS Configuration Deploy"
    echo "============================="
    echo ""
    
    parse_args "$@"
    
    log_info "Configuration:"
    echo "  Host: $HOST_NAME"
    echo "  Update flake: $UPDATE_FLAKE"
    echo "  Rebuild system: $REBUILD_SYSTEM"
    echo "  Rebuild home: $REBUILD_HOME"
    echo "  Force: $FORCE"
    echo ""
    
    check_repo_status
    update_flake
    check_configuration
    rebuild_system
    rebuild_home
    show_generation_info
    commit_changes
    
    echo ""
    log_success "Deploy complete!"
    echo ""
    echo "🎉 Your system is up to date!"
}

main "$@"