{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    
    # Style configuration - Neo-Brutalist theme
    style = ''
      /* Neo-Brutalist Waybar Style */
      * {
          font-family: "JetBrains Mono Nerd Font", monospace;
          font-size: 17px;
          font-weight: bold;
      }

      window#waybar {
          background: #FFBE0B;  /* Bright yellow */
          color: #000000;
          border-bottom: 4px solid #000000;
      }

      /* Workspaces */
      #workspaces {
          background: #FFBE0B;
          margin: 6px;
          padding: 0;
      }

      #workspaces button {
          background: #FB5607;  /* Orange */
          color: #000000;
          border: 3px solid #000000;
          border-radius: 0;
          padding: 0 12px;
          margin: 5px;
          box-shadow: 4px 4px 0px #000000;
          transition: all 0.1s ease;
      }

      #workspaces button:hover {
          background: #FF006E;  /* Hot pink */
          box-shadow: 6px 6px 0px #000000;
          margin-bottom: 2px;
          margin-right: 2px;
      }

      #workspaces button.active {
          background: #8338EC;  /* Purple */
          color: #FFFFFF;
          box-shadow: 2px 2px 0px #000000;
      }

      #workspaces button.urgent {
          background: #FF006E;
          animation: blink 0.5s linear infinite alternate;
      }

      /* Modules */
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #backlight {
          background: #3A86FF;  /* Blue */
          color: #FFFFFF;
          border: 3px solid #000000;
          margin: 5px;
          padding: 0 16px;
          box-shadow: 4px 4px 0px #000000;
      }

      #clock {
          background: #06FFA5;  /* Mint green */
          color: #000000;
      }

      #battery {
          background: #FFB700;  /* Amber */
          color: #000000;
      }

      #battery.charging {
          background: #06FFA5;
      }

      #battery.critical:not(.charging) {
          background: #FF006E;
          color: #FFFFFF;
          animation: blink 0.5s linear infinite alternate;
      }

      #network {
          background: #FB5607;
          color: #000000;
      }

      #network.disconnected {
          background: #FF006E;
          color: #FFFFFF;
      }

      #pulseaudio {
          background: #8338EC;
          color: #FFFFFF;
      }

      #pulseaudio.muted {
          background: #000000;
          color: #FFFFFF;
      }

      #tray {
          background: #FFBE0B;
          box-shadow: none;
          border: none;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      /* Animations */
      @keyframes blink {
          to {
              background-color: #FFFFFF;
              color: #000000;
          }
      }

      /* Tooltip */
      tooltip {
          background: #000000;
          color: #FFFFFF;
          border: 3px solid #FF006E;
          border-radius: 0;
          box-shadow: 6px 6px 0px #FF006E;
      }
    '';
    
    # Waybar configuration
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        
        # Module positions
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "temperature" "battery" "network" "pulseaudio" "tray"];
        
        # Hyprland modules
        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{name}";
          format-icons = {
            "1" = "1️⃣";
            "2" = "2️⃣";
            "3" = "3️⃣";
            "4" = "4️⃣";
            "5" = "5️⃣";
            "6" = "6️⃣";
            "7" = "7️⃣";
            "8" = "8️⃣";
            "9" = "9️⃣";
            urgent = "❗";
            focused = "🔵";
            default = "⚪";
          };
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };
        
        "hyprland/window" = {
          format = "👉 {}";
          max-length = 50;
        };
        
        # System modules
        clock = {
          timezone = "America/Los_Angeles";
          format = "🕐 {:%a %b %d  %I:%M %p}";
          format-alt = "📅 {:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        cpu = {
          format = "🧠 {usage}%";
          tooltip = true;
          interval = 2;
        };
        
        memory = {
          format = "💾 {percentage}%";
          format-alt = "💾 {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
          interval = 2;
        };
        
        temperature = {
          critical-threshold = 80;
          format = "🌡️ {temperatureC}°C";
          format-critical = "🔥 {temperatureC}°C";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "⚡ {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["💀" "🪫" "🔋" "🔋" "🔋"];
        };
        
        network = {
          format-wifi = "📶 {signalStrength}%";
          format-ethernet = "🌐 {ipaddr}";
          format-linked = "🌐 (No IP)";
          format-disconnected = "❌ Disconnected";
          format-alt = "📶 {ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}🎧 {volume}%";
          format-bluetooth-muted = "🔇🎧";
          format-muted = "🔇";
          format-icons = {
            headphone = "🎧";
            hands-free = "🎧";
            headset = "🎧";
            phone = "📱";
            portable = "📱";
            car = "🚗";
            default = ["🔈" "🔉" "🔊"];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };
  };
}