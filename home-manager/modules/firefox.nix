# Firefox configuration with OAuth support
{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    # Privacy-focused settings that don't break OAuth
    profiles.default = {
      settings = {
        # OAuth/Authentication fixes
        "privacy.firstparty.isolate" = false; # Disable to fix OAuth popups
        "network.cookie.cookieBehavior" = 2; # Block 3rd party cookies except OAuth
        "network.cookie.thirdparty.sessionOnly" = true;
        
        # Allow OAuth popups
        "dom.popup_allowed_events" = "click dblclick mouseup pointerup notificationclick";
        "dom.popup_maximum" = 20;
        
        # Privacy settings that don't break OAuth
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.resistFingerprinting" = false; # Can break OAuth
        
        # Container support for authentication
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        
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