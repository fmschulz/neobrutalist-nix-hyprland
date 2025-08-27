{
  description = "Framework 13 AMD NixOS & Home Manager Configuration";

  inputs = {
    # Main nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Unstable for latest packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hardware configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Secrets management (optional)
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland (latest)
    hyprland.url = "github:hyprwm/Hyprland";
    
    # Claude Code (latest with automatic updates)
    claude-code.url = "github:sadjow/claude-code-nix";
    
    # OpenAI Codex CLI
    codex = {
      url = "github:openai/codex";
      flake = false;  # Since we'll build it ourselves
    };
    
    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, agenix, hyprland, claude-code, flake-utils, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Create pkgs with unstable overlay
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          # Add claude-code overlay first (higher priority)
          claude-code.overlays.default
          # Add unstable packages as overlay
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };
      
      # Common special args for all configurations
      specialArgs = {
        inherit inputs;
        unstable = pkgs.unstable;
      };
      
    in {
      # NixOS Configurations
      nixosConfigurations = {
        # Framework 13 AMD configuration
        framework-nixos = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            # Hardware support
            nixos-hardware.nixosModules.framework-13-7040-amd
            
            # Secrets management
            agenix.nixosModules.default
            
            # Host-specific configuration
            ./hosts/framework-nixos/configuration.nix
            
            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.fschulz = import ./hosts/framework-nixos/home.nix;
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };
      };
      
      # Standalone Home Manager configurations  
      homeConfigurations = {
        "fschulz@framework-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = specialArgs;
          modules = [ ./hosts/framework-nixos/home.nix ];
        };
      };
      
      # Development shell for working on configurations
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Nix tools
          nix-tree
          nix-diff
          
          # Development tools
          git
          age
          gnupg
          
          # Formatting
          nixpkgs-fmt
          statix
          deadnix
          
          # Documentation
          mdbook
        ];
        
        shellHook = ''
          echo "🚀 Welcome to NixOS/Home Manager development environment!"
          echo "Available commands:"
          echo "  nixos-rebuild switch --flake .#framework-nixos"
          echo "  home-manager switch --flake .#fschulz@framework-nixos"
          echo "  nix flake update"
          echo "  nix flake check"
        '';
      };
      
      # Templates for creating new hosts (TODO: add templates later)
      # templates = {
      #   host = {
      #     path = ./templates/host;
      #     description = "Template for a new host configuration";
      #   };
      # };
      
      # Packages (custom derivations)
      packages.${system} = {
        # Custom welcome script package (if needed)
        # welcome-script = pkgs.writeShellScriptBin "welcome" ''
        #   ${builtins.readFile ./home-manager/scripts/welcome.sh}
        # '';
        
        # Deployment script
        deploy = pkgs.writeShellScriptBin "deploy" ''
          ${builtins.readFile ./scripts/deploy.sh}
        '';
      };
      
      # Formatter for the flake
      formatter.${system} = pkgs.nixpkgs-fmt;
      
      # Checks (run with `nix flake check`)
      checks.${system} = {
        # Check if configurations build
        nixos-framework = self.nixosConfigurations.framework-nixos.config.system.build.toplevel;
        home-fschulz = self.homeConfigurations."fschulz@framework-nixos".activationPackage;
      };
    };
}