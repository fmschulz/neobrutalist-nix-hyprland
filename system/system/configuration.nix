# Framework 13 AMD Hyprland-focused NixOS Configuration
# NixOS 25.05 version with latest packages

{ config, lib, pkgs, modulesPath, unstable, ... }:

{
  imports = [
    # Include the hardware scan results
    ../hardware/hardware-configuration.nix
  ];
  
  nixpkgs.config.allowUnfree = true;
  
  # Framework-specific boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    
    # Framework 13 AMD specific kernel parameters
    kernelParams = [
      "amd_pstate=active"           # Better AMD power management
      "amdgpu.sg_display=0"         # Fix display issues
      "rtc_cmos.use_acpi_alarm=1"   # Better RTC wake
      "mem_sleep_default=deep"      # Better suspend
      "module_blacklist=hid_sensor_hub"  # Fixes ambient light sensor issues
    ];
    
    # Use latest kernel for best Framework support
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Additional kernel modules
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # Enable the X server for XWayland support
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  # Use greetd with tuigreet (reliable terminal-based login)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
      };
    };
  };

  # Framework hardware support
  hardware = {
    # AMD graphics configuration - Correct for NixOS 25.05
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    # Bluetooth support
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    # Sensor support
    sensor.iio.enable = true;
  };

  # Power management for Framework
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # Thermal management
  services.thermald.enable = true;

  # Audio with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Networking
  networking = {
    hostName = "framework-nixos";
    networkmanager.enable = true;
    wireless.enable = false;  # Disable wpa_supplicant (conflicts with NetworkManager)
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # Framework-specific services
  services = {
    # Firmware updates
    fwupd.enable = true;
    
    # Fingerprint reader support
    fprintd.enable = true;
    
    # Battery management
    upower.enable = true;
    
    # Bluetooth manager
    blueman.enable = true;
    
    # Printing
    printing.enable = true;
    
    # SSH
    openssh.enable = true;
    
    # Input handling
    libinput.enable = true; 
    
    # Location services
    geoclue2.enable = true;

    # Power profiles
    power-profiles-daemon.enable = true;
  };

  # Time zone and localization
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # User account configuration moved to host-specific configuration

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.dconf.enable = true;

  # Gaming - Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true; # GameScope session for better gaming experience
  };

  # Docker support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # XDG Desktop Portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Security
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
    pam.services.hyprlock = {};
    pam.services.greetd = {};
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORMTHEME = "qt5ct";  # For Qt theming
    QT_STYLE_OVERRIDE = "Fusion";     # Force Fusion style for neo-brutalist look
  };

  # Fonts - Updated for NixOS 25.05
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    # NixOS 25.05 uses individual nerd-fonts packages
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.meslo-lg
  ];

  # Essential packages with unstable overlay support
  environment.systemPackages = with pkgs; [
    # Framework tools
    framework-tool
    libinput
    
    # Modern tools
    htop
    btop
    brightnessctl
    acpi
    powertop
    fastfetch  # Modern replacement for neofetch
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    
    # Cursor themes
    bibata-cursors
    
    # Hyprland ecosystem
    waybar
    wofi
    mako
    hypridle
    hyprlock
    hyprpolkitagent  # Should be available in 25.05
    swww
    
    # Wayland utilities
    wl-clipboard
    cliphist
    grim
    slurp
    grimblast
    swappy
    
    # System tray and notifications
    networkmanagerapplet
    blueman
    
    # File managers
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.breeze-icons
    yazi  # Modern terminal file manager
    
    # Terminals
    kitty
    vim
 
   # Audio
    pavucontrol
    playerctl
    
    # Development - Mix of stable and unstable for latest versions
    gcc
    cmake
    unstable.claude-code  # Latest claude-code from unstable
    python3
    nodejs_22  # Explicit version for stability
    docker-compose
    apptainer
    unstable.pixi  # Latest conda alternative
    unstable.uv    # Latest Python package manager
    ruff           # Fast Python linter
    
    # Browsers
    firefox
    ungoogled-chromium
    
    # Media
    mpv
    imv
    imagemagick
    
    # Bluetooth tools
    bluetuith
    
    # Office and Communication
    slack
    zoom-us
    vscode
    obsidian
    youtube-music
    discord
    signal-desktop
    
    # VPN
    tailscale
    
    # Additional utilities
    unzip
    p7zip
    tree
    fzf
    ripgrep
    eza         # Modern ls replacement
    bat         # Modern cat replacement
    zoxide      # Smarter cd
    starship              # Modern prompt
    atuin       # Better shell history
    gsettings-desktop-schemas
    glib
    adwaita-icon-theme
    
    # Hardware diagnostic tools
    alsa-utils  # aplay, arecord, speaker-test
    ffmpeg      # Video/audio testing
    v4l-utils   # Video4Linux utilities
    usbutils    # lsusb
    cheese      # Webcam testing
    libsForQt5.qt5.qtmultimedia  # Qt multimedia support
    pipewire.dev  # PipeWire development libraries
    
    # Performance monitoring
    # nvtop       # GPU monitoring - May need manual build
    iotop       # I/O monitoring
    nethogs     # Network monitoring
    
    # Additional development tools
    gh          # GitHub CLI
    git
    lazygit     # Terminal UI for git
    delta       # Better git diff
    tokei       # Code statistics
    hyperfine   # Command-line benchmarking
    quarto
    glow
  ];

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      
      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Storage drive mounting
  fileSystems."/home/storage" = {
    device = "/dev/disk/by-uuid/bfdbd63b-773e-4bc9-847c-3faeaeb78b73";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };

  # System state version - Update to 25.05
  system.stateVersion = "25.05";
}
