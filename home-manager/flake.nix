{
  description = "Framework 13 AMD NixOS with Home Manager - TEST";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    # NixOS configuration with home-manager as a module
    nixosConfigurations.framework-nixos-hm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your existing NixOS configuration
        ../nixos/system/configuration.nix
        ../nixos/hardware/hardware-configuration.nix
        
        # Add home-manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fschulz = import ./home.nix;
          
          # Pass unstable packages to home-manager
          home-manager.extraSpecialArgs = { 
            inherit inputs;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        }
      ];
    };
    
    # Standalone home-manager configuration (for testing without rebuilding NixOS)
    homeConfigurations."fschulz@framework" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { 
        inherit inputs;
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [ ./home.nix ];
    };
  };
}