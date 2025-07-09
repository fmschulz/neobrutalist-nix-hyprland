#!/usr/bin/env bash
# Convenient aliases for dotfiles management
# Source this in your shell or add to ~/.bashrc

# Quick rebuild aliases (most common usage)
alias rebuild="cd ~/dotfiles && ./rebuild.sh"
alias rebuild-system="cd ~/dotfiles && ./rebuild.sh system" 
alias rebuild-home="cd ~/dotfiles && ./rebuild.sh home"

# Advanced deployment
alias deploy="cd ~/dotfiles && ./scripts/deploy.sh"
alias deploy-all="cd ~/dotfiles && ./scripts/deploy.sh --all"
alias deploy-update="cd ~/dotfiles && ./scripts/deploy.sh --all --update"

# Package management
alias nix-search="nix search nixpkgs"
alias home-generations="home-manager generations"
alias system-generations="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"

# Flake utilities  
alias flake-check="cd ~/dotfiles && nix flake check"
alias flake-update="cd ~/dotfiles && nix flake update"
alias flake-show="cd ~/dotfiles && nix flake show"

# Development
alias dotfiles="cd ~/dotfiles"
alias home-config="cd ~/dotfiles/home-manager"
alias edit-packages="code ~/dotfiles/home-manager/modules/packages.nix"

echo "Dotfiles aliases loaded! Available commands:"
echo "  rebuild, rebuild-system, rebuild-home"
echo "  deploy, deploy-all, deploy-update"
echo "  nix-search, flake-check, flake-update"
echo "  dotfiles, home-config, edit-packages"