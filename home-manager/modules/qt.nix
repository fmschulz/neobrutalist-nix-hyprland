{ config, pkgs, lib, ... }:

{
  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk3";  # Use GTK theme for Qt apps
    style = {
      name = "gtk2";
      package = pkgs.adwaita-qt;
    };
  };
  
  # Qt6 configuration (for kdePackages.dolphin)
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    qt6Packages.qt6ct
    adwaita-qt6
    # Simple, minimal icon themes
    adwaita-icon-theme
    hicolor-icon-theme
  ];
  
  # Qt5ct configuration for more detailed theming
  home.file.".config/qt5ct/qt5ct.conf".text = ''
    [Appearance]
    custom_palette=true
    color_scheme_path=$HOME/.config/qt5ct/colors/neobrutalist.conf
    icon_theme=Adwaita
    standard_dialogs=gtk3
    style=Fusion
    
    [Fonts]
    fixed=@Variant(\0\0\0@\0\0\0\x16\0J\0\x65\0t\0\x42\0r\0\x61\0i\0n\0s\0 \0M\0o\0n\0o@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    general=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    
    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=$HOME/.config/qt5ct/qss/neobrutalist.qss
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
    
    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\x2\x80\0\0\0\xfa\0\0\x5\0\0\0\x3 \0\0\x2\x80\0\0\0\xfa\0\0\x5\0\0\0\x3 \0\0\0\0\0\0\0\0\a\x80\0\0\x2\x80\0\0\0\xfa\0\0\x5\0\0\0\x3 )
  '';
  
  # Custom color palette for Qt5ct
  home.file.".config/qt5ct/colors/neobrutalist.conf".text = ''
    [ColorScheme]
    active_colors=#000000, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #000000, #FFFFFF, #000000, #FFBE0B, #FFBE0B, #4D4D4D, #FF006E, #FFFFFF, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
    disabled_colors=#808080, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #808080, #FFFFFF, #808080, #FFBE0B, #FFBE0B, #4D4D4D, #FFBE0B, #808080, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
    inactive_colors=#000000, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #000000, #FFFFFF, #000000, #FFBE0B, #FFBE0B, #4D4D4D, #FFB700, #000000, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
  '';
  
  # Neo-brutalist QSS stylesheet for Qt applications
  home.file.".config/qt5ct/qss/neobrutalist.qss".text = ''
    /* Neo-brutalist Qt stylesheet */
    
    /* Main window */
    QMainWindow {
        background-color: #FFBE0B;
        color: #000000;
    }
    
    /* Buttons */
    QPushButton {
        background-color: #FFBE0B;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 6px 12px;
        font-weight: bold;
        min-height: 20px;
    }
    
    QPushButton:hover {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    QPushButton:pressed {
        background-color: #000000;
        color: #FFBE0B;
    }
    
    QPushButton:disabled {
        background-color: #FFB700;
        color: #808080;
    }
    
    /* Text input fields */
    QLineEdit, QTextEdit, QPlainTextEdit {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 6px;
    }
    
    QLineEdit:focus, QTextEdit:focus, QPlainTextEdit:focus {
        border-color: #FF006E;
    }
    
    /* List views and tree views */
    QListView, QTreeView, QTableView {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        selection-background-color: #FF006E;
        selection-color: #FFFFFF;
    }
    
    QListView::item:selected, QTreeView::item:selected {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    QListView::item:hover, QTreeView::item:hover {
        background-color: #FFB700;
        color: #000000;
    }
    
    /* Headers */
    QHeaderView::section {
        background-color: #FFBE0B;
        color: #000000;
        border: 2px solid #000000;
        padding: 4px;
        font-weight: bold;
    }
    
    /* Menus */
    QMenu {
        background-color: #FFBE0B;
        color: #000000;
        border: 3px solid #000000;
    }
    
    QMenu::item:selected {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    /* Scrollbars */
    QScrollBar:vertical {
        background-color: #FFBE0B;
        border: 2px solid #000000;
        width: 20px;
    }
    
    QScrollBar::handle:vertical {
        background-color: #000000;
        border: none;
        min-height: 20px;
    }
    
    QScrollBar::handle:vertical:hover {
        background-color: #FF006E;
    }
    
    QScrollBar:horizontal {
        background-color: #FFBE0B;
        border: 2px solid #000000;
        height: 20px;
    }
    
    QScrollBar::handle:horizontal {
        background-color: #000000;
        border: none;
        min-width: 20px;
    }
    
    QScrollBar::handle:horizontal:hover {
        background-color: #FF006E;
    }
    
    /* Tool bars */
    QToolBar {
        background-color: #FFBE0B;
        border: 2px solid #000000;
        spacing: 2px;
    }
    
    QToolButton {
        background-color: #FFBE0B;
        color: #000000;
        border: 2px solid #000000;
        border-radius: 0px;
        padding: 4px;
        font-weight: bold;
    }
    
    QToolButton:hover {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    /* Status bar */
    QStatusBar {
        background-color: #FFBE0B;
        color: #000000;
        border-top: 2px solid #000000;
    }
    
    /* Combo boxes */
    QComboBox {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 4px;
    }
    
    QComboBox:drop-down {
        background-color: #FFBE0B;
        border-left: 2px solid #000000;
    }
    
    QComboBox QAbstractItemView {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        selection-background-color: #FF006E;
        selection-color: #FFFFFF;
    }
    
    /* File dialog specific */
    QFileDialog {
        background-color: #FFBE0B;
        color: #000000;
    }
    
    QFileDialog QListView::item:selected {
        background-color: #FF006E;
        color: #FFFFFF;
    }
  '';
  
  # Qt6 configuration (qt6ct)
  home.file.".config/qt6ct/qt6ct.conf".text = ''
    [Appearance]
    custom_palette=true
    color_scheme_path=$HOME/.config/qt6ct/colors/neobrutalist.conf
    icon_theme=Adwaita
    standard_dialogs=default
    style=Fusion
    
    [Fonts]
    fixed=@Variant(\0\0\0@\0\0\0\x16\0J\0\x65\0t\0\x42\0r\0\x61\0i\0n\0s\0 \0M\0o\0n\0o@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    general=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    
    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=$HOME/.config/qt6ct/qss/neobrutalist.qss
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
  '';
  
  # Qt6 color scheme
  home.file.".config/qt6ct/colors/neobrutalist.conf".text = ''
    [ColorScheme]
    active_colors=#000000, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #000000, #FFFFFF, #000000, #FFBE0B, #FFBE0B, #4D4D4D, #FF006E, #FFFFFF, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
    disabled_colors=#808080, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #808080, #FFFFFF, #808080, #FFBE0B, #FFBE0B, #4D4D4D, #FFBE0B, #808080, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
    inactive_colors=#000000, #FFBE0B, #FFD23F, #FFC833, #FFB700, #FF9500, #000000, #FFFFFF, #000000, #FFBE0B, #FFBE0B, #4D4D4D, #FFB700, #000000, #3185FC, #B14AFF, #FFBE0B, #000000, #000000, #000000, #000000
  '';
  
  # Qt6 QSS stylesheet
  home.file.".config/qt6ct/qss/neobrutalist.qss".text = ''
    /* Neo-brutalist Qt6 stylesheet */
    
    /* Main window */
    QMainWindow {
        background-color: #FFBE0B;
        color: #000000;
    }
    
    /* Buttons */
    QPushButton {
        background-color: #FFBE0B;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 6px 12px;
        font-weight: bold;
        min-height: 20px;
    }
    
    QPushButton:hover {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    QPushButton:pressed {
        background-color: #000000;
        color: #FFBE0B;
    }
    
    /* List views and tree views */
    QListView, QTreeView, QTableView {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        selection-background-color: #FF006E;
        selection-color: #FFFFFF;
    }
    
    QListView::item:selected, QTreeView::item:selected {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    QListView::item:hover, QTreeView::item:hover {
        background-color: #FFB700;
        color: #000000;
    }
    
    /* Tool bars */
    QToolBar {
        background-color: #FFBE0B;
        border: 2px solid #000000;
        spacing: 2px;
    }
    
    QToolButton {
        background-color: #FFBE0B;
        color: #000000;
        border: 2px solid #000000;
        border-radius: 0px;
        padding: 4px;
        font-weight: bold;
    }
    
    QToolButton:hover {
        background-color: #FF006E;
        color: #FFFFFF;
    }
    
    /* Address bar and line edits */
    QLineEdit {
        background-color: #FFFFFF;
        color: #000000;
        border: 3px solid #000000;
        border-radius: 0px;
        padding: 6px;
    }
    
    QLineEdit:focus {
        border-color: #FF006E;
    }
    
    /* Make all icons appear more muted/grey */
    QAbstractItemView::item {
        color: #000000;
    }
    
    /* Override folder icon colors specifically */
    QListView::icon[name*="folder"], QTreeView::icon[name*="folder"] {
        color: #808080;
    }
  '';
  
  # Override Adwaita folder icons with grey versions
  home.file.".local/share/icons/Adwaita/scalable/places/folder.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <rect x="8" y="20" width="48" height="32" 
            fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  home.file.".local/share/icons/Adwaita/scalable/places/folder-open.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <polygon points="8,20 54,20 50,50 8,50" 
               fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  # Custom folder icons (grey, minimal style) - backup theme
  home.file.".local/share/icons/neobrutalist/index.theme".text = ''
    [Icon Theme]
    Name=Neo-Brutalist
    Comment=Simple grey folders for neo-brutalist theme
    Inherits=Adwaita,hicolor
    Directories=places/scalable
    
    [places/scalable]
    Size=64
    Context=Places
    Type=Scalable
    MinSize=16
    MaxSize=512
  '';
  
  # Create simple grey folder SVG - minimal neo-brutalist design
  home.file.".local/share/icons/neobrutalist/places/scalable/folder.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <rect x="8" y="20" width="48" height="32" 
            fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  # Open folder variant - simpler design
  home.file.".local/share/icons/neobrutalist/places/scalable/folder-open.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <polygon points="8,20 54,20 50,50 8,50" 
               fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  # Additional folder variants for better coverage
  home.file.".local/share/icons/neobrutalist/places/scalable/folder-documents.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <rect x="8" y="20" width="48" height="32" 
            fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  home.file.".local/share/icons/neobrutalist/places/scalable/folder-download.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <rect x="8" y="20" width="48" height="32" 
            fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';
  
  home.file.".local/share/icons/neobrutalist/places/scalable/folder-pictures.svg".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <rect x="8" y="20" width="48" height="32" 
            fill="#808080" stroke="#000000" stroke-width="3"/>
      <rect x="8" y="16" width="20" height="8" 
            fill="#808080" stroke="#000000" stroke-width="2"/>
    </svg>
  '';

  # Environment variables for Qt (use mkForce to override home-manager defaults)
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_STYLE_OVERRIDE = lib.mkForce "Fusion";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_PATH = "$HOME/.local/share/icons:$XCURSOR_PATH";
  };
}