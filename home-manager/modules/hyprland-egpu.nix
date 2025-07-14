# Hyprland eGPU Configuration
# Optimized for Framework 13 AMD + AMD RX 7800 XT eGPU setup

{ config, lib, pkgs, ... }:

{
  # Environment variables specifically for Hyprland with eGPU
  home.sessionVariables = {
    # AMD GPU settings
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # DRM devices - prioritize eGPU (card0) over integrated (card2)
    # Note: You may need to adjust these based on your actual card numbers
    # Run `ls /dev/dri/` to check which card is which
    WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card2";
    
    # KDE/KWin specific (if using any KDE apps)
    __GLX_VENDOR_LIBRARY_NAME = "amd";
    KWIN_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card2";
    
    # Force discrete GPU for 3D applications
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    
    # Prefer external GPU for Vulkan
    VK_DEVICE_SELECT_FORCELIST_LAYER_DISABLE_ENVIRONMENT_SUPPORT = "1";
  };

  # Create eGPU detection script
  home.file.".local/bin/egpu-detect" = {
    text = ''
      #!/bin/bash
      
      # Detect eGPU and set appropriate environment variables
      EGPU_CARD=""
      IGPU_CARD=""
      
      # Find cards
      for card in /dev/dri/card*; do
        card_num=$(basename "$card" | sed 's/card//')
        
        # Check if it's removable (eGPU)
        if [[ -e "/sys/class/drm/card$card_num/device/removable" ]] && 
           [[ $(cat "/sys/class/drm/card$card_num/device/removable") == "removable" ]]; then
          EGPU_CARD="$card"
        else
          # Check if it's AMD integrated GPU
          if lspci -s $(cat "/sys/class/drm/card$card_num/device/uevent" | grep PCI_SLOT_NAME | cut -d= -f2) | grep -i "amd.*vga" > /dev/null; then
            IGPU_CARD="$card"
          fi
        fi
      done
      
      echo "Detected eGPU: $EGPU_CARD"
      echo "Detected iGPU: $IGPU_CARD"
      
      # Set environment variables based on detection
      if [[ -n "$EGPU_CARD" && -n "$IGPU_CARD" ]]; then
        echo "export WLR_DRM_DEVICES=\"$EGPU_CARD:$IGPU_CARD\""
        echo "export KWIN_DRM_DEVICES=\"$EGPU_CARD:$IGPU_CARD\""
        echo "export DRI_PRIME=1"
      elif [[ -n "$IGPU_CARD" ]]; then
        echo "export WLR_DRM_DEVICES=\"$IGPU_CARD\""
        echo "export KWIN_DRM_DEVICES=\"$IGPU_CARD\""
        echo "unset DRI_PRIME"
      fi
    '';
    executable = true;
  };

  # Create eGPU performance test script
  home.file.".local/bin/egpu-test" = {
    text = ''
      #!/bin/bash
      
      echo "=== eGPU Performance Test ==="
      echo
      
      echo "1. Detecting GPUs..."
      lspci | grep -i vga
      echo
      
      echo "2. DRI devices:"
      ls -la /dev/dri/
      echo
      
      echo "3. Vulkan devices:"
      vulkaninfo --summary | grep -A 2 "GPU[0-9]:"
      echo
      
      echo "4. Testing integrated GPU (glmark2):"
      glmark2 --size 800x600 --run-forever false
      echo
      
      echo "5. Testing eGPU (DRI_PRIME=1 glmark2):"
      DRI_PRIME=1 glmark2 --size 800x600 --run-forever false
      echo
      
      echo "6. OpenGL info - integrated GPU:"
      glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"
      echo
      
      echo "7. OpenGL info - eGPU:"
      DRI_PRIME=1 glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"
      echo
      
      echo "=== Test Complete ==="
    '';
    executable = true;
  };

  # Create eGPU monitoring script
  home.file.".local/bin/egpu-monitor" = {
    text = ''
      #!/bin/bash
      
      # Monitor eGPU status and performance
      watch -n 1 "
        echo '=== eGPU Status Monitor ==='
        echo
        echo 'Thunderbolt devices:'
        if command -v boltctl > /dev/null; then
          boltctl list
        else
          echo 'boltctl not available'
        fi
        echo
        echo 'DRI devices:'
        ls -la /dev/dri/
        echo
        echo 'GPU processes:'
        if command -v radeontop > /dev/null; then
          radeontop -d- -l1 2>/dev/null || echo 'radeontop failed'
        else
          echo 'radeontop not available'
        fi
        echo
        echo 'Current DRM environment:'
        echo 'WLR_DRM_DEVICES: $WLR_DRM_DEVICES'
        echo 'DRI_PRIME: $DRI_PRIME'
      "
    '';
    executable = true;
  };

  # Shell aliases for eGPU management
  programs.bash.shellAliases = {
    egpu-detect = "~/.local/bin/egpu-detect";
    egpu-test = "~/.local/bin/egpu-test";
    egpu-monitor = "~/.local/bin/egpu-monitor";
    egpu-glxinfo = "DRI_PRIME=1 glxinfo | grep -E '(OpenGL vendor|OpenGL renderer|OpenGL version)'";
    egpu-vulkan = "DRI_PRIME=1 vulkaninfo --summary";
  };
}