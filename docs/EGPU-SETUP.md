# eGPU Setup Guide - Framework 13 AMD + RX 7800 XT

This guide covers setting up an AMD RX 7800 XT eGPU in a Razer Core X Chroma enclosure with the Framework 13 AMD laptop running NixOS and Hyprland.

## Hardware Requirements

- **Laptop**: Framework 13 AMD (7040 series)
- **eGPU**: AMD RX 7800 XT 
- **Enclosure**: Razer Core X Chroma (or similar Thunderbolt 3/4 eGPU enclosure)
- **Connection**: Use one of the **back two USB-C ports** on Framework 13 (only these support Thunderbolt)

## Configuration Overview

The eGPU setup consists of several NixOS modules:

### System-Level Configuration
- **`hardware/egpu-support.nix`**: Thunderbolt support, kernel modules, udev rules
- **`hardware/framework-13-amd.nix`**: Base AMD GPU support with eGPU compatibility
- **`system/system/configuration.nix`**: Kernel parameters for PCIe hotplug

### User-Level Configuration  
- **`home-manager/modules/hyprland-egpu.nix`**: Hyprland-specific eGPU environment variables and scripts

## Key Environment Variables

Based on Reddit solutions, these variables are crucial for proper eGPU function:

```bash
# AMD GPU driver settings
AMD_VULKAN_ICD="RADV"
VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"

# DRM device priority (adjust card numbers based on your system)
WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card2"  # eGPU:integrated

# OpenGL/Mesa settings
__GLX_VENDOR_LIBRARY_NAME="amd"
MESA_LOADER_DRIVER_OVERRIDE="radeonsi"

# Use eGPU for 3D rendering
DRI_PRIME=1
```

## Installation Steps

1. **Apply Configuration**:
   ```bash
   cd ~/dotfiles
   ./scripts/setup-egpu.sh
   ```

2. **Reboot**: Required for kernel modules and Thunderbolt support
   ```bash
   sudo reboot
   ```

3. **Connect eGPU**:
   - Use one of the **back two USB-C ports** (Thunderbolt-capable)
   - Power on the eGPU enclosure
   - The eGPU should be automatically authorized

## Testing and Verification

### Check eGPU Detection
```bash
# List Thunderbolt devices
boltctl list

# Check DRI devices  
ls /dev/dri/

# List graphics cards
lspci | grep -i vga

# Check Vulkan devices
vulkaninfo --summary
```

### Performance Testing
```bash
# Test integrated GPU
glmark2 --size 800x600 --run-forever false

# Test eGPU (should show much higher performance)
DRI_PRIME=1 glmark2 --size 800x600 --run-forever false

# Compare OpenGL renderers
glxinfo | grep "OpenGL renderer"
DRI_PRIME=1 glxinfo | grep "OpenGL renderer"
```

### Helper Scripts
The configuration includes several helper scripts:

```bash
# Detect GPU card assignments
egpu-detect

# Run comprehensive performance test
egpu-test

# Monitor eGPU status in real-time
egpu-monitor

# Quick eGPU OpenGL info
egpu-glxinfo

# Quick eGPU Vulkan info  
egpu-vulkan
```

## Expected Performance

Based on Reddit user experiences:

- **Integrated AMD GPU**: ~18,000 glmark2 score
- **eGPU (properly configured)**: Significantly higher scores (varies by test)
- **eGPU (misconfigured)**: ~600 glmark2 score (throttled performance)

## Troubleshooting

### eGPU Not Detected
1. Ensure you're using a **back USB-C port** (front ports don't support Thunderbolt)
2. Check Thunderbolt authorization:
   ```bash
   boltctl list
   # Should show eGPU enclosure as "authorized"
   ```
3. Verify kernel modules:
   ```bash
   lsmod | grep thunderbolt
   lsmod | grep amdgpu
   ```

### Poor eGPU Performance  
1. Check environment variables:
   ```bash
   echo $WLR_DRM_DEVICES
   echo $DRI_PRIME
   ```
2. Verify card assignments:
   ```bash
   egpu-detect
   ```
3. Check GPU utilization:
   ```bash
   radeontop
   ```

### DRM Device Assignment Issues
GPU card numbers can vary. To find the correct assignments:

```bash
# Find eGPU (removable device)
for card in /dev/dri/card*; do
    card_num=$(basename "$card" | sed 's/card//')
    if [[ -e "/sys/class/drm/card$card_num/device/removable" ]]; then
        echo "eGPU: $card"
    fi
done

# Update WLR_DRM_DEVICES accordingly
export WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card2"  # Adjust as needed
```

## Hyprland Integration

The eGPU configuration automatically integrates with Hyprland:

- **DRM devices** are configured for multi-GPU setup
- **Environment variables** are set for optimal rendering
- **Hotplug support** attempts to restart Hyprland when eGPU is connected/disconnected

### Manual Hyprland Restart
If needed, restart Hyprland with eGPU:
```bash
# Kill current Hyprland session
pkill Hyprland

# Start new session (will pick up updated environment)
Hyprland
```

## Gaming Performance

For gaming with the eGPU:

```bash
# Run games with eGPU
DRI_PRIME=1 steam
DRI_PRIME=1 lutris
DRI_PRIME=1 <your-game>
```

## Known Issues

1. **Performance Inconsistency**: Reddit users report varying success with eGPU performance
2. **Hotplug Reliability**: May require manual environment variable adjustment
3. **Display Output**: External displays connected to eGPU may require additional configuration
4. **Power Management**: eGPU may not work optimally with laptop power saving features

## Additional Resources

- [NixOS Hardware GitHub](https://github.com/NixOS/nixos-hardware/tree/master/framework/13-inch/7040-amd)
- [Framework 13 AMD eGPU Reddit Discussion](https://www.reddit.com/r/NixOS/comments/1dw8zly/need_help_with_egpu_on_framework_13/)
- [Hyprland Multi-GPU Documentation](https://wiki.hyprland.org/Configuring/Multi-GPU/)

## Files Modified

This eGPU setup adds/modifies:

- `hardware/egpu-support.nix` (new)
- `home-manager/modules/hyprland-egpu.nix` (new)  
- `scripts/setup-egpu.sh` (new)
- `hardware/framework-13-amd.nix` (modified)
- `system/system/configuration.nix` (modified)
- `hosts/framework-nixos/configuration.nix` (modified)
- `hosts/framework-nixos/home.nix` (modified)