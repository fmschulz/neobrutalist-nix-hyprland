# Hardware Specifications & Compatibility

## Framework 13 AMD (7040 Series) - Primary Configuration

### Detailed Specifications
- **Model**: Framework Laptop 13 (AMD Ryzen 7040Series)
- **CPU**: AMD Ryzen 7 7840U
  - 8 cores, 16 threads
  - Base: 3.3 GHz, Boost: up to 5.1 GHz
  - 28W TDP (configurable 15-30W)
- **GPU**: AMD Radeon 780M (integrated)
  - RDNA 3 architecture
  - 12 compute units
  - Up to 2.7 GHz boost clock
- **RAM**: 32GB DDR5-5600 (2x16GB SO-DIMM)
  - Expandable up to 64GB
  - Dual channel configuration
- **Storage**: 
  - Primary: 256GB NVMe SSD (M.2 2280)
  - Secondary: 1.7TB ext4 partition (from previous Manjaro installation)
- **Display**: 13.5" 2256x1504 (3:2 aspect ratio)
  - 201 PPI
  - sRGB color gamut
  - 400 nits brightness
- **Ports**: 4x USB-C/Thunderbolt 4 (modular expansion cards)
- **WiFi**: WiFi 6E (802.11ax) + Bluetooth 5.3
- **Audio**: Quad speaker array with smart amplifiers
- **Camera**: 1080p webcam with privacy switch
- **Battery**: 55Wh Li-ion
- **Weight**: 1.3kg (2.87 lbs)
- **Dimensions**: 296.63 × 228.98 × 15.85 mm

### Kernel Optimizations
```nix
boot.kernelParams = [
  "amd_pstate=active"           # Enhanced AMD power management
  "amdgpu.sg_display=0"         # Fix display issues
  "rtc_cmos.use_acpi_alarm=1"   # Better RTC wake from suspend
  "mem_sleep_default=deep"      # Deep sleep for better battery life
  "module_blacklist=hid_sensor_hub"  # Fixes ambient light sensor conflicts
];
```

### Power Management
- **Active Power States**: Enabled for better frequency scaling
- **Deep Sleep**: Configured for suspend-to-RAM
- **Thermal Management**: thermald enabled for AMD thermal control
- **Power Profiles**: power-profiles-daemon for adaptive power management

### Known Issues & Workarounds
1. **Ambient Light Sensor**: Blacklisted `hid_sensor_hub` module
2. **Display Issues**: `amdgpu.sg_display=0` parameter fixes occasional artifacts
3. **Suspend Issues**: Deep sleep mode resolves wake-up problems
4. **Fingerprint Reader**: Requires `fprintd` service and Framework-specific drivers

## Portability Considerations

### Hardware Profiles
The configuration includes modular hardware profiles in `/hardware/`:
- `framework-13-amd.nix` - Framework 13 AMD specific optimizations
- Template ready for additional hardware profiles

### Cross-Hardware Compatibility
- **CPU Architecture**: x86_64-linux
- **Graphics**: Supports both AMD and Intel integrated graphics
- **Storage**: Uses UUIDs for consistent mounting across systems
- **Network**: NetworkManager for universal WiFi support
- **Audio**: PipeWire for modern audio stack compatibility

### Adding New Hardware
1. Create new hardware profile in `/hardware/`
2. Add host configuration in `/hosts/hostname/`
3. Update `flake.nix` with new nixosConfiguration
4. Document specifications in this file

## Performance Benchmarks

### Framework 13 AMD Performance
- **Cinebench R23**: ~15,000 multi-core, ~1,500 single-core
- **Geekbench 6**: ~2,400 single-core, ~11,000 multi-core
- **GPU Performance**: ~25,000 points in 3DMark Time Spy
- **Battery Life**: 8-12 hours typical usage
- **Thermal**: 28W sustained, peaks at 45W for short bursts

### Memory & Storage
- **RAM Performance**: DDR5-5600 dual channel
- **Storage Speed**: NVMe SSD ~3,500 MB/s read, ~3,000 MB/s write
- **Boot Time**: ~8 seconds to login with NixOS + Hyprland

## Expansion Cards Used
1. **USB-C**: General connectivity
2. **USB-A**: Legacy device support  
3. **HDMI**: External display connection
4. **MicroSD**: Additional storage

## Future Hardware Considerations
- Framework 16 AMD compatibility (similar configuration)
- Intel variants (would need different GPU drivers)
- Framework modular upgrades (CPU board swaps)
- eGPU support via Thunderbolt 4

## Monitoring Commands
```bash
# Temperature monitoring
sensors

# GPU information
radeontop

# Battery status
acpi -b

# Power consumption
powertop

# Hardware info
lshw -short

# Framework-specific tool
framework_tool
```

## Hardware-Specific Packages
The configuration includes Framework-optimized packages:
- `framework-tool` - Official Framework utilities
- `fwupd` - Firmware update daemon
- `thermald` - AMD thermal management
- `power-profiles-daemon` - Power state management