# Testing Instructions for Framework 13 AMD Fixes

## Issue #1: Sleep/Wake Failure Fix

### Changes Applied:
1. Added `amdgpu.sg_display=0` kernel parameter to fix display issues after sleep/wake
2. Removed `nvme.noacpi=1` (causes issues on AMD systems, only for Intel)

### Testing Steps:
```bash
# 1. Rebuild system with new kernel parameters
cd ~/dotfiles
./rebuild.sh system

# 2. Reboot to apply kernel changes
sudo reboot

# 3. Test sleep/wake cycle
# Close laptop lid, wait 10 seconds
# Open lid and check if display wakes properly

# 4. Verify kernel parameters are applied
cat /proc/cmdline | grep amdgpu.sg_display

# 5. Monitor suspend logs
journalctl -f | grep -i suspend
# Then close/open lid and check for errors

# 6. Check wake sources
cat /proc/acpi/wakeup
```

### Expected Results:
- System should wake with display functioning
- No black screen requiring force restart
- Logs should show clean suspend/resume cycle

---

## Issue #2: External Monitor Clamshell Mode

### Changes Applied:
1. Created clamshell mode script at `home-manager/scripts/clamshell-mode.sh`
2. Updated Hyprland to use script for lid events
3. Added `clamshell-support.nix` module to ignore lid switch in systemd

### Testing Steps:
```bash
# 1. Rebuild system and home-manager
cd ~/dotfiles
./rebuild.sh

# 2. Test clamshell script directly
~/dotfiles/home-manager/scripts/clamshell-mode.sh status

# 3. Connect external monitor via USB-C dock
# Verify both displays are detected
hyprctl monitors

# 4. Close laptop lid
# External monitor should remain active

# 5. Open laptop lid
# Both displays should be active

# 6. Check systemd-logind settings
cat /etc/systemd/logind.conf | grep -i lid
systemctl show systemd-logind | grep -i lid
```

### Expected Results:
- External monitor stays active when lid is closed
- No black screen on external display
- System doesn't suspend when lid is closed while docked
- Workspaces move to external monitor when laptop display is disabled

---

## Issue #3: VS Code Multiple Instances

### Changes Applied:
1. Modified Hyprland config to launch VS Code with `--wait --new-window` flags
2. Single instance should launch on workspace 4

### Testing Steps:
```bash
# 1. Rebuild home-manager
cd ~/dotfiles
./rebuild.sh home

# 2. Kill any existing VS Code instances
pkill code

# 3. Reboot or restart Hyprland
hyprctl dispatch exit
# or
sudo reboot

# 4. After restart, check VS Code instances
hyprctl clients | grep -i "class: code"
ps aux | grep -i "code " | grep -v grep | wc -l

# 5. Navigate to workspace 4
# Super + 4

# 6. Try opening additional VS Code windows
code ~/dotfiles  # Should open in existing instance
```

### Expected Results:
- Only ONE VS Code instance on workspace 4
- Additional files open in the same instance
- `hyprctl clients | grep -i "class: code" | wc -l` should return 1

---

## Quick Verification Commands

Run these after rebuild and reboot:

```bash
# Check all fixes at once
echo "=== Kernel Parameters ==="
cat /proc/cmdline | grep -E "amdgpu.sg_display|nvme.noacpi"

echo "=== Clamshell Mode ==="
~/dotfiles/home-manager/scripts/clamshell-mode.sh status

echo "=== VS Code Instances ==="
hyprctl clients | grep -i "class: code" | wc -l

echo "=== Suspend/Wake Sources ==="
cat /proc/acpi/wakeup | grep enabled

echo "=== Systemd Lid Settings ==="
systemctl show systemd-logind | grep -i lid
```

## Rollback Instructions

If any issues occur:

```bash
# System rollback
sudo nixos-rebuild switch --rollback

# Home-manager rollback  
home-manager rollback

# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
home-manager generations
```