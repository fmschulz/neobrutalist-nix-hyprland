{ config, lib, pkgs, ... }:

{
  # Configure systemd-logind for clamshell mode
  services.logind = {
    lidSwitch = lib.mkForce "ignore";           # Don't suspend on lid close
    lidSwitchExternalPower = lib.mkForce "ignore"; # Don't suspend even when on AC
    lidSwitchDocked = lib.mkForce "ignore";     # Don't suspend when docked
    
    # Keep system running when lid is closed
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
      HandlePowerKey=suspend
      HandleSuspendKey=suspend
      HandleHibernateKey=hibernate
      IdleAction=ignore
      IdleActionSec=0
    '';
  };
  
  # Ensure display hotplug works properly
  services.udev.extraRules = ''
    # Monitor hotplug support
    ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.systemd}/bin/systemctl --user start monitor-hotplug.service"
    
    # Framework 13 lid switch detection
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="Lid Switch", TAG+="power-switch"
  '';
  
  # Create a systemd user service for monitor hotplug events (optional)
  systemd.user.services.monitor-hotplug = {
    description = "Handle monitor hotplug events";
    wantedBy = [ ];  # Not auto-started, triggered by udev
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 1 && hyprctl reload'";
    };
  };
}