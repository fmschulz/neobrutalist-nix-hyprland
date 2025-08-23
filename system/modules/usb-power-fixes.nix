# USB Controller and Power Management Fixes for Framework 13 AMD
# Addresses xhci_hcd errors and USB power state issues after sleep

{ config, lib, pkgs, ... }:

{
  # Kernel parameters to fix USB controller issues
  boot.kernelParams = [
    # USB controller fixes
    "usbcore.autosuspend=-1"  # Disable USB autosuspend to prevent controller failures
    "xhci_hcd.quirks=0x80"    # Apply quirks for better USB3 compatibility
    
    # AMD-specific USB fixes
    "amd_pstate=active"        # Use active AMD P-state driver
    "iommu=soft"              # Use software IOMMU for better USB compatibility
  ];
  
  # Blacklist problematic USB modules if needed
  boot.blacklistedKernelModules = [
    # "cros_ec_lpcs"  # Can cause USB controller issues on some systems
  ];
  
  # Systemd service to reset USB controllers after resume
  systemd.services.usb-reset-on-resume = {
    description = "Reset USB controllers after resume to fix power state issues";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "usb-reset" ''
        #!/usr/bin/env bash
        
        # Wait for system to stabilize
        sleep 2
        
        # Reset USB controllers by unbinding and rebinding
        for usb in /sys/bus/pci/drivers/xhci_hcd/0000:*; do
          if [ -e "$usb" ]; then
            device=$(basename "$usb")
            echo "Resetting USB controller: $device"
            
            # Unbind
            echo "$device" > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true
            sleep 0.5
            
            # Rebind
            echo "$device" > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null || true
          fi
        done
        
        # Reset USB devices power state
        for device in /sys/bus/usb/devices/*/power/control; do
          if [ -f "$device" ]; then
            echo "on" > "$device" 2>/dev/null || true
          fi
        done
        
        echo "USB controllers reset completed"
      '';
    };
  };
  
  # Service to handle AMD GPU MES errors
  systemd.services.amdgpu-reset-on-resume = {
    description = "Reset AMD GPU state after resume";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "amdgpu-reset" ''
        #!/usr/bin/env bash
        
        # Reset AMD GPU power state
        if [ -f /sys/class/drm/card0/device/power_dpm_force_performance_level ]; then
          echo "auto" > /sys/class/drm/card0/device/power_dpm_force_performance_level 2>/dev/null || true
        fi
        
        # Re-enable gfxoff after resume
        if [ -f /sys/class/drm/card0/device/pp_power_profile_mode ]; then
          echo "0" > /sys/class/drm/card0/device/pp_power_profile_mode 2>/dev/null || true
        fi
        
        echo "AMD GPU state reset completed"
      '';
    };
  };
  
  # Udev rules for USB power management
  services.udev.extraRules = ''
    # Disable autosuspend for all USB devices to prevent controller issues
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/control}="on"
    
    # Specific fix for xHCI controllers that fail after sleep
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="xhci_hcd", ATTR{power/control}="on"
    
    # Prevent USB hubs from suspending
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", ATTR{power/control}="on"
    
    # Framework 13 specific USB-C/Thunderbolt fixes
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{power/control}="on"
  '';
  
  # Boot post-resume script
  powerManagement.resumeCommands = ''
    # Log resume event
    echo "System resumed at $(date)" >> /var/log/resume.log
    
    # Force reload of USB modules if needed
    ${pkgs.kmod}/bin/modprobe -r xhci_pci xhci_hcd 2>/dev/null || true
    ${pkgs.kmod}/bin/modprobe xhci_hcd 2>/dev/null || true
    ${pkgs.kmod}/bin/modprobe xhci_pci 2>/dev/null || true
  '';
}