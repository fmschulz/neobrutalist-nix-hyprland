#!/usr/bin/env bash
# Script to migrate /home to the 1.7TB partition
# Run this as root from a TTY console (Ctrl+Alt+F2)

set -e

echo "=== Home Migration Script ==="
echo "This will move your home directory to the 1.7TB partition"
echo ""
echo "IMPORTANT: Run this from a root TTY console (Ctrl+Alt+F2), NOT from GUI!"
echo "Steps:"
echo "1. Press Ctrl+Alt+F2 to switch to TTY2"
echo "2. Login as root"
echo "3. Run: bash /home/fschulz/dotfiles/scripts/migrate-home.sh"
echo ""
read -p "Are you running this from a TTY as root? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted. Please run from TTY as root."
    exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

echo "Step 1: Stopping display manager and user sessions..."
systemctl stop greetd || true
systemctl stop display-manager || true
pkill -u fschulz || true
sleep 3

echo "Step 2: Creating backup of current home..."
if [ ! -d "/home.backup" ]; then
    echo "Copying /home to /home.backup (this will take a while)..."
    cp -a /home /home.backup
    echo "Backup created at /home.backup"
else
    echo "Backup already exists at /home.backup"
fi

echo "Step 3: Checking storage partition..."
if ! mountpoint -q /home/storage; then
    echo "ERROR: /home/storage is not mounted!"
    exit 1
fi

echo "Step 4: Copying home to storage partition..."
echo "This will merge with existing /home/storage content..."
rsync -avxHAXS --progress /home/ /home/storage/

echo "Step 5: Unmounting current /home/storage..."
umount /home/storage

echo "Step 6: Moving old home out of the way..."
mv /home /home.old

echo "Step 7: Creating new home mount point..."
mkdir /home

echo "Step 8: Mounting storage partition as /home..."
mount /dev/disk/by-uuid/bfdbd63b-773e-4bc9-847c-3faeaeb78b73 /home

echo "Step 9: Verifying..."
ls -la /home/
df -h /home

echo ""
echo "=== Migration Complete! ==="
echo ""
echo "Now:"
echo "1. Type: nixos-rebuild switch --flake /home/fschulz/dotfiles --impure"
echo "2. Reboot"
echo "3. After successful reboot, you can remove /home.old and /home.backup"
echo ""
echo "If something goes wrong:"
echo "1. Boot from live USB"
echo "2. Mount root partition"
echo "3. Move /home.old back to /home"
echo "4. Fix the configuration"