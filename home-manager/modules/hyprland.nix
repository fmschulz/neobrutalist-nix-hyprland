{ config, pkgs, lib, ... }:

{
  # MINIMAL WORKING CONFIG - DO NOT MODIFY WITHOUT TESTING
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration - Framework 13 AMD proper resolution
      monitor = [
        "eDP-1,2880x1920@120,0x0,1.5"
        "DP-1,preferred,auto,1.0"
        "DP-2,preferred,auto,1.0" 
        "HDMI-A-1,preferred,auto,1.0"
        ",preferred,auto,1.0"
      ];
      
      # Programs
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi -c ~/.config/wofi/config -s ~/.config/wofi/style.css";
      
      # Minimal environment variables - SAFE
      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Ice"
      ];
      
      # General settings
      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 3;  # Main border, additional layers from plugin
        "col.active_border" = "rgba(000000ff)";  # Solid black for brutalist style
        "col.inactive_border" = "rgba(000000ff)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      
      # Decoration
      decoration = {
        rounding = 0;  # Neo-brutalist sharp corners
        
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
        
        # Neo-brutalist effect achieved through thick borders and sharp corners
      };
      
      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Master layout
      master = {
        new_status = "master";
      };
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          middle_button_emulation = false;
          clickfinger_behavior = true;
          tap-to-click = true;
          drag_lock = false;
        };
      };
      
      # Gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = false;
      };
      
      # Misc
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
      
      # Variables
      "$mainMod" = "SUPER";
      
      
      # Key bindings
      bind = [
        # Core functionality
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        "$mainMod, F, fullscreen"
        
        # Window sizing shortcuts
        "$mainMod SHIFT, H, resizeactive, -50% 0"    # Reduce width by 50%
        "$mainMod SHIFT, V, resizeactive, 0 -50%"    # Reduce height by 50%
        "$mainMod CTRL, H, resizeactive, 100% 0"     # Double width
        "$mainMod CTRL, V, resizeactive, 0 100%"     # Double height
        "$mainMod SHIFT, C, centerwindow"             # Center floating window
        "$mainMod, R, submap, resize"                 # Enter resize mode
        
        # Application shortcuts
        "$mainMod, Return, exec, $terminal"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, D, exec, $menu"
        
        # Wallpaper cycling (all monitors)
        "$mainMod, W, exec, swww img ~/dotfiles/home-manager/wallpapers/wp0.png --outputs eDP-1,DP-10"
        "$mainMod SHIFT, W, exec, swww img ~/dotfiles/home-manager/wallpapers/wp1.png --outputs eDP-1,DP-10"
        "$mainMod CTRL, W, exec, swww img ~/dotfiles/home-manager/wallpapers/wp2.png --outputs eDP-1,DP-10"
        
        # VS Code theme switching
        "$mainMod, T, exec, ~/.config/scripts/vscode-theme-switch.sh cycle"
        "$mainMod SHIFT, T, exec, ~/.config/scripts/vscode-theme-dark.sh"
        "$mainMod CTRL, T, exec, ~/.config/scripts/vscode-theme-light.sh"
        
        # Clipboard history
        "$mainMod, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        
        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Swap windows (move windows around)
        "$mainMod ALT, left, swapwindow, l"
        "$mainMod ALT, right, swapwindow, r"
        "$mainMod ALT, up, swapwindow, u"
        "$mainMod ALT, down, swapwindow, d"
        
        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Monitor controls
        "$mainMod, period, focusmonitor, +1"     # Focus next monitor
        "$mainMod, comma, focusmonitor, -1"      # Focus previous monitor
        "$mainMod SHIFT, period, movewindow, mon:+1"  # Move window to next monitor
        "$mainMod SHIFT, comma, movewindow, mon:-1"   # Move window to previous monitor
        
        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # Custom workspace navigation
        "$mainMod SHIFT, left, workspace, e-1"
        "$mainMod SHIFT, right, workspace, e+1"
        "$mainMod SHIFT, up, exec, ~/.config/hypr/workspace-overview.sh"
        
        # Window resizing
        "$mainMod CTRL, left, resizeactive, -20 0"
        "$mainMod CTRL, right, resizeactive, 20 0"
        "$mainMod CTRL, up, resizeactive, 0 -20"
        "$mainMod CTRL, down, resizeactive, 0 20"
        
        # Quick actions
        "$mainMod ALT, L, exec, hyprlock"
        "$mainMod ALT, P, exec, wlogout"
        "$mainMod ALT, R, exec, ~/.config/hypr/reload.sh"
        
        # Screenshot bindings
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mainMod, Print, exec, grim - | wl-copy"
        "$mainMod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png"
        
        # Monitor management
        "$mainMod CTRL, M, exec, ~/dotfiles/scripts/monitor-connect.sh"
        "$mainMod CTRL, N, exec, ~/dotfiles/scripts/clear-notifications.sh"
      ];
      
      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Media keys (Framework laptop function keys)
      bindl = [
        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        
        # Brightness controls
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        
        # Media playback controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      
      # Window rules (order matters - more specific rules first)
      windowrulev2 = [
        # Specific kitty instances with title matching
        "workspace 2, class:^(kitty)$,title:.*Yazi.*"
        "workspace 3, class:^(kitty)$,title:.*SSH.*"
        "workspace 7, class:^(kitty)$,title:.*btop.*"
        
        # Browsers - specific workspaces
        "workspace 5, class:^(firefox)$"
        "workspace 5, class:^(Firefox)$"
        "workspace 6, class:^(chromium-browser)$"
        "workspace 6, class:^(chromium)$"
        "workspace 6, class:^(Chromium)$"
        
        # VS Code - no specific workspace rule, let exec-once handle it
        
        # Other applications
        "workspace 9, class:^([Oo]bsidian)$"
        "workspace 10, class:^(YouTube Music)$"
        "workspace 10, class:^(youtube-music-desktop-app)$"
        
        # Generic kitty terminals go to workspace 1 (fallback)
        "workspace 1, class:^(kitty)$"
        
        # General rules
        "suppressevent maximize, class:.*"
      ];
      
      # Startup applications with workspace assignments
      exec-once = [
        # Essential services
        "waybar"
        "mako"
        "hypridle"
        "blueman-applet"
        "nm-applet"
        
        # Clipboard history daemon
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        
        # Wallpaper daemon and set wallpaper (with multi-monitor support)
        "swww-daemon"
        "sleep 3 && swww img ~/dotfiles/home-manager/wallpapers/wp0.png --outputs eDP-1,DP-11"
        
        # Workspace applications (launched silently)
        "[workspace 1 silent] kitty --config NONE -o background=#000000 -o foreground=#FFFFFF"
        "[workspace 1 silent] kitty --config NONE -o background=#000000 -o foreground=#FFFFFF"
        "[workspace 2 silent] kitty --config NONE -o background=#2D2D2D -o foreground=#FFFFFF -o window_padding_width=10 --title 'Yazi' -e yazi"
        "[workspace 3 silent] kitty --config NONE -o background=#2D2D2D -o foreground=#FFFFFF --title 'SSH: jgi-ont' -e ssh jgi-ont"
        "[workspace 3 silent] code"
        "[workspace 4 silent] code --new-window"
        "[workspace 5 silent] firefox --new-window"
        "[workspace 6 silent] chromium --new-window"
        "[workspace 7 silent] kitty --config NONE -o background=#2D2D2D -o foreground=#FFFFFF --title 'btop' -e btop"
        "[workspace 9 silent] obsidian"
        "[workspace 10 silent] youtube-music-desktop-app"
        
        # Set cursor theme for GTK apps
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
      ];
    };
    
    # Additional configuration files
    extraConfig = ''
      # Assign workspaces to external monitor
      workspace = 5, monitor:DP-11
      workspace = 6, monitor:DP-11

      # Resize submap
      submap = resize
      
      # Resize bindings
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      
      # Alternative vim-style resize
      binde = , l, resizeactive, 10 0
      binde = , h, resizeactive, -10 0
      binde = , k, resizeactive, 0 -10
      binde = , j, resizeactive, 0 10
      
      # Exit resize mode
      bind = , escape, submap, reset
      bind = SUPER, R, submap, reset
      
      submap = reset
    '';
  };
  
  
  # Create workspace overview script
  home.file.".config/hypr/workspace-overview.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Workspace overview script
      
      # Get current workspace
      current_workspace=$(hyprctl activewindow | grep workspace | awk '{print $2}')
      
      # Get all workspaces with windows
      workspaces=$(hyprctl workspaces | grep "workspace ID" | awk '{print $3}' | sort -n)
      
      # Create workspace list with titles and app names
      workspace_list=""
      for ws in $workspaces; do
        # Get app classes for this workspace using simpler text parsing
        app_classes=$(hyprctl clients | awk -v ws="$ws" '
          /^Window/ { in_window = 1; current_class = ""; current_ws = "" }
          in_window && /^[[:space:]]*class:/ { current_class = $2 }
          in_window && /^[[:space:]]*workspace:/ { 
            current_ws = $2
            # Handle workspace format like "2 (2)"
            gsub(/\(.*\)/, "", current_ws)
            gsub(/[[:space:]]*/, "", current_ws)
          }
          in_window && /^[[:space:]]*$/ { 
            if (current_ws == ws && current_class != "") {
              print current_class
            }
            in_window = 0
          }
          END {
            # Handle last window if file doesnt end with blank line
            if (in_window && current_ws == ws && current_class != "") {
              print current_class
            }
          }
        ' | sort -u | tr '\n' ', ' | sed 's/,$//')
        
        windows=$(hyprctl clients | grep "workspace: $ws" | wc -l)
        
        if [ $windows -gt 0 ]; then
          if [ $ws -eq $current_workspace ]; then
            workspace_list="$workspace_list$ws (current) - [$app_classes]\n"
          else
            workspace_list="$workspace_list$ws - [$app_classes]\n"
          fi
        fi
      done
      
      # Show workspace selector with wofi
      selected=$(echo -e "$workspace_list" | wofi --dmenu --prompt "Select Workspace" --width 400 --height 300)
      
      if [ -n "$selected" ]; then
        # Extract workspace number
        ws_num=$(echo "$selected" | awk '{print $1}')
        # Switch to selected workspace
        hyprctl dispatch workspace "$ws_num"
      fi
    '';
  };
}