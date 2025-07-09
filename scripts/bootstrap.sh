#!/usr/bin/env bash
# Bootstrap script for setting up NixOS with this configuration
# Run this on a fresh NixOS installation

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
REPO_URL="https://github.com/yourusername/dotfiles.git"  # TODO: Update this
TARGET_DIR="$HOME/dotfiles"
HOST_NAME="framework-nixos"  # Default host

show_help() {
    echo "NixOS Dotfiles Bootstrap Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --host HOST    Target host configuration (default: framework-nixos)"
    echo "  -u, --url URL      Git repository URL"
    echo "  -d, --dir DIR      Target directory (default: ~/dotfiles)"
    echo "  --help             Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Use defaults"
    echo "  $0 --host desktop-nixos              # Different host"
    echo "  $0 --url git@github.com:user/dots    # Different repo"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--host)
                HOST_NAME="$2"
                shift 2
                ;;
            -u|--url)
                REPO_URL="$2"
                shift 2
                ;;
            -d|--dir)
                TARGET_DIR="$2"
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
}

check_requirements() {
    log_info "Checking requirements..."
    
    # Check if we're on NixOS
    if [[ ! -f /etc/NIXOS ]]; then
        log_error "This script is designed for NixOS only!"
        exit 1
    fi
    
    # Check if flakes are enabled
    if ! nix --version | grep -q "flake" 2>/dev/null; then
        log_warning "Nix flakes don't appear to be enabled"
        echo "Add this to your /etc/nixos/configuration.nix:"
        echo '  nix.settings.experimental-features = [ "nix-command" "flakes" ];'
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check for git
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please add 'git' to your system packages."
        exit 1
    fi
    
    log_success "Requirements check passed"
}

setup_dotfiles() {
    log_info "Setting up dotfiles repository..."
    
    # Clone or update repository
    if [[ -d "$TARGET_DIR" ]]; then
        log_info "Directory exists, updating..."
        cd "$TARGET_DIR"
        git pull
    else
        log_info "Cloning repository..."
        git clone "$REPO_URL" "$TARGET_DIR"
        cd "$TARGET_DIR"
    fi
    
    # Initialize flake.lock if it doesn't exist
    if [[ ! -f flake.lock ]]; then
        log_info "Initializing flake..."
        nix flake update
    fi
    
    log_success "Dotfiles repository ready"
}

setup_secrets() {
    log_info "Setting up secrets..."
    
    local secrets_dir="$TARGET_DIR/secrets"
    
    # Create git-config.nix if it doesn't exist
    if [[ ! -f "$secrets_dir/git-config.nix" ]]; then
        log_info "Creating git configuration..."
        
        read -p "Enter your full name: " git_name
        read -p "Enter your email: " git_email
        read -p "Enter your GitHub username (optional): " github_user
        
        cat > "$secrets_dir/git-config.nix" << EOF
{
  userName = "$git_name";
  userEmail = "$git_email";
  signingKey = ""; # TODO: Add GPG key ID if you use signed commits
  extraConfig = {
    github.user = "$github_user";
  };
}
EOF
        
        log_success "Created git-config.nix"
    fi
    
    # TODO: Setup age/agenix if needed
    log_info "For additional secrets, see $secrets_dir/README.md"
}

build_system() {
    log_info "Building and switching to new configuration..."
    
    cd "$TARGET_DIR"
    
    # Build first to check for errors
    log_info "Building configuration (dry run)..."
    if ! nix build ".#nixosConfigurations.$HOST_NAME.config.system.build.toplevel" --dry-run; then
        log_error "Configuration failed to build! Check the errors above."
        exit 1
    fi
    
    log_success "Configuration builds successfully"
    
    # Ask for confirmation
    echo ""
    log_warning "This will rebuild your NixOS system with the new configuration."
    log_warning "Make sure you have backups and understand the changes."
    echo ""
    read -p "Continue with system rebuild? (y/N) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Rebuilding system..."
        sudo nixos-rebuild switch --flake ".#$HOST_NAME"
        log_success "System rebuilt successfully!"
    else
        log_info "Skipping system rebuild"
        echo "To rebuild later, run:"
        echo "  cd $TARGET_DIR"
        echo "  sudo nixos-rebuild switch --flake .#$HOST_NAME"
    fi
}

setup_home_manager() {
    log_info "Setting up Home Manager..."
    
    cd "$TARGET_DIR"
    
    # Install home-manager if not available
    if ! command -v home-manager &> /dev/null; then
        log_info "Installing Home Manager..."
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell '<home-manager>' -A install
    fi
    
    # Build home configuration
    log_info "Building Home Manager configuration..."
    if home-manager switch --flake ".#$(whoami)@$HOST_NAME"; then
        log_success "Home Manager configured successfully!"
    else
        log_warning "Home Manager configuration failed, but continuing..."
    fi
}

main() {
    echo "🚀 NixOS Dotfiles Bootstrap"
    echo "=========================="
    echo ""
    
    parse_args "$@"
    check_requirements
    setup_dotfiles
    setup_secrets
    build_system
    setup_home_manager
    
    echo ""
    log_success "Bootstrap complete!"
    echo ""
    echo "Next steps:"
    echo "1. Reboot to ensure all changes take effect"
    echo "2. Review and customize configurations in $TARGET_DIR"
    echo "3. Set up additional secrets in $TARGET_DIR/secrets/"
    echo "4. Consider setting up automatic updates"
    echo ""
    echo "Happy hacking! 🎉"
}

main "$@"