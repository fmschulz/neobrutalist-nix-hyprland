{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;  # Manage manually due to path issues
    
    settings = {
      # Neo-brutalist prompt with bold colors
      format = lib.concatStrings [
        "[](fg:#FFBE0B bg:none)"
        "[ $os$username ](fg:#000000 bg:#FFBE0B bold)"
        "[](fg:#FFBE0B bg:#FF006E)"
        "[ $directory ](fg:#FFFFFF bg:#FF006E bold)"
        "[](fg:#FF006E bg:#3185FC)"
        "[ $git_branch$git_status ](fg:#FFFFFF bg:#3185FC bold)"
        "[](fg:#3185FC bg:#06FFA5)"
        "[ $python$nodejs$rust$java ](fg:#000000 bg:#06FFA5 bold)"
        "[](fg:#06FFA5 bg:none)"
        "$line_break"
        "$character"
      ];
      
      # Prompt character
      character = {
        success_symbol = "[▶](bold fg:#06FFA5)";
        error_symbol = "[▶](bold fg:#FF006E)";
      };
      
      # OS Module
      os = {
        disabled = false;
        symbols = {
          NixOS = " ";
          Linux = " ";
        };
      };
      
      # Username
      username = {
        show_always = true;
        style_user = "bold fg:#000000 bg:#FFBE0B";
        style_root = "bold fg:#FFFFFF bg:#FF006E";
        format = "[$user]($style)";
      };
      
      # Directory
      directory = {
        style = "bold fg:#FFFFFF bg:#FF006E";
        format = "[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " 🔒";
        
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Projects" = " ";
        };
      };
      
      # Git
      git_branch = {
        symbol = " ";
        style = "bold fg:#FFFFFF bg:#3185FC";
        format = "[$symbol$branch]($style)";
      };
      
      git_status = {
        style = "bold fg:#FFFFFF bg:#3185FC";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "🏳";
        up_to_date = " ";
        untracked = " ";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        stashed = " ";
        modified = " ";
        staged = "[++\($count\)](green)";
        renamed = "襁 ";
        deleted = " ";
      };
      
      # Languages
      python = {
        symbol = " ";
        style = "bold fg:#000000 bg:#06FFA5";
        format = "[$symbol$version]($style)";
      };
      
      nodejs = {
        symbol = " ";
        style = "bold fg:#000000 bg:#06FFA5";
        format = "[$symbol$version]($style)";
      };
      
      rust = {
        symbol = " ";
        style = "bold fg:#000000 bg:#06FFA5";
        format = "[$symbol$version]($style)";
      };
      
      java = {
        symbol = " ";
        style = "bold fg:#000000 bg:#06FFA5";
        format = "[$symbol$version]($style)";
      };
      
      # Time (optional)
      time = {
        disabled = true;
        format = "[ $time ]($style)";
        time_format = "%T";
        style = "bold fg:#000000 bg:#B14AFF";
      };
      
      # Battery (for laptop)
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";
        display = [
          { threshold = 10; style = "bold fg:#FF006E"; }
          { threshold = 30; style = "bold fg:#FFB700"; }
          { threshold = 100; style = "bold fg:#06FFA5"; }
        ];
      };
    };
  };
}