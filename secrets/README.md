# Secrets Management

This directory handles sensitive configuration data that shouldn't be stored in git.

## Setup

### Option 1: age-encrypted secrets (recommended)
```bash
# Install age
nix-shell -p age

# Generate key
mkdir -p ~/.config/age
age-keygen -o ~/.config/age/keys.txt

# Get public key for secrets.nix
age-keygen -y ~/.config/age/keys.txt
```

### Option 2: git-crypt (alternative)
```bash
# Install git-crypt
nix-shell -p git-crypt

# Initialize in repo
cd ~/dotfiles
git-crypt init
git-crypt add-gpg-user YOUR_GPG_KEY_ID
```

## Secrets to manage

Create these files (they are gitignored):

- `secrets.nix` - Encrypted with agenix
- `git-config.nix` - Git user info
- `ssh-keys/` - SSH keys
- `gpg-keys/` - GPG keys
- `wifi-passwords.nix` - WiFi credentials
- `api-keys.nix` - API keys for services

## File Templates

### secrets.nix (encrypted with agenix)
```nix
{
  "git-username.age".publicKeys = [ "age1..." ];
  "git-email.age".publicKeys = [ "age1..." ];
  "ssh-key.age".publicKeys = [ "age1..." ];
  "wifi-home.age".publicKeys = [ "age1..." ];
}
```

### git-config.nix (plain text, gitignored)
```nix
{
  userName = "Your Real Name";
  userEmail = "your.real.email@example.com";
  signingKey = "your-gpg-key-id";
}
```

## Usage in configurations

```nix
# In home.nix or system configuration
{ config, ... }:
let
  secrets = import ../secrets/git-config.nix;
in
{
  programs.git = {
    inherit (secrets) userName userEmail signingKey;
  };
}
```

## Security Notes

- Never commit actual secrets to git
- Use different keys per machine if needed
- Backup your age/GPG keys securely
- Consider using a password manager for additional security