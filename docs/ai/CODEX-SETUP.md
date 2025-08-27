# OpenAI Codex CLI Setup Guide

## Overview
OpenAI Codex CLI is a lightweight coding agent that runs in your terminal, helping you build features faster, squash bugs, and understand unfamiliar code. It runs entirely locally - your code never leaves your machine.

## Installation Status: ✅ Complete

The Codex CLI has been successfully integrated into your NixOS configuration.

### Configuration File
- **Module**: `home-manager/modules/codex.nix`
- **Import**: Already added to `hosts/framework-nixos/home.nix`
- **Flake Input**: Configured in `flake.nix`

## How It Works

The installation provides three helper commands:

### 1. `codex-install`
Automatically:
- Clones the Codex repository from GitHub
- Installs Node.js dependencies
- Downloads the Rust binary (v0.24.0)
- Sets up the CLI in `~/.local/share/codex-cli/`

### 2. `codex` (or `cx`)
The main command that:
- Checks if Codex is installed
- Runs the CLI using Node.js wrapper
- Passes all arguments to the Rust binary

### 3. `codex-setup` (deprecated)
Previously used for API key configuration. No longer needed as Codex now uses ChatGPT authentication.

## Quick Start

### Step 1: Rebuild Your System
```bash
cd ~/dotfiles
./rebuild.sh home
```

### Step 2: Install Codex (if not already done)
```bash
codex-install
```
This downloads and sets up the Codex CLI with the Rust binary.

### Step 3: Authenticate
```bash
codex login
```
This opens a browser for ChatGPT authentication. Requires:
- ChatGPT Plus, Pro, or Team account
- Active subscription for model access

### Step 4: Start Using Codex
```bash
# Interactive mode
codex

# Short alias
cx

# Direct commands
codex "explain this code"
codex exec "write a Python script that..."
```

## Available Commands

| Command | Description |
|---------|-------------|
| `codex` | Start interactive AI coding session |
| `codex exec` | Run commands non-interactively |
| `codex login` | Authenticate with ChatGPT account |
| `codex logout` | Remove authentication credentials |
| `codex mcp` | Experimental MCP server mode |
| `codex proto` | Protocol stream via stdin/stdout |
| `codex debug` | Internal debugging commands |

## File Locations

- **Installation**: `~/.local/share/codex-cli/`
- **Binary**: `~/.local/share/codex-cli/codex-cli/bin/codex-x86_64-unknown-linux-musl`
- **Config**: `~/.config/codex/` (for any local settings)

## Features

✅ **Local execution** - Your code never leaves your machine  
✅ **Latest models** - Access to GPT-4o and newer models  
✅ **ChatGPT integration** - No API key needed, uses ChatGPT auth  
✅ **Shell aliases** - `cx` for quick access  
✅ **NixOS integration** - Fully declarative configuration  

## Troubleshooting

### "Codex CLI is not installed"
Run `codex-install` to download and set up the CLI.

### Authentication Issues
1. Ensure you have a ChatGPT Plus/Pro/Team account
2. Run `codex logout` then `codex login` again
3. Check your browser allows popups for authentication

### Binary Not Found
The installer automatically downloads the correct binary. If missing:
```bash
cd ~/.local/share/codex-cli/codex-cli/bin
curl -L https://github.com/openai/codex/releases/download/rust-v0.24.0/codex-x86_64-unknown-linux-musl.tar.gz | tar xz
```

### Rebuild After Changes
Always rebuild after modifying the configuration:
```bash
cd ~/dotfiles
./rebuild.sh home
```

## Updates

The Codex flake input in `flake.nix` points to the main branch. To update:
```bash
cd ~/dotfiles
nix flake update codex
./rebuild.sh
```

## Security Notes

- Authentication tokens are stored securely by the Codex CLI
- No API keys are needed (uses ChatGPT OAuth)
- Your code remains local unless you explicitly share it
- The CLI respects your privacy and security settings

## Additional Resources

- [GitHub Repository](https://github.com/openai/codex)
- [Official Documentation](https://help.openai.com/en/articles/11096431-openai-codex-cli-getting-started)
- [Changelog](https://help.openai.com/en/articles/11428266-codex-changelog)