# Advanced Codex CLI configuration using flake input
{ config, lib, pkgs, inputs, ... }:

let
  # Build Codex CLI from source
  codex-cli = pkgs.stdenv.mkDerivation rec {
    pname = "codex-cli";
    version = "latest";
    
    src = pkgs.fetchFromGitHub {
      owner = "openai";
      repo = "codex";
      rev = "main";  # Or specify a commit/tag
      sha256 = lib.fakeSha256;  # Replace with actual hash after first build
    };
    
    nativeBuildInputs = with pkgs; [
      nodejs_22
      nodePackages.npm
      git
    ];
    
    buildPhase = ''
      cd codex-cli
      npm install
      npm run build
    '';
    
    installPhase = ''
      mkdir -p $out/bin $out/lib/codex-cli
      cp -r . $out/lib/codex-cli
      
      # Create wrapper script
      cat > $out/bin/codex <<EOF
      #!/usr/bin/env bash
      export NODE_PATH=$out/lib/codex-cli/node_modules
      exec ${pkgs.nodejs_22}/bin/node $out/lib/codex-cli/bin/cli.js "\$@"
      EOF
      chmod +x $out/bin/codex
    '';
    
    meta = with lib; {
      description = "OpenAI Codex CLI - AI coding assistant for your terminal";
      homepage = "https://github.com/openai/codex";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.all;
    };
  };
in
{
  # Option to enable Codex CLI
  options.programs.codex = {
    enable = lib.mkEnableOption "OpenAI Codex CLI";
    
    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "OpenAI API key for Codex CLI";
    };
    
    model = lib.mkOption {
      type = lib.types.str;
      default = "gpt-4o";
      description = "Default model to use";
    };
    
    temperature = lib.mkOption {
      type = lib.types.float;
      default = 0.7;
      description = "Temperature for model responses";
    };
  };
  
  config = lib.mkIf config.programs.codex.enable {
    # Install the package
    home.packages = [ codex-cli ];
    
    # Create configuration file
    xdg.configFile."codex/config.json" = lib.mkIf (config.programs.codex.apiKey != null) {
      text = builtins.toJSON {
        apiKey = config.programs.codex.apiKey;
        model = config.programs.codex.model;
        temperature = config.programs.codex.temperature;
        maxTokens = 4096;
      };
      onChange = ''
        chmod 600 $HOME/.config/codex/config.json
      '';
    };
    
    # Set environment variables
    home.sessionVariables = {
      OPENAI_API_KEY = lib.mkIf (config.programs.codex.apiKey != null) config.programs.codex.apiKey;
      CODEX_MODEL = config.programs.codex.model;
    };
    
    # Shell integration
    programs.bash.initExtra = ''
      # Codex CLI shell integration
      if command -v codex &> /dev/null; then
        alias cx='codex'
        alias cxh='codex --help'
        alias cxv='codex --version'
      fi
    '';
    
    programs.zsh.initExtra = ''
      # Codex CLI shell integration
      if command -v codex &> /dev/null; then
        alias cx='codex'
        alias cxh='codex --help'
        alias cxv='codex --version'
      fi
    '';
  };
}