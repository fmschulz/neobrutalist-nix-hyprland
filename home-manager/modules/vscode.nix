{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    
    # Default profile settings
    profiles.default = {
      userSettings = {
      # Editor settings
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'Hack Nerd Font', 'monospace', monospace";
      "editor.lineNumbers" = "relative";
      "editor.rulers" = [80 120];
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.suggestSelection" = "first";
      
      # Terminal settings
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.fontFamily" = "'Hack Nerd Font'";
      
      # Theme settings
      "workbench.colorTheme" = "Tokyo Night Storm";
      "workbench.iconTheme" = "material-icon-theme";
      
      # Window settings
      "window.titleBarStyle" = "custom";
      "window.menuBarVisibility" = "toggle";
      
      # File settings
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      
      # Git settings
      "git.autofetch" = true;
      "git.confirmSync" = false;
      
      # Telemetry
      "telemetry.telemetryLevel" = "off";
      
      # Updates
      "update.mode" = "none";
      
      # Nix LSP
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      };
      
      # Extensions
      extensions = with pkgs.vscode-extensions; [
      # Theme extensions
      enkia.tokyo-night
      zhuangtongfa.material-theme
      dracula-theme.theme-dracula
      github.github-vscode-theme
      
      # Language support
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      golang.go
      ms-python.python
      ms-vscode.cpptools
      
      # Utilities
      eamodio.gitlens
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      
      # Icons
      pkief.material-icon-theme
      ];
    };
  };
  
  # Create theme switching scripts
  home.file.".config/scripts/vscode-theme-switch.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      # VS Code theme switcher script
      # Usage: vscode-theme-switch.sh <theme-name>
      
      VSCODE_CONFIG="$HOME/.config/Code/User/settings.json"
      
      # Available themes
      declare -A THEMES=(
        ["dark"]="Tokyo Night Storm"
        ["light"]="GitHub Light Default"
        ["dracula"]="Dracula"
        ["material"]="Material Theme Darker"
        ["github-dark"]="GitHub Dark Default"
        ["tokyo-night"]="Tokyo Night"
        ["tokyo-storm"]="Tokyo Night Storm"
        ["tokyo-light"]="Tokyo Night Light"
      )
      
      # Function to switch theme
      switch_theme() {
        local theme_key="$1"
        local theme_name="''${THEMES[$theme_key]}"
        
        if [[ -z "$theme_name" ]]; then
          echo "Unknown theme: $theme_key"
          echo "Available themes: ''${!THEMES[@]}"
          exit 1
        fi
        
        # Update VS Code settings
        if command -v jq >/dev/null 2>&1; then
          if [[ -f "$VSCODE_CONFIG" ]]; then
            jq --arg theme "$theme_name" '.["workbench.colorTheme"] = $theme' "$VSCODE_CONFIG" > "$VSCODE_CONFIG.tmp" && mv "$VSCODE_CONFIG.tmp" "$VSCODE_CONFIG"
            echo "Switched VS Code theme to: $theme_name"
          else
            echo "VS Code config not found at $VSCODE_CONFIG"
            exit 1
          fi
        else
          echo "jq is required but not installed"
          exit 1
        fi
      }
      
      # Cycle through themes
      cycle_theme() {
        current_theme=$(jq -r '.["workbench.colorTheme"]' "$VSCODE_CONFIG" 2>/dev/null || echo "Tokyo Night Storm")
        
        # Define cycle order
        local cycle=("Tokyo Night Storm" "GitHub Light Default" "Dracula" "Material Theme Darker" "GitHub Dark Default")
        local next_index=0
        
        # Find current theme index
        for i in "''${!cycle[@]}"; do
          if [[ "''${cycle[$i]}" == "$current_theme" ]]; then
            next_index=$(( (i + 1) % ''${#cycle[@]} ))
            break
          fi
        done
        
        # Switch to next theme
        local next_theme="''${cycle[$next_index]}"
        jq --arg theme "$next_theme" '.["workbench.colorTheme"] = $theme' "$VSCODE_CONFIG" > "$VSCODE_CONFIG.tmp" && mv "$VSCODE_CONFIG.tmp" "$VSCODE_CONFIG"
        
        # Send notification
        notify-send "VS Code Theme" "Switched to $next_theme" -t 2000
      }
      
      # Main logic
      case "$1" in
        "cycle")
          cycle_theme
          ;;
        "")
          echo "Usage: $0 <theme-key|cycle>"
          echo "Available themes: ''${!THEMES[@]}"
          ;;
        *)
          switch_theme "$1"
          ;;
      esac
    '';
  };
  
  # Create quick theme preset scripts
  home.file.".config/scripts/vscode-theme-dark.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ~/.config/scripts/vscode-theme-switch.sh dark
    '';
  };
  
  home.file.".config/scripts/vscode-theme-light.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ~/.config/scripts/vscode-theme-switch.sh light
    '';
  };
}