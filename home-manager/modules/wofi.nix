{ config, pkgs, lib, ... }:

{
  programs.wofi = {
    enable = true;
    
    settings = {
      # Window settings
      width = "30%";
      height = "40%";
      location = "center";
      show = "drun";
      prompt = "🚀 Launch";
      
      # Search and filtering
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      
      # Behavior
      insensitive = true;
      allow_images = true;
      image_size = 24;
      hide_scroll = true;
      
      # Appearance
      gtk_dark = true;
      layer = "overlay";
      normal_window = false;
      
      # Terminal
      term = "kitty";
      
      # Matching
      matching = "fuzzy";
      
      # Sort order
      sort_order = "alphabetical";
    };
    
    # Neo-brutalist style
    style = ''
      /* Neo-brutalist Wofi Theme */
      
      * {
        font-family: "JetBrains Mono Nerd Font", monospace;
        font-size: 14px;
        font-weight: bold;
      }
      
      window {
        background-color: #FFBE0B;
        border: 4px solid #000000;
        border-radius: 0px;
        box-shadow: 6px 6px 0px #000000;
      }
      
      #input {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 10px;
        margin: 10px;
        font-size: 16px;
      }
      
      #input:focus {
        border-color: #FF006E;
        outline: none;
      }
      
      #inner-box {
        background-color: #FFBE0B;
        padding: 10px;
      }
      
      #outer-box {
        background-color: #FFBE0B;
        border: none;
      }
      
      #scroll {
        margin: 0px;
        padding: 0px;
        border: none;
      }
      
      #entry {
        background-color: #FFBE0B;
        padding: 10px;
        margin: 2px 10px;
        border: 3px solid transparent;
      }
      
      #entry:selected {
        background-color: #FF006E;
        color: #FFFFFF;
        border: 3px solid #000000;
        font-weight: bold;
      }
      
      #entry:selected * {
        color: #FFFFFF;
      }
      
      #text {
        color: #000000;
        font-weight: bold;
      }
      
      #entry:selected #text {
        color: #FFFFFF;
      }
      
      /* Scrollbar styling */
      scrollbar {
        width: 0px;
      }
    '';
  };
  
  # Note: Wofi config is managed by programs.wofi above
  # No need to copy files manually - home-manager handles this
}