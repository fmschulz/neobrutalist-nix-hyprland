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
    # Monitor hotplug support - detect display connection/disconnection
    ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", RUN+="${pkgs.systemd}/bin/systemctl --user start monitor-hotplug.service"
    
    # Framework 13 lid switch detection with proper event handling
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="Lid Switch", TAG+="power-switch"
    
    # Force display wake on any input device activity when displays are off
    ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", RUN+="${pkgs.bash}/bin/bash -c 'hyprctl dispatch dpms on 2>/dev/null || true'"
    
    # Fix touchpad after dock/undock events
    ACTION=="add|change", SUBSYSTEM=="input", ATTRS{name}=="*[Tt]ouchpad*", RUN+="${pkgs.bash}/bin/bash -c 'sleep 1 && hyprctl keyword input:touchpad:clickfinger_behavior 1 && hyprctl keyword input:touchpad:tap-to-click 1'"
  '';
  
  # Create systemd user services for display management
  systemd.user.services.monitor-hotplug = {
    description = "Handle monitor hotplug events and prevent black screen";
    wantedBy = [ ];  # Not auto-started, triggered by udev
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 1 && /home/fschulz/dotfiles/home-manager/scripts/clamshell-mode.sh dock-change && /home/fschulz/dotfiles/scripts/fix-touchpad.sh'";
      Environment = [
        "PATH=${pkgs.hyprland}/bin:${pkgs.coreutils}/bin:$PATH"
        "HYPRLAND_INSTANCE_SIGNATURE=%i"
      ];
    };
  };
  
  # Service to handle lid events properly
  systemd.user.services.lid-handler = {
    description = "Handle laptop lid open/close events";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "lid-monitor" ''
        #!/usr/bin/env bash
        export PATH=${pkgs.hyprland}/bin:${pkgs.coreutils}/bin:$PATH
        
        # Monitor lid state
        while true; do
          if [ -f /proc/acpi/button/lid/LID0/state ]; then
            LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')
            
            # Track state changes
            if [ "$LID_STATE" != "$LAST_STATE" ]; then
              echo "Lid state changed to: $LID_STATE"
              
              if [ "$LID_STATE" = "closed" ]; then
                /home/fschulz/dotfiles/home-manager/scripts/clamshell-mode.sh close
              else
                /home/fschulz/dotfiles/home-manager/scripts/clamshell-mode.sh open
              fi
              
              LAST_STATE="$LID_STATE"
            fi
          fi
          
          sleep 1
        done
      ''}";
      Restart = "always";
      RestartSec = 3;
    };
  };
  
  # Service to ensure display recovery on resume
  systemd.user.services.display-recovery = {
    description = "Recover display after suspend/resume";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 2 && /home/fschulz/dotfiles/home-manager/scripts/clamshell-mode.sh recover'";
      Environment = "PATH=${pkgs.hyprland}/bin:$PATH";
    };
  };
}