# Framework 13 AMD Host Configuration
# Host-specific settings for framework-nixos

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Hardware configuration
    ../../hardware/framework-13-amd.nix
    
    # Original hardware scan (auto-generated)
    ../../system/hardware/hardware-configuration.nix
    
    # Common system configuration
    ../../system/system/configuration.nix
  ];
  
  # Host identification
  networking.hostName = "framework-nixos";
  networking.hostId = "12345678"; # Generate with: head -c 8 /etc/machine-id
  
  # Host-specific networking
  networking = {
    networkmanager.enable = true;
    wireless.enable = false;  # Using NetworkManager instead
    
    # Host-specific firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # SSH
      allowedUDPPorts = [ ];
    };
  };
  
  # Time zone (Berkeley, CA)
  time.timeZone = "America/Los_Angeles";
  
  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  
  # User configuration
  users.users.fschulz = {
    isNormalUser = true;
    description = "Framework User";
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
      "video" 
      "audio" 
      "docker" 
      "input" 
      "tty"
      "dialout"  # For hardware access
    ];
    shell = pkgs.bash;
  };
  
  # Host-specific services
  services = {
    # SSH with host-specific settings
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    
    # Tailscale for this host
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    
    # Host-specific location services (Berkeley)
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
  
  # Host-specific storage configuration
  fileSystems."/home/storage" = {
    device = "/dev/disk/by-uuid/bfdbd63b-773e-4bc9-847c-3faeaeb78b73";
    fsType = "ext4";
    options = [ "defaults" "user" "rw" ];
  };
  
  # Host system information (for documentation)
  # This helps when rebuilding or sharing the config
  system.nixos.label = "framework-nixos-${config.system.nixos.version}";
  
  # Host-specific environment variables
  environment.sessionVariables = {
    # Berkeley-specific settings
    TZ = "America/Los_Angeles";
    
    # Framework-specific optimizations
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}