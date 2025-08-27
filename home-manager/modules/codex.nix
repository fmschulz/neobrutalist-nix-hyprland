# Codex CLI configuration module
{ config, lib, pkgs, ... }:

{
  # Install Codex CLI as a system package
  home.packages = with pkgs; [
    # Node.js for running Codex CLI
    nodejs_22
    
    # Build from source using npm
    (pkgs.writeShellScriptBin "codex-install" ''
      #!/usr/bin/env bash
      set -e
      
      CODEX_DIR="$HOME/.local/share/codex-cli"
      
      echo "Installing OpenAI Codex CLI..."
      
      # Create directory if it doesn't exist
      mkdir -p "$CODEX_DIR"
      
      # Clone or update the repository
      if [ -d "$CODEX_DIR/.git" ]; then
        echo "Updating existing Codex installation..."
        cd "$CODEX_DIR"
        git pull
      else
        echo "Cloning Codex repository..."
        git clone https://github.com/openai/codex.git "$CODEX_DIR"
        cd "$CODEX_DIR"
      fi
      
      # Install dependencies (no build needed)
      cd "$CODEX_DIR/codex-cli"
      npm install
      
      # Download the Rust binary
      echo "Downloading Codex binary..."
      BINARY_URL="https://github.com/openai/codex/releases/download/rust-v0.24.0/codex-x86_64-unknown-linux-musl.tar.gz"
      cd "$CODEX_DIR/codex-cli/bin"
      ${pkgs.curl}/bin/curl -L "$BINARY_URL" | ${pkgs.gnutar}/bin/tar xz
      chmod +x codex-x86_64-unknown-linux-musl
      
      echo "Codex CLI installed successfully!"
      echo ""
      echo "Next steps:"
      echo "1. Run: codex login  (authenticate with ChatGPT Plus/Pro/Team account)"
      echo "2. Start using: codex"
    '')
    
    # Setup script for API configuration
    (pkgs.writeShellScriptBin "codex-setup" ''
      #!/usr/bin/env bash
      
      CONFIG_DIR="$HOME/.config/codex"
      mkdir -p "$CONFIG_DIR"
      
      echo "Setting up OpenAI Codex CLI..."
      echo ""
      echo "You'll need an OpenAI API key to use Codex CLI."
      echo "Get one from: https://platform.openai.com/api-keys"
      echo ""
      
      read -p "Enter your OpenAI API key: " -s API_KEY
      echo ""
      
      # Create config file
      cat > "$CONFIG_DIR/config.json" <<EOF
      {
        "apiKey": "$API_KEY",
        "model": "gpt-4o",
        "temperature": 0.7,
        "maxTokens": 4096
      }
      EOF
      
      chmod 600 "$CONFIG_DIR/config.json"
      
      echo "Configuration saved to $CONFIG_DIR/config.json"
      echo "You can now use 'codex' command!"
    '')
    
    # Wrapper script to run Codex CLI
    (pkgs.writeShellScriptBin "codex" ''
      #!/usr/bin/env bash
      
      CODEX_DIR="$HOME/.local/share/codex-cli"
      BINARY_PATH="$CODEX_DIR/codex-cli/bin/codex-x86_64-unknown-linux-musl"
      NODE_WRAPPER="$CODEX_DIR/codex-cli/bin/codex.js"
      
      # Check if Codex is installed (check for Rust binary)
      if [ ! -f "$BINARY_PATH" ]; then
        echo "Codex CLI is not installed. Run 'codex-install' first."
        exit 1
      fi
      
      # Run Codex CLI using Node wrapper (which calls the Rust binary)
      cd "$CODEX_DIR/codex-cli"
      exec ${pkgs.nodejs_22}/bin/node bin/codex.js "$@"
    '')
  ];
  
  # Environment variables for Codex
  home.sessionVariables = {
    CODEX_CONFIG_DIR = "$HOME/.config/codex";
  };
  
  # Create systemd user service for Codex daemon (optional)
  systemd.user.services.codex-daemon = {
    Unit = {
      Description = "OpenAI Codex CLI Daemon";
      After = [ "network-online.target" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo Codex daemon placeholder'";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    
    Install = {
      WantedBy = [ ];  # Disabled by default, enable if needed
    };
  };
  
  # Shell aliases for convenience
  programs.bash.shellAliases = {
    cx = "codex";
    cxi = "codex-install";
    cxs = "codex-setup";
  };
  
  programs.zsh.shellAliases = {
    cx = "codex";
    cxi = "codex-install";
    cxs = "codex-setup";
  };
}