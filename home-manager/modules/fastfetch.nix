{ config, pkgs, lib, ... }:

{
  # Fastfetch configuration
  home.file.".config/fastfetch/config.jsonc" = {
    text = builtins.toJSON {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        source = "nixos_small";
        padding = {
          top = 2;
          right = 4;
        };
      };
      display = {
        separator = " ";
        color = {
          keys = "yellow";
          output = "white";
        };
      };
      modules = [
        {
          type = "custom";
          format = "{#1;38;5;208}█████{#1;38;5;202}█████{#0} {#1;37}FRAMEWORK NIXOS{#0} {#1;38;5;208}█████{#1;38;5;202}█████{#0}";
        }
        {
          type = "custom";
          format = "{#1;38;5;208}█████{#1;38;5;202}█████{#0} {#1;33}BERKELEY STATION{#0} {#1;38;5;208}█████{#1;38;5;202}█████{#0}";
        }
        "break"
        {
          type = "os";
          key = "OS";
        }
        {
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "uptime";
          key = "Uptime";
        }
        {
          type = "packages";
          key = "Packages";
        }
        "break"
        {
          type = "wm";
          key = "WM";
        }
        {
          type = "terminal";
          key = "Terminal";
        }
        {
          type = "shell";
          key = "Shell";
        }
        "break"
        {
          type = "host";
          key = "Host";
        }
        {
          type = "cpu";
          key = "CPU";
        }
        {
          type = "gpu";
          key = "GPU";
        }
        {
          type = "memory";
          key = "Memory";
        }
        "break"
        {
          type = "disk";
          key = "Storage";
        }
        {
          type = "battery";
          key = "Battery";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 4;
          symbol = "circle";
        }
      ];
    };
  };
}