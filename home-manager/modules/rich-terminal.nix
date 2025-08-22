{ config, pkgs, lib, ... }:

let
  # Create a Python environment with Rich and dependencies
  richPython = pkgs.python3.withPackages (ps: with ps; [
    rich
    psutil
    pygments
  ]);

  # Wrapper scripts that use the correct Python
  richLs = pkgs.writeShellScriptBin "rls" ''
    ${richPython}/bin/python ${config.home.homeDirectory}/dotfiles/home-manager/config/rich-scripts/rich-ls.py "$@"
  '';

  richCat = pkgs.writeShellScriptBin "rcat" ''
    ${richPython}/bin/python ${config.home.homeDirectory}/dotfiles/home-manager/config/rich-scripts/rich-cat.py "$@"
  '';

  richStatus = pkgs.writeShellScriptBin "rstatus" ''
    ${richPython}/bin/python ${config.home.homeDirectory}/dotfiles/home-manager/config/rich-scripts/rich-status.py "$@"
  '';

in
{
  # Install the wrapper scripts
  home.packages = [
    richLs
    richCat
    richStatus
  ];

  # Remove the aliases since we now have proper commands
  programs.bash.shellAliases = {
    rsys = "rstatus";  # Keep the short alias
  };
}