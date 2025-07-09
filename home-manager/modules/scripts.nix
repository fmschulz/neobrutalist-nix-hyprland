{ config, pkgs, lib, ... }:

{
  # Create welcome script directly
  home.file.".config/scripts/welcome.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Berkeley Framework NixOS Welcome Script
      # Enhanced system info with weather and location
      
      # Colors for neo-brutalist theme
      RED='\033[1;91m'
      GREEN='\033[1;92m'
      YELLOW='\033[1;93m'
      BLUE='\033[1;94m'
      MAGENTA='\033[1;95m'
      CYAN='\033[1;96m'
      WHITE='\033[1;97m'
      ORANGE='\033[1;38;5;208m'
      RESET='\033[0m'
      BOLD='\033[1m'
      
      # Berkeley coordinates
      BERKELEY_LAT="37.8715"
      BERKELEY_LON="-122.2730"
      
      # Clear screen and show welcome
      clear
      
      # WELCOME ASCII art with colors
      echo -e "''${ORANGE}██╗    ██╗''${RESET}''${GREEN}███████╗''${RESET}''${BLUE}██╗     ''${RESET}''${RED}███████╗''${RESET}''${MAGENTA}██████╗''${RESET} ''${ORANGE}███╗   ███╗''${RESET}''${GREEN}███████╗''${RESET}"
      echo -e "''${ORANGE}██║    ██║''${RESET}''${GREEN}██╔════╝''${RESET}''${BLUE}██║     ''${RESET}''${RED}██╔════╝''${RESET}''${MAGENTA}██╔═══██╗''${RESET}''${ORANGE}████╗ ████║''${RESET}''${GREEN}██╔════╝''${RESET}"
      echo -e "''${ORANGE}██║ █╗ ██║''${RESET}''${GREEN}█████╗''${RESET}  ''${BLUE}██║     ''${RESET}''${RED}██║     ''${RESET}''${MAGENTA}██║   ██║''${RESET}''${ORANGE}██╔████╔██║''${RESET}''${GREEN}█████╗''${RESET}  "
      echo -e "''${ORANGE}██║███╗██║''${RESET}''${GREEN}██╔══╝''${RESET}  ''${BLUE}██║     ''${RESET}''${RED}██║     ''${RESET}''${MAGENTA}██║   ██║''${RESET}''${ORANGE}██║╚██╔╝██║''${RESET}''${GREEN}██╔══╝''${RESET}  "
      echo -e "''${ORANGE}╚███╔███╔╝''${RESET}''${GREEN}███████╗''${RESET}''${BLUE}███████╗''${RESET}''${RED}███████╗''${RESET}''${MAGENTA}██████╔╝''${RESET}''${ORANGE}██║ ╚═╝ ██║''${RESET}''${GREEN}███████╗''${RESET}"
      echo -e "''${ORANGE} ╚══╝╚══╝''${RESET} ''${GREEN}╚══════╝''${RESET}''${BLUE}╚══════╝''${RESET}''${RED}╚══════╝''${RESET}''${MAGENTA}╚═════╝''${RESET} ''${ORANGE}╚═╝     ╚═╝''${RESET}''${GREEN}╚══════╝''${RESET}"
      
      echo ""
      
      # Berkeley Status with Weather
      echo -e "''${CYAN}┌─ BERKELEY STATUS ──────────────────────────────┐''${RESET}"
      echo -e "''${CYAN}│''${RESET} 🕐 ''${BOLD}$(date '+%A, %B %d, %Y • %I:%M %p')''${RESET}                     ''${CYAN}│''${RESET}"
      echo -e "''${CYAN}│''${RESET} 🌎 ''${BOLD}$(date '+%Z')''${RESET} • 📍 Berkeley, CA                      ''${CYAN}│''${RESET}"
      
      # Fetch weather in background and display
      WEATHER=$(curl -s "wttr.in/Berkeley,CA?format=%t+%C" 2>/dev/null || echo "Weather unavailable")
      echo -e "''${CYAN}│''${RESET} 🌐 ''${BOLD}''${WEATHER}''${RESET}                                    ''${CYAN}│''${RESET}"
      echo -e "''${CYAN}└────────────────────────────────────────────────┘''${RESET}"
      
      echo ""
      
      # Workspace Layout
      echo -e "''${GREEN}┌─ WORKSPACE LAYOUT ─────────────────────────────┐''${RESET}"
      echo -e "''${GREEN}│''${RESET} 1️⃣ Kitty      2️⃣ Yazi       3️⃣ Firefox        ''${GREEN}│''${RESET}"
      echo -e "''${GREEN}│''${RESET} 4️⃣ VS Code    5️⃣ Chromium   6️⃣ btop           ''${GREEN}│''${RESET}"
      echo -e "''${GREEN}│''${RESET} 7️⃣ Slack      8️⃣ Obsidian   9️⃣ YT Music       ''${GREEN}│''${RESET}"
      echo -e "''${GREEN}└────────────────────────────────────────────────┘''${RESET}"
      
      echo ""
      
      # Run fastfetch for system details
      if command -v fastfetch >/dev/null 2>&1; then
          fastfetch
      else
          echo -e "''${BLUE}┌─ SYSTEM DETAILS ───────────────────────────────┐''${RESET}"
          echo -e "''${BLUE}│''${RESET} 🖥️  $(uname -sr)                              ''${BLUE}│''${RESET}"
          echo -e "''${BLUE}│''${RESET} ⏱️  Uptime: $(uptime -p)                        ''${BLUE}│''${RESET}"
          echo -e "''${BLUE}│''${RESET} 🏠 Host: $(hostname)                           ''${BLUE}│''${RESET}"
          echo -e "''${BLUE}└─────────────────────────────────────────────────┘''${RESET}"
      fi
      
      echo ""
      echo -e "''${CYAN}💡 Tips: ''${BOLD}Super+D''${RESET} launcher • ''${BOLD}Super+1-9''${RESET} workspaces • ''${BOLD}Super+Q''${RESET} close window''${RESET}"
    '';
  };
  
  # Make scripts executable
  home.activation.makeScriptsExecutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    chmod +x $HOME/.config/scripts/*.sh 2>/dev/null || true
  '';
  
  # Add scripts directory to PATH
  home.sessionPath = [
    "$HOME/.config/scripts"
  ];
  
}