{ config, pkgs, lib, ... }:

{
  # Hyprlock configuration (screen locker)
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 300;
        no_fade_in = false;
      };
      
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      
      # Neo-brutalist input field
      input-field = [
        {
          size = "300, 60";
          position = "0, -20";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(000000)";
          inner_color = "rgb(FFBE0B)";
          outer_color = "rgb(000000)";
          outline_thickness = 4;
          placeholder_text = "<span foreground='##000000'>Enter Password...</span>";
          shadow_passes = 2;
          capslock_color = "rgb(FF006E)";
          check_color = "rgb(06FFA5)";
          fail_color = "rgb(FF006E)";
          fail_text = "<span foreground='##FFFFFF'>$FAIL <b>($ATTEMPTS)</b></span>";
          fail_transition = 300;
        }
      ];
      
      # Clock
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(255, 190, 11, 1.0)";
          font_size = 80;
          font_family = "JetBrains Mono Nerd Font Bold";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$LAYOUT";
          color = "rgba(255, 190, 11, 1.0)";
          font_size = 20;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
  
  # Alternative: Copy existing hyprlock config if it has custom settings
  # home.file.".config/hypr/hyprlock.conf".source = ../../home/hypr/hyprlock.conf;
}