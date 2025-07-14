#!/bin/bash
# Launch Steam with eGPU acceleration

# Set eGPU environment variables
export DRI_PRIME=1
export WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card2"

# AMD GPU optimizations for gaming
export AMD_VULKAN_ICD="RADV"
export RADV_PERFTEST="gpl,nggc,sam"  # Enable performance optimizations
export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"

echo "🎮 Launching Steam with eGPU (RX 7900 XT)..."
echo "GPU: $(DRI_PRIME=1 glxinfo | rg "OpenGL renderer" | cut -d: -f2)"

# Launch Steam
exec steam "$@"