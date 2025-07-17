{ config, pkgs, lib, inputs, ... }:

{
  # Create stable binary path to prevent macOS permission resets
  # This also helps on Linux for consistent PATH usage
  home.activation.claudeStableLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.local/bin
    rm -f $HOME/.local/bin/claude
    ln -sf ${inputs.claude-code.packages.${pkgs.system}.claude-code}/bin/claude $HOME/.local/bin/claude
    echo "Created claude symlink: $HOME/.local/bin/claude -> ${inputs.claude-code.packages.${pkgs.system}.claude-code}/bin/claude"
  '';

  # Add to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
  
  # Preserve config during home-manager switches
  home.activation.preserveClaudeConfig = lib.hm.dag.entryBefore ["writeBoundary"] ''
    if [ -f "$HOME/.claude.json" ]; then
      cp -p "$HOME/.claude.json" "$HOME/.claude.json.backup" || true
    fi
    if [ -d "$HOME/.claude" ]; then
      cp -rp "$HOME/.claude" "$HOME/.claude.backup" || true
    fi
  '';
  
  home.activation.restoreClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/.claude.json.backup" ] && [ ! -f "$HOME/.claude.json" ]; then
      cp -p "$HOME/.claude.json.backup" "$HOME/.claude.json" || true
    fi
    if [ -d "$HOME/.claude.backup" ] && [ ! -d "$HOME/.claude" ]; then
      cp -rp "$HOME/.claude.backup" "$HOME/.claude" || true
    fi
    # Clean up backups
    rm -f "$HOME/.claude.json.backup" || true
    rm -rf "$HOME/.claude.backup" || true
  '';

  # Add shell alias for convenience - use the specific claude-code path
  programs.bash.shellAliases = {
    claude = "${inputs.claude-code.packages.${pkgs.system}.claude-code}/bin/claude";
  };
  
  # Ensure PATH is set properly in bashrc
  programs.bash.profileExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';
}