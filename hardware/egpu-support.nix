# eGPU Support Configuration
# Based on Framework 13 AMD eGPU Reddit solutions
# Optimized for AMD RX 7800 XT in Razer Core X Chroma

{ config, lib, pkgs, ... }:

{
  # eGPU-specific boot configuration
  boot = {
    # Enable Thunderbolt support
    kernelModules = [ 
      "thunderbolt" 
      "amdgpu" 
    ];
    
    # eGPU-specific kernel parameters
    kernelParams = [
      # Enable PCIe hotplug for eGPU
      "pcie_ports=native"
      # NOTE: Removed pcie_port_pm=off to fix suspend issues
      # Thunderbolt security
      "thunderbolt.dyndbg=+p"
    ];
  };

  # Thunderbolt daemon for eGPU management
  services.hardware.bolt.enable = true;
  
  # udev rules for eGPU hotplug
  services.udev.extraRules = ''
    # Thunderbolt eGPU rules
    SUBSYSTEM=="thunderbolt", ACTION=="add", ATTR{authorized}=="0", ATTR{authorized}="1"
    
    # AMD GPU hotplug rules
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="egpu-attach@%k.service"
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ACTION=="remove", TAG+="systemd", ENV{SYSTEMD_WANTS}+="egpu-detach@%k.service"
  '';

  # eGPU management services
  systemd.services."egpu-attach@" = {
    description = "eGPU Attach Handler for %i";
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "egpu-attach" ''
        #!/bin/bash
        
        # Wait for GPU to be fully initialized
        sleep 2
        
        # Log the event
        echo "eGPU attached: /dev/dri/$1" | systemd-cat -t egpu-attach
        
        # Check if it's an external GPU (eGPU)
        if [[ -e /sys/class/drm/$1/device/removable ]] && [[ $(cat /sys/class/drm/$1/device/removable) == "removable" ]]; then
          # Set environment variables for eGPU
          export DRI_PRIME=1
          export WLR_DRM_DEVICES="/dev/dri/$1:/dev/dri/card2"
          
          # Restart Hyprland session if running
          if pgrep -x "Hyprland" > /dev/null; then
            # Send signal to restart Hyprland with new GPU configuration
            pkill -SIGUSR1 Hyprland || true
          fi
        fi
      ''}";
    };
  };

  systemd.services."egpu-detach@" = {
    description = "eGPU Detach Handler for %i";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "egpu-detach" ''
        #!/bin/bash
        
        # Log the event
        echo "eGPU detached: /dev/dri/$1" | systemd-cat -t egpu-detach
        
        # Reset environment variables
        unset DRI_PRIME
        unset WLR_DRM_DEVICES
        
        # Restart Hyprland session if running
        if pgrep -x "Hyprland" > /dev/null; then
          # Send signal to restart Hyprland without eGPU
          pkill -SIGUSR1 Hyprland || true
        fi
      ''}";
    };
  };

  # Environment variables for eGPU support
  environment.variables = {
    # AMD Vulkan driver
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # OpenGL driver override
    __GLX_VENDOR_LIBRARY_NAME = "amd";
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
  };

  # eGPU-specific packages
  environment.systemPackages = with pkgs; [
    # Thunderbolt management
    bolt
    
    # GPU monitoring and testing
    glxinfo
    vulkan-tools
    mesa-demos
    
    # Performance testing
    glmark2
    # unigine-superposition  # Commented out - large download, can install later if needed
    
    # AMD-specific tools
    radeontop
  ];

  # Graphics hardware configuration for dual GPU setup
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD drivers
      amdvlk
      rocmPackages.clr
      rocmPackages.clr.icd
      # Video acceleration
      libva
      libvdpau-va-gl
      vaapiVdpau
      mesa
      # GPU monitoring
      radeontop
      rocmPackages.rocm-smi
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      vaapiVdpau
    ];
  };

  # X server configuration for dual GPU
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
  };

  # Network shares for eGPU debugging
  # Useful for checking eGPU status from other machines
  # (Optional - remove if not needed)
  # services.samba = {
  #   enable = true;
  #   shares = {
  #     egpu-logs = {
  #       path = "/var/log";
  #       browseable = "yes";
  #       "read only" = "yes";
  #       "guest ok" = "yes";
  #       comment = "eGPU debugging logs";
  #     };
  #   };
  # };
}