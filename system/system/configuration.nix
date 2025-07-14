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
      "amd_iommu=on"                # Enable IOMMU for better virtualization
      "iommu=pt"                    # IOMMU passthrough mode
      "nvme_core.default_ps_max_latency_us=0"  # Better NVMe performance
      "transparent_hugepage=madvise" # Better memory performance
      # eGPU support parameters
      "pcie_ports=native"           # Enable PCIe hotplug for eGPU
      "pcie_port_pm=off"           # Disable PCIe power management for eGPU stability
    ];
    
    # Use latest kernel for best Framework support
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Additional kernel modules
    kernelModules = [ "kvm-amd" "thunderbolt" ];
    extraModulePackages = [ ];
  };
  
  # Zram configuration for better memory usage
  zramSwap = {
    enable = true;
    memoryPercent = 25;  # Use 25% of RAM for zram
    algorithm = "zstd";  # Better compression
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
    cpuFreqGovernor = "schedutil";  # Better than powersave for modern CPUs
    powertop.enable = true;
  };

  # Thermal management
  services.thermald.enable = true;
  
  # Advanced power management with TLP
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      # Framework-specific optimizations
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # USB autosuspend (be careful with this)
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;  # Don't suspend Bluetooth
      
      # PCIe power management
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      
      # Battery charge thresholds (helps battery longevity)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  
  # Disable power-profiles-daemon as it conflicts with TLP
  services.power-profiles-daemon.enable = false;

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
    networkmanager = {
      enable = true;
      # Enable captive portal handling
      plugins = with pkgs; [
        networkmanager-openconnect
        networkmanager-openvpn
      ];
    };
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
    
    # Lid close behavior - suspend on lid close
    logind = {
      lidSwitch = "suspend";          # Suspend when lid is closed
      lidSwitchDocked = "suspend";    # Suspend even when docked/external display connected
      lidSwitchExternalPower = "suspend"; # Suspend even when on AC power
      extraConfig = ''
        HandlePowerKey=suspend
        HandleSuspendKey=suspend
        HandleHibernateKey=hibernate
        IdleAction=suspend
        IdleActionSec=30min
      '';
    };
    
    # SSH
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    
    # Input handling
    libinput.enable = true; 
    
    # Location services
    geoclue2.enable = true;

    
    # SSD maintenance
    fstrim.enable = true;
    
  };
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
    allowedUDPPorts = [ ];
    # Tailscale will handle its own firewall rules
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

  # Security - Enhanced hardening
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
    pam.services.hyprlock = {};
    pam.services.greetd = {};
    
    # Additional security hardening
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
    
    # AppArmor security framework
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };
    
    # Real-time kit for better audio performance
    rtkit.enable = true;
    
    # Audit system calls
    auditd.enable = true;
    
    # Protect kernel parameters
    protectKernelImage = true;
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
    nerd-fonts.ubuntu-mono
    nerd-fonts.sauce-code-pro
    # Additional fonts for better coverage
    inter
    roboto
    ubuntu_font_family
    liberation_ttf
    source-sans-pro
    source-serif-pro
  ];

  # Essential system packages only (user packages managed by home-manager)
  environment.systemPackages = with pkgs; [
    # Framework hardware tools (system-level required)
    framework-tool
    libinput
    
    # System hardware control tools
    brightnessctl
    acpi
    powertop
    fastfetch
    libsForQt5.qt5ct
    
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
    
    # Network captive portal support
    captive-browser
    
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
