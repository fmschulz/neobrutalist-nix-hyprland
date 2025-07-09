{ config, pkgs, lib, ... }:

{
  # Hypridle configuration
  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # Avoid starting multiple hyprlock instances
        before_sleep_cmd = "loginctl lock-session";    # Lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on";  # Turn on screen after resume
      };
      
      listener = [
        {
          timeout = 300;  # 5 minutes
          on-timeout = "brightnessctl -s set 10";        # Dim screen
          on-resume = "brightnessctl -r";                # Restore brightness
        }
        {
          timeout = 600;  # 10 minutes
          on-timeout = "loginctl lock-session";          # Lock screen
        }
        {
          timeout = 1800; # 30 minutes
          on-timeout = "hyprctl dispatch dpms off";      # Turn off screen
          on-resume = "hyprctl dispatch dpms on";        # Turn on screen
        }
        {
          timeout = 3600; # 1 hour
          on-timeout = "systemctl suspend";             # Suspend system
        }
      ];
    };
  };
  
  # Alternative: Copy existing hypridle config if it has custom settings
  # home.file.".config/hypr/hypridle.conf".source = ../../home/hypr/hypridle.conf;
}