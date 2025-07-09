#!/usr/bin/env bash
# Safe Home-Manager Testing Script
# This allows you to test home-manager without breaking your current setup

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    echo "Home-Manager Test Script"
    echo ""
    echo "This script helps you safely test home-manager configurations"
    echo "without affecting your current NixOS setup."
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  build         Build the home-manager configuration (dry run)"
    echo "  switch        Apply home-manager configuration (standalone)"
    echo "  nixos-test    Test full NixOS rebuild with home-manager"
    echo "  revert        Instructions to revert changes"
    echo "  help          Show this help message"
    echo ""
    echo "Start with 'build' to test if everything compiles correctly."
}

check_git() {
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Add it to your NixOS configuration first."
        echo "Add this to your configuration.nix:"
        echo "  environment.systemPackages = with pkgs; [ git ];"
        exit 1
    fi
}

build_home_manager() {
    log_info "Building home-manager configuration (dry run)..."
    
    cd "$SCRIPT_DIR"
    
    # Check if flake.lock exists, if not create it
    if [ ! -f "flake.lock" ]; then
        log_info "Initializing flake..."
        nix flake update
    fi
    
    log_info "Building configuration..."
    if nix build .#homeConfigurations."fschulz@framework".activationPackage --dry-run; then
        log_success "Build successful! Configuration is valid."
        echo ""
        echo "Next steps:"
        echo "1. Run '$0 switch' to apply the home-manager configuration"
        echo "2. Or run '$0 nixos-test' to test with full NixOS rebuild"
    else
        log_error "Build failed. Check the errors above."
        exit 1
    fi
}

switch_home_manager() {
    log_warning "This will apply home-manager configuration for your user."
    log_warning "Your system NixOS configuration will remain unchanged."
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Cancelled."
        exit 0
    fi
    
    cd "$SCRIPT_DIR"
    
    log_info "Backing up current home-manager generation..."
    if [ -d "$HOME/.config/home-manager" ]; then
        cp -r "$HOME/.config/home-manager" "$HOME/.config/home-manager.backup-$(date +%Y%m%d-%H%M%S)"
    fi
    
    log_info "Applying home-manager configuration..."
    if nix run .#homeConfigurations."fschulz@framework".activationPackage; then
        log_success "Home-manager configuration applied!"
        echo ""
        echo "Your user environment is now managed by home-manager."
        echo "To revert, run: $0 revert"
    else
        log_error "Failed to apply configuration."
        exit 1
    fi
}

test_nixos_rebuild() {
    log_warning "This will test a full NixOS rebuild with home-manager integrated."
    log_warning "This is a dry-run and won't actually change your system."
    echo ""
    
    cd "$SCRIPT_DIR"
    
    log_info "Testing NixOS rebuild with home-manager..."
    
    # Create a temporary test script that the user can run with sudo
    cat > test-nixos-rebuild.sh << 'EOF'
#!/usr/bin/env bash
cd "$(dirname "$0")"
sudo nixos-rebuild dry-run --flake .#framework-nixos-hm
EOF
    
    chmod +x test-nixos-rebuild.sh
    
    echo "To test the full NixOS rebuild, run:"
    echo "  cd $SCRIPT_DIR"
    echo "  ./test-nixos-rebuild.sh"
    echo ""
    echo "If the dry-run succeeds, you can do the actual rebuild with:"
    echo "  sudo nixos-rebuild switch --flake .#framework-nixos-hm"
}

show_revert() {
    echo "To revert home-manager changes:"
    echo ""
    echo "1. If you only applied home-manager (not NixOS rebuild):"
    echo "   home-manager generations  # List all generations"
    echo "   home-manager rollback     # Rollback to previous"
    echo ""
    echo "2. If you did a full NixOS rebuild:"
    echo "   sudo nixos-rebuild list-generations"
    echo "   sudo nixos-rebuild switch --rollback"
    echo ""
    echo "3. To completely remove home-manager:"
    echo "   rm -rf ~/.config/home-manager"
    echo "   rm -rf ~/.local/state/home-manager"
    echo "   rm -rf ~/.local/state/nix/profiles/home-manager*"
    echo ""
    echo "4. Your original configs are safe in:"
    echo "   ~/dotfiles/home/*  (original dotfiles)"
    echo "   ~/.config/home-manager.backup-*  (if you ran switch)"
}

main() {
    case "${1:-help}" in
        build)
            check_git
            build_home_manager
            ;;
        switch)
            check_git
            switch_home_manager
            ;;
        nixos-test)
            check_git
            test_nixos_rebuild
            ;;
        revert)
            show_revert
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"