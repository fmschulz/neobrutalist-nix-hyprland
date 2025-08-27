# Simple Codex CLI installation using npm
{ config, lib, pkgs, ... }:

{
  # Install Codex CLI via npm globally in user environment
  home.packages = with pkgs; [
    # Node.js and npm
    nodejs_22
    
    # Codex CLI package from npm
    (pkgs.buildNpmPackage rec {
      pname = "openai-codex";
      version = "0.1.2505172129";  # Latest version as of search results
      
      src = pkgs.fetchFromGitHub {
        owner = "openai";
        repo = "codex";
        rev = "main";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Will be replaced
      };
      
      npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Will be replaced
      
      installPhase = ''
        mkdir -p $out/bin
        cp -r codex-cli/* $out/
        ln -s $out/bin/cli.js $out/bin/codex
        chmod +x $out/bin/codex
      '';
      
      meta = {
        description = "OpenAI Codex CLI";
        homepage = "https://github.com/openai/codex";
      };
    })
  ];
  
  # Alternative: Install via npm directly
  home.activation.installCodex = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Install Codex CLI globally for the user
    if ! command -v codex &> /dev/null; then
      $DRY_RUN_CMD npm install -g @openai/codex || true
    fi
  '';
  
  # Create config directory and initial setup
  home.file.".config/codex/.keep".text = "";
  
  # Environment variables
  home.sessionVariables = {
    CODEX_CONFIG_HOME = "$HOME/.config/codex";
  };
  
  # Shell aliases
  programs.bash.shellAliases = {
    cx = "codex";
    cxchat = "codex chat";
    cxrun = "codex run";
    cxfix = "codex fix";
  };
}