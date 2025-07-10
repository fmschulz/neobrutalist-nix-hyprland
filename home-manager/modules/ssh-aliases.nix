# Dynamic SSH aliases module
{ config, lib, pkgs, userConfig, ... }:

let
  # Create SSH aliases with TERM compatibility
  mkSshAlias = name: target: 
    "TERM=xterm-256color ssh ${target}";
    
  # Generate aliases from userConfig if available
  sshAliases = if userConfig ? sshAliases then
    lib.mapAttrs mkSshAlias userConfig.sshAliases
  else {};
in
{
  # Add SSH aliases to bash
  programs.bash.shellAliases = sshAliases;
}