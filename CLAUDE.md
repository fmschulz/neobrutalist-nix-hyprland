# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive NixOS dotfiles repository using Nix flakes and Home Manager. It features a modular, host-based architecture with a consistent neo-brutalist theme across all applications.

## Essential Commands

### Daily Development (Most Common)
```bash
# Quick rebuild - use this for most changes
./rebuild.sh              # Rebuild both system and home-manager
./rebuild.sh system       # Rebuild system configuration only
./rebuild.sh home         # Rebuild home-manager only (for user packages/configs)

# Check configuration validity
nix flake check          # Validate all configurations before applying
```

### Advanced Deployment with Safety Checks
```bash
# Deploy with repository status checks and validation
./scripts/deploy.sh --all       # Full deployment with safety checks
./scripts/deploy.sh --home      # Home-manager only with checks
./scripts/deploy.sh --update    # Update flake inputs before deploying
./scripts/deploy.sh --force     # Skip confirmation prompts

# Convenient aliases (source aliases.sh first)
source aliases.sh
rebuild             # Quick rebuild both
deploy              # Safe deploy with checks
deploy-update       # Deploy with flake updates
```

### Testing Changes
```bash
# Test home-manager changes without switching
cd home-manager
./build-home-manager.sh build   # Test build without applying
./build-home-manager.sh switch  # Apply changes

# Development shell
nix develop              # Enter development environment
```

### Package Management
- Add/remove packages: Edit `home-manager/modules/packages.nix`
- Search packages: `nix search nixpkgs <package-name>`
- After editing packages: `./rebuild.sh home`

### Initial Setup and User Configuration
```bash
# Configure username and personal settings
./scripts/setup-user.sh         # Interactive setup for username, email, SSH aliases

# Bootstrap new system
./scripts/bootstrap.sh          # Full initial setup with validation

# Test hardware (Framework 13 specific)
./scripts/framework-hardware-test.sh
```

## Architecture & Key Files

### Flake Structure
- `flake.nix`: Main entry point, defines all NixOS configurations and home-manager profiles
- `hosts/`: Host-specific configurations (currently framework-nixos)
  - `configuration.nix`: System-level NixOS config
  - `home.nix`: User-level home-manager config  
  - `user.nix`: Portable user settings (username, email, etc.)

### Module System
- `home-manager/modules/`: Individual program configurations
  - `packages.nix`: All user packages (centralized)
  - Individual configs: hyprland.nix, kitty.nix, waybar.nix, etc.
- `hardware/`: Hardware profiles (Framework 13 AMD optimizations)
- `system/`: Core system modules
- `system-packages-minimal.nix`: Minimal system package philosophy reference

### Scripts
- `rebuild.sh`: Primary rebuild tool - handles both system and home-manager
- `scripts/deploy.sh`: Advanced deployment with safety checks, status validation
- `scripts/bootstrap.sh`: Initial setup for new installations
- `scripts/setup-user.sh`: Configure portable user settings
- `scripts/framework-hardware-test.sh`: Hardware validation for Framework 13
- `aliases.sh`: Shell aliases for common operations

### Important Patterns
1. **User Portability**: No hardcoded usernames - uses `${userConfig.username}` throughout
2. **Package Management**: Unstable overlay for latest versions (e.g., claude-code)
3. **Theme Consistency**: Neo-brutalist colors defined in each module
4. **Workspace Organization**: Apps auto-assign to workspaces 1-9
5. **Standalone Home-Manager**: Can be used independently with its own flake
6. **Environment Variables**: Modern approach using `.env` files (gitignored)

### Configuration Flow
1. `flake.nix` imports host configuration
2. Host config imports hardware profile and system modules
3. Home-manager config imports all user modules
4. Modules use dynamic username from user.nix

## Development Workflow

When making changes:
1. Edit the appropriate module file
2. Run `nix flake check` to validate
3. Use `./rebuild.sh` to apply changes (or `./scripts/deploy.sh` for safety checks)
4. For package additions, edit `home-manager/modules/packages.nix`

### Rollback and Recovery
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
home-manager generations

# Rollback if needed
home-manager rollback
sudo nixos-rebuild switch --rollback
```

## Critical Notes

- Always use `./rebuild.sh` for rebuilds (handles both system and home-manager correctly)
- The repository uses NixOS 25.05 (Warbler) with unstable overlay for latest packages
- Secrets are managed via templates in `secrets/` (gitignored)
- State is preserved across rebuilds with backup file extension
- Hardware-specific optimizations are in `hardware/framework-13-amd.nix`
- Environment variables in `home-manager/.env` (copy from `.env.template`)
- Custom bashrc managed declaratively in `home-manager/config/bashrc`

## Workspace Layout
Applications automatically assign to designated workspaces:
- **1**: Terminals (two kitty terminals - turquoise left, yellow right)
- **2**: Yazi (terminal file manager)
- **3**: Firefox (primary browser)
- **4**: VS Code (development)
- **5**: Chromium (secondary browser)
- **6**: btop (system monitoring)
- **7**: Slack (communication)
- **8**: Obsidian (notes)
- **9**: YouTube Music

## Recent Optimizations Applied

### Power Management
- **TLP enabled** with Framework 13 AMD specific settings
- Battery charge thresholds set to 75-80% for longevity
- CPU scaling optimized for AC/battery modes
- Wi-Fi and USB power management configured

### System Monitoring
- Added comprehensive monitoring tools: `lm_sensors`, `radeontop`, `nvtop`, `bandwhich`, `procs`, `dust`, `bottom`
- Network diagnostics: `nmap`, `traceroute`, `dig`, `whois`
- Hardware utilities: `lshw`, `dmidecode`, `lscpu`, `lsusb`, `lspci`

### Development Environment
- **Language servers**: `nil`, `nixd`, `rust-analyzer`, `gopls`, `typescript-language-server`
- **Development tools**: Python packages, Node.js tools, Rust toolchain, Go toolchain
- **Container tools**: `dive`, `lazydocker`, `podman`, `buildah`
- **Utilities**: `jq`, `yq`, `sqlite`, `postgresql`, `redis`

### Security Hardening
- **AppArmor** enabled with kill unconfined confinables
- **Audit system** enabled for system call monitoring
- **Enhanced firewall** with SSH rate limiting and ping blocking
- **Sudo hardening** with wheel-only execution
- **Kernel protection** enabled

### Package Management
- **Duplicate packages removed** from system configuration
- System packages limited to hardware-critical tools only
- All user applications moved to home-manager for better isolation

### Performance Optimizations
- **Kernel parameters** optimized for AMD performance and Framework 13
- **IOMMU** and **transparent hugepages** enabled
- **NVMe power saving** disabled for better performance
- **Vulkan renderer** and **AMD GPU optimizations** in Hyprland