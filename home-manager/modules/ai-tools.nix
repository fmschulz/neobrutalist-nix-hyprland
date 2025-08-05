# AI Tools Configuration with eGPU Support
# Ollama, llama.cpp, and other AI tools configured for AMD RX 7900 XT

{ config, pkgs, ... }:

{
  # AI packages (minimal to avoid build issues)
  home.packages = with pkgs; [
    # Ollama (configured at system level)
    ollama
    
    # Use regular llama.cpp for now (can add ROCm support later)
    llama-cpp
    
    # Gemini CLI (from nixpkgs)
    gemini-cli

    # Additional AI tools
    # whisper-cpp  # Speech recognition
    # stable-diffusion-webui  # Image generation (if needed)
    
    # GPU monitoring for AI workloads
    radeontop  # AMD GPU monitoring
    btop
  ];

  # Environment variables for AI tools
  home.sessionVariables = {
    # ROCm configuration for AI workloads
    HIP_VISIBLE_DEVICES = "0";  # Use eGPU (card0)
    ROCR_VISIBLE_DEVICES = "0";
    
    # llama.cpp optimizations
    GGML_DEVICE = "AUTO";
    LLAMA_CUDA = "1";  # Enable GPU acceleration in llama.cpp
    
    # Ollama configuration
    OLLAMA_HOST = "127.0.0.1:11434";
    OLLAMA_GPU_OVERHEAD = "0";  # Minimize VRAM overhead
  };

  # Shell aliases for AI tools
  programs.bash.shellAliases = {
    # Ollama shortcuts
    ollama-status = "ollama ps";
    ollama-models = "ollama list";
    
    # llama.cpp with eGPU
    llama-gpu = "GGML_DEVICE=AUTO llama-cpp-server";
    
    # GPU monitoring for AI
    gpu-monitor = "radeontop";
    gpu-usage = "rocm-smi";
    
    # Test eGPU for AI
    test-rocm = "rocminfo | rg 'Agent.*gfx'";
  };

  # Create AI workspace scripts
  home.file.".local/bin/ollama-gpu" = {
    text = ''
      #!/bin/bash
      # Launch Ollama with explicit eGPU usage
      
      export HIP_VISIBLE_DEVICES=0
      export ROCR_VISIBLE_DEVICES=0
      
      echo "🤖 Starting Ollama with eGPU acceleration..."
      echo "GPU: RX 7900 XT ($(rocm-smi --showproductname | tail -1))"
      
      exec ollama "$@"
    '';
    executable = true;
  };

  home.file.".local/bin/llama-egpu" = {
    text = ''
      #!/bin/bash
      # Launch llama.cpp with eGPU acceleration
      
      export HIP_VISIBLE_DEVICES=0
      export ROCR_VISIBLE_DEVICES=0
      export GGML_DEVICE=AUTO
      export LLAMA_CUDA=1
      
      echo "🦙 Starting llama.cpp with eGPU acceleration..."
      echo "Available GPU layers will be automatically detected"
      
      exec llama-cpp-server "$@"
    '';
    executable = true;
  };

  home.file.".local/bin/ai-benchmark" = {
    text = ''
      #!/bin/bash
      # Benchmark AI performance on eGPU vs CPU
      
      echo "🧪 AI Performance Benchmark - RX 7900 XT vs CPU"
      echo "============================================="
      
      # Check ROCm detection
      echo "1. ROCm GPU Detection:"
      rocminfo | rg "Agent.*gfx" || echo "No ROCm GPU detected"
      echo
      
      # Check Ollama GPU
      echo "2. Ollama GPU Status:"
      ollama ps 2>/dev/null || echo "Ollama not running"
      echo
      
      # GPU memory info
      echo "3. GPU Memory:"
      rocm-smi --showmeminfo vram || echo "rocm-smi not available"
      echo
      
      echo "To run actual benchmarks:"
      echo "- Download a model: ollama pull llama3.2:1b"
      echo "- Test inference: time ollama run llama3.2:1b 'Hello world'"
      echo "- Monitor GPU: watch -n1 rocm-smi"
    '';
    executable = true;
  };
}