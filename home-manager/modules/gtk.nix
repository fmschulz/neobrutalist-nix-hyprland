{ config, pkgs, lib, ... }:

{
  # GTK configuration
  gtk = {
    enable = true;
    
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    
    font = {
      name = "Inter";
      size = 11;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    # GTK4 uses the same CSS as GTK3
    gtk4.extraCss = ''
      /* Neo-brutalist GTK4 theme overrides */
      @import url("gtk-3.0/gtk.css");
    '';
  };
  
  # XDG portal configuration for GTK apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
  
  # Custom GTK CSS for neobrutalist theme
  home.file.".config/gtk-3.0/gtk.css".text = ''
    /* Neo-brutalist GTK3 theme overrides */
    
    /* Window decorations */
    .titlebar {
      background: #FFBE0B;
      color: #000000;
      border-bottom: 3px solid #000000;
    }
    
    .titlebar:backdrop {
      background: #FFB700;
    }
    
    /* Buttons */
    button {
      background: #FFBE0B;
      color: #000000;
      border: 3px solid #000000;
      border-radius: 0;
      font-weight: bold;
      padding: 6px 12px;
      transition: none;
    }
    
    button:hover {
      background: #FF006E;
      color: #FFFFFF;
      border-color: #000000;
    }
    
    button:active {
      background: #000000;
      color: #FFBE0B;
    }
    
    /* Entries */
    entry {
      background: #FFFFFF;
      color: #000000;
      border: 3px solid #000000;
      border-radius: 0;
      padding: 6px;
    }
    
    entry:focus {
      border-color: #FF006E;
      box-shadow: none;
    }
    
    /* Selection */
    selection {
      background-color: #FF006E;
      color: #FFFFFF;
    }
    
    /* Menus */
    menu, .menu {
      background: #FFBE0B;
      color: #000000;
      border: 3px solid #000000;
    }
    
    menuitem:hover {
      background: #FF006E;
      color: #FFFFFF;
    }
    
    /* Scrollbars */
    scrollbar {
      background: #FFBE0B;
      border: 3px solid #000000;
    }
    
    scrollbar slider {
      background: #000000;
      border: none;
      min-width: 12px;
      min-height: 12px;
    }
    
    scrollbar slider:hover {
      background: #FF006E;
    }
  '';
  
  # GTK4 CSS is handled by the gtk.extraCss option above
  # No need for manual file management
}