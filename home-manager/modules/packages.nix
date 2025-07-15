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
    zip
    xz
    bzip2
    gzip
    # Network diagnostic tools
    wget
    curl
    nmap
    traceroute
    dig
    whois
    tcpdump
    # System monitoring
    lsof
    strace
    ltrace
    pciutils              # lspci
    usbutils              # lsusb
    hdparm                # disk utilities
    
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
    # Language servers and tools  
    rust-analyzer        # Rust LSP
    gopls               # Go LSP
    nodePackages.typescript-language-server  # TypeScript LSP
    # Modern development utilities
    direnv              # Environment management
    jq                  # JSON processor
    yq                  # YAML processor
    shellcheck          # Shell script linter
    # Container tools
    podman              # Alternative to Docker
    buildah             # Container build tool
    skopeo              # Container image utility
    
    # Scientific/Data Tools - INCLUDING UNSTABLE
    quarto
    # unstable.pixi        # Latest conda alternative - replaced with FHS wrapper below
    unstable.uv          # Latest Python package manager
    
    # Pixi with FHS wrapper for NixOS compatibility
    (pkgs.buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: with pkgs; [ unstable.pixi ];
    })
    
    # Language servers and development tools
    nil                  # Nix language server
    nixd                 # Alternative Nix language server
    nixfmt-rfc-style     # Nix formatter
    shellcheck           # Shell script linter
    shfmt                # Shell script formatter
    
    # Python development
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.setuptools
    python3Packages.wheel
    
    # JavaScript/TypeScript development
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.npm
    nodePackages.yarn
    
    # Rust development
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    
    # Go development
    go
    gopls
    gofumpt
    
    # Additional development utilities
    jq                   # JSON processor
    yq                   # YAML processor
    sqlite               # Database
    postgresql           # Database client
    redis                # Redis client
    
    # Container and virtualization
    dive                 # Docker image analyzer
    lazydocker          # Docker TUI
    podman              # Container runtime
    buildah             # Container builder
    
    # Text Editors & IDEs - INCLUDING UNSTABLE
    vim
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
    inkscape            # Vector graphics editor
    glow                # Terminal markdown renderer
    zathura             # PDF viewer (keyboard-driven)
    evince              # Alternative PDF viewer
    eog                 # Eye of GNOME image viewer
    vlc                 # Alternative video player
    gimp                # Image editor
    audacity            # Audio editor
    ffmpeg              # Media conversion
    sox                 # Sound processing tool
    
    # AI/ML Tools
    openai-whisper      # Speech recognition for meeting transcription
    
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
    
    # System monitoring and diagnostics
    lm_sensors          # Hardware sensors
    stress-ng           # System stress testing
    radeontop           # AMD GPU monitoring
    bandwhich           # Network bandwidth usage
    procs               # Modern ps replacement
    dust                # Disk usage analyzer
    duf                 # Disk usage/free utility
    bottom              # Alternative to btop
    
    # Network diagnostics
    nmap                # Network mapper
    traceroute          # Network tracing
    dig                 # DNS lookup
    whois               # Domain information
    curl                # HTTP client
    wget                # File downloader
    
    # File system tools
    ncdu                # Disk usage analyzer
    tree                # Already present but mentioned
    file                # File type identification
    
    # Hardware utilities
    lshw                # Hardware information
    dmidecode           # Hardware info from DMI
    usbutils            # USB device information (lsusb)
    pciutils            # PCI device information (lspci)
    
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
    # hyprlandPlugins.borders-plus-plus  # Temporarily disabled - causing black screen
    
    # Wayland Utilities
    wl-clipboard
    cliphist            # Clipboard history
    grim                # Screenshot
    slurp               # Region selection
    grimblast           # Screenshot wrapper
    swappy              # Screenshot annotation
    wlr-randr           # Display configuration
    wf-recorder         # Screen recording
    xdg-desktop-portal-wlr  # Screen sharing support
    wlogout             # Logout menu
    wlsunset            # Blue light filter
    
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
