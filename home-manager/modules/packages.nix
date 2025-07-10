{ config, pkgs, lib, unstable, ... }:
{
  # Note: allowUnfree is handled by global pkgs configuration
  
  home.packages = with pkgs; [
    # Terminal & Shell Tools
    htop
    btop
    eza                    # Modern ls replacement
    bat                    # Modern cat replacement
    ripgrep               # Fast grep
    fd                    # Fast find
    fzf                   # Fuzzy finder
    starship              # Modern prompt
    atuin                 # Better shell history
    tree
    unzip
    p7zip
    
    # Development Tools
    gcc
    cmake
    python3
    nodejs_22
    docker-compose
    gh                    # GitHub CLI
    git
    lazygit              # Terminal UI for git
    delta                # Better git diff
    tokei                # Code statistics
    hyperfine            # Command-line benchmarking
    ruff                 # Fast Python linter
    
    # Scientific/Data Tools - INCLUDING UNSTABLE
    quarto
    unstable.pixi        # Latest conda alternative
    unstable.uv          # Latest Python package manager
    
    # Text Editors & IDEs - INCLUDING UNSTABLE
    vim
    vscode
    unstable.claude-code  # Latest AI coding assistant
    
    # Browsers
    firefox
    ungoogled-chromium
    
    # File Managers
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.breeze-icons
    yazi
    
    # Media Tools
    mpv                  # Video player
    imv                  # Image viewer
    imagemagick         # Image manipulation
    glow                # Terminal markdown renderer
    
    # Communication
    slack
    zoom-us
    discord
    
    # Productivity
    obsidian
    youtube-music
    
    # System Tools
    brightnessctl
    acpi
    powertop
    fastfetch
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    
    # Audio
    pavucontrol
    playerctl
    
    # Bluetooth
    bluetuith
    blueman
    
    # Network
    networkmanagerapplet
    tailscale           # User CLI tools
    
    # Wayland/Hyprland Tools
    waybar
    wofi
    mako                 # Notification daemon
    hypridle            # Idle daemon
    hyprlock            # Screen locker
    hyprpolkitagent     # Polkit agent
    swww                # Wallpaper daemon
    hyprlandPlugins.borders-plus-plus  # Neo-brutalist shadow effect
    
    # Wayland Utilities
    wl-clipboard
    cliphist            # Clipboard history
    grim                # Screenshot
    slurp               # Region selection
    grimblast           # Screenshot wrapper
    swappy              # Screenshot annotation
    
    # Theming
    bibata-cursors
    adwaita-icon-theme
    gsettings-desktop-schemas
    glib
    
    # Monitoring Tools
    iotop               # I/O monitoring
    nethogs             # Network monitoring
    # nvtop             # GPU monitoring (might need manual build)
    
    # Framework Laptop Specific
    framework-tool
    libinput
    
    # Container/Virtualization tools (user-level)
    apptainer
    docker-client       # Docker CLI tools
    
    # Gaming
    lutris              # Game launcher for non-Steam games
    heroic              # Epic Games and GOG launcher
    gamemode            # Gaming optimizations
    mangohud            # Gaming overlay for FPS/performance monitoring
    gamescope           # Gaming compositor
  ];
  
  # Programs that need additional configuration
  programs.git = {
    enable = true;
    package = pkgs.git;
  };
  
  # Shell integrations - disabled, handled in custom bashrc
  programs.zoxide = {
    enable = true;
    enableBashIntegration = false;
  };
  
  # Services that have user-level components - disabled, handled in custom bashrc
  services.gpg-agent = {
    enable = false;
    enableSshSupport = true;
  };
  
  # Docker group membership handled in configuration.nix
  # Tailscale system service in configuration.nix, CLI tools above
  # fprintd system service in configuration.nix
}
