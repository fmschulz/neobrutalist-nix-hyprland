# ROCm Support for AI Workloads on AMD eGPU
# Enables Ollama, llama.cpp, and other AI tools to use the RX 7900 XT

{ config, lib, pkgs, ... }:

{
  # Enable ROCm support for AI workloads
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Kernel modules for ROCm
  boot.kernelModules = [ "amdgpu" ];
  
  # ROCm specific kernel parameters
  boot.kernelParams = [
    "amdgpu.gpu_recovery=1"
    # NOTE: Removed amdgpu.dpm=0 to fix suspend/resume issues
    # DPM is critical for proper power management during suspend
    # Fix eGPU detection - force amdgpu to handle RX 7900 XT instead of radeon
    "amdgpu.si_support=1"
    "radeon.si_support=0"
  ];

  # Hardware configuration for ROCm (minimal packages to avoid build issues)
  hardware.graphics = {
    extraPackages = with pkgs; [
      # Essential ROCm packages only
      rocmPackages.clr
      rocmPackages.clr.icd
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
      # Skip problematic packages for now
      # rocmPackages.hipblas
      # rocmPackages.rocfft
      # rocmPackages.rocsparse
      # rocmPackages.rocsolver
      # rocmPackages.rccl
      # rocmPackages.miopen
      # rocmPackages.migraphx
    ];
  };

  # Environment variables for ROCm
  environment.variables = {
    # ROCm device visibility
    HIP_VISIBLE_DEVICES = "0";  # Use first GPU (eGPU)
    ROCR_VISIBLE_DEVICES = "0";
    
    # ROCm paths
    ROCM_PATH = "${pkgs.rocmPackages.clr}";
    HIP_PATH = "${pkgs.rocmPackages.clr}";
    
    # For llama.cpp and similar tools
    GGML_DEVICE = "AUTO";
    LLAMA_CUDA = "1";  # llama.cpp treats ROCm as CUDA-compatible
  };

  # Services for AI workloads
  services = {
    # Ollama service with ROCm support
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        # Force use of eGPU
        HIP_VISIBLE_DEVICES = "0";
        ROCR_VISIBLE_DEVICES = "0";
        GPU_DEVICE_ORDINAL = "0";
        
        # ROCm paths
        ROCM_PATH = "${pkgs.rocmPackages.clr}";
        HIP_PATH = "${pkgs.rocmPackages.clr}";
        
        # Override GFX version for RX 7900 XT compatibility
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
      # Use eGPU specifically - RX 7900 XT is gfx1100 (RDNA 3)
      rocmOverrideGfx = "11.0.0";
    };
  };

  # AI and ML packages (minimal to avoid build issues)
  environment.systemPackages = with pkgs; [
    # ROCm tools (essential only)
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    
    # AI frameworks with ROCm support
    ollama
    
    # Skip Python torch for now to avoid complex dependencies
    # We can add it later once basic ROCm is working
  ];

  # ROCm device access rules
  services.udev.extraRules = ''
    # ROCm device permissions
    SUBSYSTEM=="kfd", KERNEL=="kfd", TAG+="uaccess", GROUP="render"
    SUBSYSTEM=="drm", KERNEL=="renderD*", TAG+="uaccess", GROUP="render"
    
    # AMD GPU device permissions for ROCm
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x1002", TAG+="uaccess", GROUP="video"
  '';

  # User groups for GPU access  
  users.users.fschulz.extraGroups = [ "render" "video" ];
}