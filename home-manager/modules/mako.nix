{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    
    # All settings go in the settings attribute now
    settings = {
      # Neo-brutalist notification styling
      background-color = "#FFBE0B";
      text-color = "#000000";
      border-color = "#000000";
      border-size = 4;
      border-radius = 0;
      
      # Font
      font = "JetBrains Mono Nerd Font 12";
      
      # Positioning
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      
      # Size
      width = 400;
      height = 100;
      margin = "16";
      padding = "16";
      
      # Icons
      icons = true;
      max-icon-size = 64;
      
      # Progress bar
      progress-color = "over #FF006E";
    
      # Grouping
      group-by = "app-name";
    };
    
    # Extra configuration for urgency levels
    extraConfig = ''
      [urgency=low]
      background-color=#FFBE0B
      text-color=#000000
      border-color=#000000
      default-timeout=3000
      
      [urgency=normal]
      background-color=#FFBE0B
      text-color=#000000
      border-color=#000000
      default-timeout=5000
      
      [urgency=high]
      background-color=#FF006E
      text-color=#FFFFFF
      border-color=#000000
      default-timeout=10000
      
      [category=discord]
      background-color=#5865F2
      text-color=#FFFFFF
      border-color=#000000
      
      [category=slack]
      background-color=#4A154B
      text-color=#FFFFFF
      border-color=#000000
      
      [app-name=Spotify]
      background-color=#1DB954
      text-color=#FFFFFF
      border-color=#000000
      default-timeout=3000
    '';
  };
}