# Force eGPU Driver Binding for RX 7900 XT
# Fixes issue where amdgpu driver doesn't automatically bind to eGPU

{ config, lib, pkgs, ... }:

{
  # Force the eGPU to use amdgpu driver via udev rules
  services.udev.extraRules = ''
    # Force RX 7900 XT eGPU (1002:744c) to use amdgpu driver
    SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x744c", RUN+="${pkgs.bash}/bin/bash -c 'echo amdgpu > /sys/bus/pci/devices/%k/driver_override'"
    SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x744c", RUN+="${pkgs.bash}/bin/bash -c 'echo %k > /sys/bus/pci/drivers/amdgpu/bind || true'"
    
    # Also try alternative approach with modprobe
    SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x744c", RUN+="${pkgs.kmod}/bin/modprobe amdgpu"
  '';

  # Additional kernel modules to ensure amdgpu is loaded early
  boot.kernelModules = [ "amdgpu" ];
  
  # More aggressive kernel parameters for eGPU support
  boot.kernelParams = [
    # Force amdgpu support for newer cards
    "amdgpu.si_support=1" 
    "amdgpu.cik_support=1"
    "amdgpu.exp_hw_support=1"  # Enable experimental hardware support
    "radeon.si_support=0"
    "radeon.cik_support=0"
    
    # eGPU specific optimizations
    "amdgpu.runpm=0"           # Disable runtime power management for eGPU
    "amdgpu.gpu_recovery=1"    # Enable GPU recovery
  ];

  # Systemd service to force eGPU detection at boot
  systemd.services.egpu-force-bind = {
    description = "Force eGPU Driver Binding";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "force-egpu-bind" ''
        #!/bin/bash
        
        # Wait for PCI enumeration to complete
        sleep 5
        
        # Check if eGPU is present
        if [[ -d "/sys/bus/pci/devices/0000:07:00.0" ]]; then
          echo "eGPU detected, attempting to bind driver..."
          
          # Enable the device if not enabled
          echo 1 > /sys/bus/pci/devices/0000:07:00.0/enable 2>/dev/null || true
          
          # Add device ID to amdgpu if not already there
          echo "1002 744c" > /sys/bus/pci/drivers/amdgpu/new_id 2>/dev/null || true
          
          # Set driver override
          echo amdgpu > /sys/bus/pci/devices/0000:07:00.0/driver_override 2>/dev/null || true
          
          # Force binding
          echo "0000:07:00.0" > /sys/bus/pci/drivers/amdgpu/bind 2>/dev/null || true
          
          # Check if successful
          if [[ -L "/sys/bus/pci/devices/0000:07:00.0/driver" ]]; then
            echo "eGPU driver binding successful!"
            # Restart ollama to detect new GPU
            systemctl restart ollama || true
          else
            echo "eGPU driver binding failed"
          fi
        else
          echo "eGPU not detected at 0000:07:00.0"
        fi
      '';
    };
  };
}