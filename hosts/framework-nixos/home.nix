# Framework 13 AMD Home-Manager Configuration
# Host-specific user environment for framework-nixos

{ config, pkgs, lib, inputs, unstable, ... }:

let
  # Import user-specific settings
  userConfig = import ./user.nix;
in
{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";
  home.stateVersion = "24.11";
  
  # Host identification for home-manager
  targets.genericLinux.enable = false; # We're on NixOS
  
  # Host-specific settings
  home.sessionVariables = {
    # Framework-specific
    HOSTNAME = "framework-nixos";
    LOCATION = "Berkeley, CA";
    
    # Hardware-aware settings
    CPU_CORES = "16";
    GPU_TYPE = "AMD_INTEGRATED";
    DISPLAY_SCALE = "1.5";
  };
  
  # Import common modules
  imports = [
    ../../home-manager/modules/packages.nix
    ../../home-manager/modules/hyprland.nix
    ../../home-manager/modules/hyprland-egpu.nix
    ../../home-manager/modules/ai-tools.nix
    ../../home-manager/modules/kitty.nix
    ../../home-manager/modules/yazi.nix
    ../../home-manager/modules/fastfetch.nix
    ../../home-manager/modules/gtk.nix
    ../../home-manager/modules/qt.nix
    ../../home-manager/modules/dolphin.nix
    ../../home-manager/modules/scripts.nix
    ../../home-manager/modules/waybar.nix
    ../../home-manager/modules/wofi.nix
    ../../home-manager/modules/mako.nix
    ../../home-manager/modules/hypridle.nix
    ../../home-manager/modules/hyprlock.nix
    ../../home-manager/modules/starship.nix
    ../../home-manager/modules/ssh-aliases.nix
    ../../home-manager/modules/firefox.nix
    ../../home-manager/modules/vscode.nix
  ];
  
  # Host-specific git configuration
  programs.git = {
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "code --wait";
      push.autoSetupRemote = true;
      
      # GitHub CLI authentication
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
      
      # Framework-specific settings
      user.signingkey = ""; # TODO: Add GPG key
      commit.gpgsign = false; # TODO: Enable after adding key
    };
  };
  
  # Host-specific programs
  programs.bash.shellAliases = {
    # Host-specific aliases
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#framework-nixos";
    rebuild-home = "home-manager switch --flake ~/dotfiles#${userConfig.username}@framework-nixos";
    update-flake = "cd ~/dotfiles && nix flake update";
    
    # Berkeley weather shortcut
    weather = "curl 'wttr.in/Berkeley,CA?format=3'";
    
    # Framework-specific
    battery = "acpi -b";
    temp = "sensors | grep Tctl";
    framework-tool = "sudo framework_tool";
  };
  
  # Host-specific services
  # (syncthing removed)
  
  # Host-specific file associations for Framework
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
    };
  };
  
  # Host-specific directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
    publicShare = "$HOME/Public";
    
    # Framework-specific
    extraConfig = {
      XDG_PROJECTS_DIR = "$HOME/Projects";
      XDG_STORAGE_DIR = "/home/storage";
    };
  };
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}