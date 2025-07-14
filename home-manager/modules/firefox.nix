# Firefox configuration with OAuth support
{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    # Privacy-focused settings that don't break OAuth
    profiles.default = {
      isDefault = true;
      id = 0;
      path = "default";  # Use consistent profile path
      
      settings = {
        # Only set essential settings that don't interfere with cookies/sessions
        
        # Wayland-specific settings
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "media.hardwaremediakeys.enabled" = false;
        
        # Neo-brutalist theme preference
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # Performance
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
      
      # Extensions can be added manually through Firefox
      # or configure through NUR if available
    };
  };
}