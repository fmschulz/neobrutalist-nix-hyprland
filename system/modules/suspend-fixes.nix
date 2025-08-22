# Framework 13 AMD Suspend/Sleep Fixes
# Ensures proper deep sleep and disables problematic wake sources

{ config, lib, pkgs, ... }:

{
  # Udev rules to ensure NVMe power management
  services.udev.extraRules = ''
    # Enable runtime PM for NVMe devices
    ACTION=="add|change", SUBSYSTEM=="nvme", ATTR{power/control}="auto"
    # Enable runtime PM for PCI NVMe controllers
    ACTION=="add|change", SUBSYSTEM=="pci", ATTR{class}=="0x010802", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="pci", DRIVER=="nvme", ATTR{power/control}="auto"
  '';

  # Systemd service to ensure deep sleep mode and disable USB wake
  systemd.services.suspend-fixes = {
    description = "Fix suspend issues on Framework 13 AMD";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" "tlp.service" ];  # Run after TLP
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "suspend-fixes" ''
        # Framework 13 AMD only supports s2idle, optimize it instead
        echo "Framework 13 AMD uses s2idle (modern standby)"
        
        # Enable NVMe power management (critical for s2idle)
        for nvme in /sys/class/nvme/nvme*/power/control; do
          if [ -f "$nvme" ]; then
            echo auto > "$nvme" || true
            echo "Enabled power management for $(basename $(dirname $(dirname $nvme)))"
          fi
        done
        
        # Enable SATA link power management
        for sata in /sys/class/scsi_host/host*/link_power_management_policy; do
          if [ -f "$sata" ]; then
            echo med_power_with_dipm > "$sata" || true
          fi
        done
        
        # Disable USB wake for better battery life during suspend
        # This prevents USB devices from waking the laptop
        for device in /sys/bus/usb/devices/*/power/wakeup; do
          if [ -f "$device" ]; then
            echo disabled > "$device" || true
          fi
        done
        
        # Disable all USB controllers from waking the system
        # This is critical for Framework 13 AMD to prevent phantom wakes
        for device in XHC0 XHC1 XHC2 XHC3 XHC4; do
          if grep -q "^$device.*enabled" /proc/acpi/wakeup; then
            echo "$device" > /proc/acpi/wakeup || true
            echo "Disabled wake for $device"
          fi
        done
        
        # Also disable GPP (PCIe General Purpose Ports) wake sources
        for device in GPP0 GPP2 GPP5 GPP6 GPP7 GP11 GP12; do
          if grep -q "^$device.*enabled" /proc/acpi/wakeup; then
            echo "$device" > /proc/acpi/wakeup || true
            echo "Disabled wake for $device"
          fi
        done
        
        # Keep only NHI0/NHI1 (Thunderbolt) enabled for eGPU hotplug
        # Lid and power button are handled separately by systemd
        
        echo "Suspend fixes applied"
      '';
    };
  };
  
  # Additional power management settings for Framework 13 AMD
  powerManagement = {
    # Enable power management
    enable = true;
    
    # Use schedutil governor for better battery life
    cpuFreqGovernor = "schedutil";
    
    # Disable powertop auto-tune as it conflicts with our manual settings
    powertop.enable = false;
    
    # scsiLinkPolicy handled by TLP instead
    
    # Resume commands to reapply fixes after suspend
    resumeCommands = ''
      # Reapply deep sleep mode after resume
      echo deep > /sys/power/mem_sleep || true
      
      # Disable USB wakeup again
      for device in /sys/bus/usb/devices/*/power/wakeup; do
        if [ -f "$device" ]; then
          echo disabled > "$device" || true
        fi
      done
    '';
  };
  
  # Framework 13 AMD specific TLP settings for better battery life
  services.tlp = {
    enable = lib.mkDefault true;
    settings = lib.mkMerge [
      # Base settings that can be overridden
      {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # Platform profiles
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # AMD GPU power management
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";
      
      # PCIe ASPM
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      
      # Runtime PM - critical for NVMe power management
      RUNTIME_PM_ON_AC = "auto";  # Enable power management even on AC
      RUNTIME_PM_ON_BAT = "auto";
      
      # USB autosuspend
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;  # Don't suspend Bluetooth
      USB_EXCLUDE_PHONE = 1;  # Don't suspend phones
      
      # Disable wake on LAN
      WOL_DISABLE = "Y";
      
      # NVMe power saving
      NVME_LAPTOP_MODE_ON_AC = 0;
      NVME_LAPTOP_MODE_ON_BAT = 1;
      
      # Sound power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      
      # Battery charge thresholds
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      
      # SATA link power management
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "min_power";
      }
    ];
  };
}