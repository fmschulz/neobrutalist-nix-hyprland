# OpenAI Codex CLI Setup Guide

## Installation Complete! 🎉

I've set up OpenAI Codex CLI for your NixOS system with three different configuration options:

### Files Created:
1. **`home-manager/modules/codex.nix`** - Simple installation with helper scripts
2. **`home-manager/modules/codex-flake.nix`** - Advanced flake-based configuration
3. **`home-manager/modules/codex-simple.nix`** - NPM-based installation

### Configuration Added:
- Updated `flake.nix` to include Codex repository as input
- Added Codex module to your home configuration

## Usage Instructions

### 1. Rebuild Your System
```bash
cd ~/dotfiles
./rebuild.sh home
```

### 2. Install Codex CLI
After rebuild, you'll have these commands available:

```bash
# Install Codex CLI from source
codex-install

# Configure your OpenAI API key
codex-setup

# Use Codex
codex
# or use the alias
cx
```

### 3. Get Your API Key
1. Visit https://platform.openai.com/api-keys
2. Create a new API key
3. Run `codex-setup` and enter your key when prompted

### 4. Available Commands
Once configured, you can use:

```bash
# Basic usage
codex              # Start interactive session
cx                 # Short alias

# Specific commands
codex chat         # Chat with AI
codex run          # Run commands
codex fix          # Fix code issues
codex explain      # Explain code

# Get help
codex --help
```

## Configuration Files

Your Codex configuration is stored in:
- **Config**: `~/.config/codex/config.json`
- **Installation**: `~/.local/share/codex-cli/`

## Features

The setup includes:
- ✅ Node.js 22 for running Codex
- ✅ Automatic installation scripts
- ✅ Secure API key storage (chmod 600)
- ✅ Shell aliases for convenience
- ✅ Environment variables configured
- ✅ Integration with your NixOS flake

## Troubleshooting

If you encounter issues:

1. **Check installation**:
   ```bash
   ls -la ~/.local/share/codex-cli/
   ```

2. **Verify configuration**:
   ```bash
   cat ~/.config/codex/config.json
   ```

3. **Check Node.js**:
   ```bash
   node --version  # Should be v22.x
   ```

4. **Reinstall if needed**:
   ```bash
   rm -rf ~/.local/share/codex-cli
   codex-install
   ```

## API Key Security

Your API key is stored securely with:
- File permissions set to 600 (owner read/write only)
- Stored in your home directory config
- Never committed to git

## Next Steps

1. Run `./rebuild.sh home` to apply the configuration
2. Run `codex-install` to install Codex CLI
3. Run `codex-setup` to configure your API key
4. Start using `codex` or `cx` command!

## Additional Notes

- Codex CLI runs entirely locally - your code never leaves your machine
- You get $5 in API credits with ChatGPT Plus, $50 with Pro
- The CLI supports multiple models including GPT-4o and GPT-5
- For development work, you can also use the flake directly from the Codex repo

Enjoy your new AI coding assistant! 🚀