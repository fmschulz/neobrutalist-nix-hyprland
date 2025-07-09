{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "fschulz";
  home.homeDirectory = "/home/fschulz";

  # This value determines the Home Manager release that your configuration is
  # compatible with. Don't change it unless you know what you're doing.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Note: Main packages are now in modules/packages.nix
  # Only small additions or overrides go here
  home.packages = with pkgs; [
    # Additional packages not in modules/packages.nix
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";  # Update this
    userEmail = "your.email@example.com";  # Update this
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nano";  # or your preferred editor
    };
  };

  # Bash configuration - minimal, let custom bashrc handle integrations
  programs.bash = {
    enable = true;
    enableCompletion = false;
    historySize = 10000;
    historyFileSize = 100000;
    historyControl = [ "ignoredups" "erasedups" ];
    shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    initExtra = ''
      # Load custom bashrc configuration
      if [ -f ~/dotfiles/home-manager/config/bashrc ]; then
        source ~/dotfiles/home-manager/config/bashrc
      fi
    '';
  };
  
  # Disable individual program integrations to avoid clutter in bashrc
  programs.zoxide.enable = lib.mkForce false;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    
    # Cursor settings
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  # XDG configuration
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Import other modules
  imports = [
    ./modules/packages.nix    # All user packages
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/yazi.nix
    ./modules/fastfetch.nix
    ./modules/gtk.nix
    ./modules/qt.nix
    ./modules/scripts.nix
    ./modules/waybar.nix
    ./modules/wofi.nix
    ./modules/mako.nix       # Notification daemon
    ./modules/hypridle.nix   # Idle management
    ./modules/hyprlock.nix   # Screen locker
    ./modules/starship.nix   # Shell prompt
  ];
}