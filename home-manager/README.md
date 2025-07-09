# Home-Manager Test Configuration

This is a **safe test environment** for trying out home-manager with your NixOS setup. Nothing here will affect your current system until you explicitly choose to apply it.

## 📁 Structure

```
home-manager-test/
├── flake.nix              # Flake with home-manager integration
├── home.nix               # Main home-manager configuration
├── modules/               # Modular configurations
│   ├── hyprland.nix      # Hyprland WM config
│   ├── kitty.nix         # Terminal config
│   ├── yazi.nix          # File manager config
│   ├── fastfetch.nix     # System info tool
│   ├── gtk.nix           # GTK theming
│   ├── qt.nix            # Qt theming
│   └── scripts.nix       # Custom scripts
├── test-home-manager.sh   # Safe testing script
└── README.md             # This file
```

## 🚀 Testing Steps

### 1. First Time Setup
Since git is in your nix config, once installed:
```bash
cd ~/dotfiles/home-manager-test
```

### 2. Test Build (Safe - No Changes)
```bash
./test-home-manager.sh build
```
This validates your configuration without making any changes.

### 3. Apply Home-Manager Only (User-Level)
```bash
./test-home-manager.sh switch
```
This applies home-manager for your user without touching NixOS system config.

### 4. Test Full NixOS Integration (Dry Run)
```bash
./test-home-manager.sh nixos-test
```
This creates a script to test full NixOS rebuild with home-manager.

## 🔄 How to Revert

```bash
./test-home-manager.sh revert
```
Shows all methods to rollback changes.

## ✅ What's Included

- **All your current configs** converted to home-manager format
- **Declarative package management** for user packages
- **Consistent theming** across all applications
- **Git integration** with your preferences
- **Shell customization** with aliases and welcome script
- **Modular design** for easy customization

## 🎯 Benefits Over Current Setup

1. **Atomic updates**: All user configs update together
2. **Rollbacks**: Easy to revert to previous configurations
3. **Reproducible**: Share exact setup across machines
4. **Type-checked**: Nix validates configurations
5. **Integrated**: Packages and configs in one place

## ⚠️ Important Notes

- Your original configs are safe in `~/dotfiles/home/`
- This test setup is completely isolated
- No system changes until you explicitly rebuild NixOS
- Backups are created automatically when switching

## 📝 Customization

Edit `home.nix` to:
- Update git username/email
- Add/remove packages
- Change default applications
- Modify environment variables

Each module in `modules/` can be edited independently for specific app configurations.

## 🔧 Next Steps

If testing goes well:
1. Customize `home.nix` with your preferences
2. Test thoroughly with `./test-home-manager.sh build`
3. Apply with `./test-home-manager.sh switch`
4. Eventually integrate into main NixOS config
5. Move this to your main dotfiles structure

Remember: This is designed to be **safe to experiment with**!