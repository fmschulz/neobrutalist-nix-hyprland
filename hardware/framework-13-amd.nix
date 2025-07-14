# Framework 13 AMD Hardware Profile
# Hardware-specific configurations for Framework 13 AMD (7040 series)

{ config, lib, pkgs, modulesPath, ... }:

{
  # Hardware generation identifier
  system.stateVersion = "25.05";
  
  # Hardware specifications (for documentation/reference)
  # This helps with rebuilding on similar hardware
  nixpkgs.hostPlatform = "x86_64-linux";
  
  # Framework 13 AMD specific boot configuration
  # Note: Boot loader and kernel config moved to system/system/configuration.nix to avoid conflicts
  
  # Framework-specific hardware support
  hardware = {
    # Enable firmware updates for Framework
    enableRedistributableFirmware = true;
    
    # AMD GPU support (updated for NixOS 25.05)
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        # ROCm OpenCL support (updated package names)
        rocmPackages.clr
        rocmPackages.clr.icd
        # Hardware video acceleration
        libva
        libvdpau-va-gl
        vaapiVdpau
        # AMD-specific video acceleration  
        mesa
        # GPU monitoring
        radeontop
        # Additional AMD tools
        rocmPackages.rocm-smi
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        vaapiVdpau
      ];
    };
    
    # Audio support - moved to services
    
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    
    # Framework fingerprint reader (handled by fprintd service)
  };
  
  # Framework-specific services
  services = {
    # Audio support
    pulseaudio.enable = false; # Using pipewire instead
    
    # Framework 13 AMD audio enhancement
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      
      # Framework-specific audio enhancements
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 1024;
          default.clock.min-quantum = 256;
          default.clock.max-quantum = 8192;
        };
      };
      
      # Framework 13 AMD microphone gain configuration
      extraConfig.pipewire."95-framework-audio" = {
        context.exec = [
          {
            path = "wpctl";
            args = [ "set-volume" "@DEFAULT_AUDIO_SOURCE@" "20%" ];
          }
        ];
      };
    };
    
    # Firmware updates
    fwupd.enable = true;
    
    # Fingerprint reader support  
    fprintd.enable = true;
    
    # Battery management
    upower.enable = true;
    
    # Framework-optimized power management
    # Power management - disabled in favor of TLP
    power-profiles-daemon.enable = false;
    
    # Framework-specific thermal management
    thermald.enable = true;
    
    # Framework laptop support
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };
    
    # X server for XWayland support
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };
  
  # Framework-specific environment optimizations
  environment = {
    variables = {
      # AMD GPU optimizations (base configuration)
      AMD_VULKAN_ICD = "RADV";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      
      # eGPU support variables (overridden by eGPU module when active)
      __GLX_VENDOR_LIBRARY_NAME = "amd";
      MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    };
    
    systemPackages = with pkgs; [
      # Framework-specific tools
      framework-tool
      
      # Hardware monitoring
      lm_sensors
      smartmontools
      
      # Power management
      powertop
      acpi
      
      # AMD tools
      radeontop
    ];
  };
  
  # Framework display configuration
  # Monitor scaling for Framework's high-DPI display
  environment.sessionVariables = {
    GDK_SCALE = "1.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
  
  # Hardware specifications (for reference)
  # Framework 13 AMD 7040 Series Specifications:
  # - CPU: AMD Ryzen 7 7840U (8 cores, 16 threads, up to 5.1 GHz)
  # - GPU: AMD Radeon 780M (integrated)
  # - RAM: Up to 64GB DDR5-5600
  # - Display: 13.5" 2256x1504 (3:2 aspect ratio)
  # - Storage: M.2 2280 NVMe SSD
  # - Ports: 4x USB-C/Thunderbolt 4 (modular)
  # - WiFi: WiFi 6E + Bluetooth 5.3
  # - Weight: 1.3kg (2.87 lbs)
}