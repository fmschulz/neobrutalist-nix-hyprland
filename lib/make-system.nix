# Helper function to create a NixOS system configuration with user settings
{ nixpkgs, nixos-hardware, agenix, home-manager, specialArgs }:

{ hostname, userConfig, hostConfig }:

nixpkgs.lib.nixosSystem {
  inherit (hostConfig) system;
  inherit specialArgs;
  
  modules = [
    # Hardware support (if specified)
    (if hostConfig ? hardwareModule then hostConfig.hardwareModule else {})
    
    # Secrets management
    agenix.nixosModules.default
    
    # Host-specific configuration
    hostConfig.configPath
    
    # Pass user config to the system
    {
      _module.args = {
        inherit userConfig;
      };
    }
    
    # Home Manager integration
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.${userConfig.username} = import hostConfig.homePath;
        extraSpecialArgs = specialArgs // { inherit userConfig; };
      };
    }
  ];
}