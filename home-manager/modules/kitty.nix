{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    # Font configuration
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 12.0;
    };
    
    settings = {
      # Font variants
      bold_font = "JetBrains Mono Nerd Font Bold";
      italic_font = "JetBrains Mono Nerd Font Italic";
      bold_italic_font = "JetBrains Mono Nerd Font Bold Italic";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;
      
      # Window appearance - Neo-brutalist style
      window_border_width = "5pt";  # Thicker border for brutalist look
      window_margin_width = 0;      # No margin, let Hyprland handle spacing
      window_padding_width = 15;    # Good internal padding
      active_border_color = "#000000";   # Solid black border
      inactive_border_color = "#000000"; # Solid black border
      draw_minimal_borders = false;
      
      # Default Colors - Neo-Brutalist Yellow
      foreground = "#000000";
      background = "#FFBE0B";
      
      # Color palette (will be overridden by themes)
      color0  = "#000000";  # Black
      color8  = "#4D4D4D";
      color1  = "#FF006E";  # Red
      color9  = "#FF4081";
      color2  = "#06FFA5";  # Green
      color10 = "#00E676";
      color3  = "#B8860B";  # Yellow (darker for readability)
      color11 = "#DAA520";
      color4  = "#3185FC";  # Blue
      color12 = "#448AFF";
      color5  = "#B14AFF";  # Magenta
      color13 = "#E040FB";
      color6  = "#00BCD4";  # Cyan
      color14 = "#18FFFF";
      color7  = "#E0E0E0";  # White
      color15 = "#FFFFFF";
      
      # Selection colors
      selection_foreground = "#FFBE0B";
      selection_background = "#000000";
      
      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      active_tab_foreground = "#000000";
      active_tab_background = "#FF006E";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#000000";
      inactive_tab_background = "#FFBE0B";
      inactive_tab_font_style = "normal";
      
      # Other settings
      enable_audio_bell = false;
      visual_bell_duration = 0;
      hide_window_decorations = false;
      confirm_os_window_close = 0;
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Allow remote control for theme switching
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
    };
    
    # Key mappings including theme switching
    keybindings = {
      # Font size
      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+plus" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
      
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Windows
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      
      # Scrolling
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      
      # Theme switching shortcuts (using set-colors)
      "ctrl+alt+1" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Yellow.conf";
      "ctrl+alt+2" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Blue.conf";
      "ctrl+alt+3" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Purple.conf";
      "ctrl+alt+4" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Green.conf";
      "ctrl+alt+5" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Orange.conf";
      "ctrl+alt+6" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Black.conf";
      "ctrl+alt+7" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-DarkGrey.conf";
      "ctrl+alt+8" = "remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-White.conf";
    };
    
    # Shell integration
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = false;
    };
    
    # Custom configuration for themes
    extraConfig = ''
      # Theme switching command aliases using set-colors
      map ctrl+alt+y remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Yellow.conf
      map ctrl+alt+b remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Blue.conf
      map ctrl+alt+p remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Purple.conf
      map ctrl+alt+g remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Green.conf
      map ctrl+alt+o remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Orange.conf
      map ctrl+alt+k remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-Black.conf
      map ctrl+alt+d remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-DarkGrey.conf
      map ctrl+alt+w remote_control set-colors --all ~/.config/kitty/themes/Neo-Brutalist-White.conf
    '';
  };
  
  # Create custom theme files
  home.file.".config/kitty/themes/Neo-Brutalist-Yellow.conf".text = ''
    # Neo-Brutalist Yellow Theme
    foreground                #000000
    background                #FFBE0B
    selection_foreground      #FFBE0B
    selection_background      #000000
    cursor                    #FF006E
    cursor_text_color         #FFFFFF
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow (darker for readability on yellow bg)
    color3   #B8860B
    color11  #DAA520
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan (changed from turquoise to purple as requested)
    color6   #B14AFF
    color14  #C084FC
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #000000
    active_tab_background     #FF006E
    inactive_tab_foreground   #000000
    inactive_tab_background   #FFBE0B
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-Blue.conf".text = ''
    # Neo-Brutalist Blue Theme (lighter blue background like waybar diskspace)
    foreground                #FFFFFF
    background                #3A86FF
    selection_foreground      #3A86FF
    selection_background      #FFFFFF
    cursor                    #FFFFFF
    cursor_text_color         #3A86FF
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue (accent)
    color4   #60A5FA
    color12  #93C5FD
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #FFFFFF
    active_tab_background     #FF006E
    inactive_tab_foreground   #FFFFFF
    inactive_tab_background   #1E3A8A
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-Purple.conf".text = ''
    # Neo-Brutalist Purple Theme
    foreground                #FFFFFF
    background                #581C87
    selection_foreground      #581C87
    selection_background      #FFFFFF
    cursor                    #FFFFFF
    cursor_text_color         #581C87
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta (accent)
    color5   #C084FC
    color13  #DDD6FE
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #FFFFFF
    active_tab_background     #FF006E
    inactive_tab_foreground   #FFFFFF
    inactive_tab_background   #581C87
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-Green.conf".text = ''
    # Neo-Brutalist Green Theme
    foreground                #000000
    background                #059669
    selection_foreground      #059669
    selection_background      #000000
    cursor                    #000000
    cursor_text_color         #059669
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green (accent)
    color2   #10B981
    color10  #34D399
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #000000
    active_tab_background     #FF006E
    inactive_tab_foreground   #000000
    inactive_tab_background   #059669
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-Orange.conf".text = ''
    # Neo-Brutalist Orange Theme
    foreground                #000000
    background                #FB5607
    selection_foreground      #FB5607
    selection_background      #000000
    cursor                    #000000
    cursor_text_color         #FB5607
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue (font color as requested)
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan (turquoise font color as requested)
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #000000
    active_tab_background     #FF006E
    inactive_tab_foreground   #000000
    inactive_tab_background   #FB5607
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-Black.conf".text = ''
    # Neo-Brutalist Black Theme
    foreground                #FFFFFF
    background                #000000
    selection_foreground      #000000
    selection_background      #FFFFFF
    cursor                    #FFFFFF
    cursor_text_color         #000000
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #FFFFFF
    active_tab_background     #FF006E
    inactive_tab_foreground   #FFFFFF
    inactive_tab_background   #000000
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-DarkGrey.conf".text = ''
    # Neo-Brutalist Dark Grey Theme
    foreground                #FFFFFF
    background                #2D2D2D
    selection_foreground      #2D2D2D
    selection_background      #FFFFFF
    cursor                    #FFFFFF
    cursor_text_color         #2D2D2D
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #FFFFFF
    active_tab_background     #FF006E
    inactive_tab_foreground   #FFFFFF
    inactive_tab_background   #2D2D2D
  '';
  
  home.file.".config/kitty/themes/Neo-Brutalist-White.conf".text = ''
    # Neo-Brutalist White Theme
    foreground                #000000
    background                #FFFFFF
    selection_foreground      #FFFFFF
    selection_background      #000000
    cursor                    #000000
    cursor_text_color         #FFFFFF
    
    # Black
    color0   #000000
    color8   #4D4D4D
    
    # Red
    color1   #FF006E
    color9   #FF4081
    
    # Green
    color2   #06FFA5
    color10  #00E676
    
    # Yellow
    color3   #FFBE0B
    color11  #FFC400
    
    # Blue
    color4   #3185FC
    color12  #448AFF
    
    # Magenta
    color5   #B14AFF
    color13  #E040FB
    
    # Cyan
    color6   #00BCD4
    color14  #18FFFF
    
    # White
    color7   #E0E0E0
    color15  #FFFFFF
    
    # Tab bar
    active_tab_foreground     #000000
    active_tab_background     #FF006E
    inactive_tab_foreground   #000000
    inactive_tab_background   #FFFFFF
  '';
}