# ⌨️ Keybindings Guide

Complete keyboard shortcuts reference for the Neo-Brutalist NixOS configuration.

> **Note**: `Super` = Windows key / Command key

## 🚀 Essential Shortcuts

### Window Management
| Keybinding | Action |
|------------|--------|
| `Super + Q` | Close active window |
| `Super + F` | Toggle fullscreen |
| `Super + V` | Toggle floating mode |
| `Super + Shift + C` | Center floating window |
| `Super + Space` | Toggle window float |

### Window Sizing
| Keybinding | Action |
|------------|--------|
| `Super + R` | Enter resize mode |
| *In resize mode:* | |
| `Arrow Keys` or `H/J/K/L` | Resize window |
| `Escape` or `Super + R` | Exit resize mode |
| `Super + Shift + H` | Reduce window width by 50% |
| `Super + Shift + V` | Reduce window height by 50% |
| `Super + Ctrl + H` | Double window width |
| `Super + Ctrl + V` | Double window height |

### Application Launchers
| Keybinding | Action |
|------------|--------|
| `Super + Return` | Open terminal (Kitty) |
| `Super + D` | Application launcher (Wofi) |
| `Super + E` | File manager (Yazi in terminal) |
| `Super + L` | Lock screen |

## 🖥️ Workspace Navigation

### Switching Workspaces
| Keybinding | Action |
|------------|--------|
| `Super + 1-9` | Switch to workspace 1-9 |
| `Super + 0` | Switch to workspace 10 |
| `Super + S` | Toggle special workspace |
| `Super + Mouse Scroll` | Cycle through workspaces |

### Moving Windows
| Keybinding | Action |
|------------|--------|
| `Super + Shift + 1-9` | Move window to workspace 1-9 |
| `Super + Shift + 0` | Move window to workspace 10 |
| `Super + Shift + S` | Move to special workspace |

### Default Workspace Apps
- **1**: Two Kitty terminals (dark grey)
- **2**: Yazi file manager
- **3**: Firefox
- **4**: VS Code
- **5**: Chromium
- **6**: btop system monitor
- **7**: Slack
- **8**: Obsidian
- **9**: YouTube Music

## 🖼️ Multi-Monitor Control

| Keybinding | Action |
|------------|--------|
| `Super + ,` | Focus previous monitor |
| `Super + .` | Focus next monitor |
| `Super + Shift + ,` | Move window to previous monitor |
| `Super + Shift + .` | Move window to next monitor |

## 🎨 Theme & Appearance

### Wallpaper Controls
| Keybinding | Action |
|------------|--------|
| `Super + W` | Default wallpaper (all monitors) |
| `Super + Shift + W` | Alternative wallpaper 1 |
| `Super + Ctrl + W` | Alternative wallpaper 2 |

### Kitty Terminal Themes
| Keybinding | Action |
|------------|--------|
| `Ctrl + Alt + 1` | Neo-Brutalist Yellow |
| `Ctrl + Alt + 2` | Neo-Brutalist Blue |
| `Ctrl + Alt + 3` | Neo-Brutalist Purple |
| `Ctrl + Alt + 4` | Neo-Brutalist Green |
| `Ctrl + Alt + 5` | Neo-Brutalist Orange |
| `Ctrl + Alt + 6` | Neo-Brutalist Black |
| `Ctrl + Alt + 7` | Neo-Brutalist Dark Grey |
| `Ctrl + Alt + 8` | Neo-Brutalist White |

### VS Code Theme Switching
| Keybinding | Action |
|------------|--------|
| `Super + T` | Cycle through VS Code themes |
| `Super + Shift + T` | Switch to dark theme (Tokyo Night Storm) |
| `Super + Ctrl + T` | Switch to light theme (GitHub Light) |

## 🔧 System Controls

### Session Management
| Keybinding | Action |
|------------|--------|
| `Super + M` | Exit Hyprland |
| `Super + Shift + R` | Reload Hyprland config |

### Brightness & Volume
| Keybinding | Action |
|------------|--------|
| `Brightness Up/Down` | Adjust screen brightness |
| `Volume Up/Down` | Adjust volume |
| `Mute` | Toggle mute |

### Media Controls
| Keybinding | Action |
|------------|--------|
| `Play/Pause` | Play/pause media |
| `Next/Previous` | Next/previous track |

## 📋 Utilities

### Clipboard
| Keybinding | Action |
|------------|--------|
| `Super + C` | Clipboard history (Wofi menu) |

### Screenshots
| Keybinding | Action |
|------------|--------|
| `Print` | Screenshot selection |
| `Super + Print` | Screenshot entire screen |
| `Super + Shift + Print` | Screenshot active window |

### System Info
| Keybinding | Action |
|------------|--------|
| `Super + I` | System information (fastfetch) |
| `Super + Ctrl + M` | Monitor connection helper |

## 📁 Yazi File Manager

Inside Yazi:
| Keybinding | Action |
|------------|--------|
| `Enter` | Open file/enter directory |
| `a` | Create new directory |
| `Ctrl + n` | Create new file |
| `e` | Edit file with nano |
| `Ctrl + p` | Preview markdown with glow |
| `q` | Quit Yazi |

## 🎙️ Meeting Recording

Terminal commands:
| Command | Action |
|---------|--------|
| `meeting <name>` | Start meeting recording |
| `meeting -m small <name>` | Use small Whisper model |
| `record` | Quick audio recording |
| `transcribe <file>` | Transcribe audio file |

## 🖱️ Mouse Bindings

| Binding | Action |
|---------|--------|
| `Super + Left Click` | Move window |
| `Super + Right Click` | Resize window |
| `Super + Mouse Wheel` | Cycle workspaces |

## 💡 Tips

1. **Resize Mode**: After pressing `Super + R`, use arrow keys or h/j/k/l to resize. Press Escape to exit.
2. **Floating Windows**: Work best for precise sizing. Use `Super + V` to float a window first.
3. **Quick Terminal**: `Super + Return` opens a new terminal with dark grey theme.
4. **App Launcher**: `Super + D` opens Wofi - just start typing the app name.
5. **Workspace Memory**: Apps remember their assigned workspaces and will open there automatically.

## 🔗 Quick Reference Card

```
Window: Super + Q (close), F (fullscreen), V (float)
Resize: Super + R (mode), Shift + H/V (50% smaller)
Launch: Super + Return (term), D (apps), E (files)
Workspace: Super + 1-9 (switch), Shift + 1-9 (move)
Monitor: Super + ,/. (focus), Shift + ,/. (move)
Theme: Super + W (wallpaper), Ctrl+Alt + 1-8 (terminal), T (VS Code)
```