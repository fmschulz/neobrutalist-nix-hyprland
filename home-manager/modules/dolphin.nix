{ config, pkgs, lib, ... }:

{
  # Dolphin configuration for neo-brutalist theme
  home.file.".config/dolphinrc".text = ''
    [General]
    Version=202
    ViewPropsTimestamp=2024,7,8,19,50,0.000

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled
    ToolBarsMovable=Disabled

    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail,ffmpegthumbnail

    [IconsMode]
    PreviewSize=64

    [CompactMode]
    PreviewSize=32

    [DetailsMode]
    PreviewSize=32

    [ViewPropertiesDialog]
    geometry=@ByteArray()
  '';

  # Override folder colors via KDE color scheme
  home.file.".local/share/color-schemes/NeoBrutalist.colors".text = ''
    [ColorEffects:Disabled]
    Color=56,56,56
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=112,111,110
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=255,190,11
    BackgroundNormal=255,190,11
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [Colors:Complementary]
    BackgroundAlternate=255,190,11
    BackgroundNormal=255,190,11
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [Colors:Header]
    BackgroundAlternate=255,190,11
    BackgroundNormal=255,190,11
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [Colors:Selection]
    BackgroundAlternate=255,0,110
    BackgroundNormal=255,0,110
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,255,255
    ForegroundInactive=255,255,255
    ForegroundLink=255,255,255
    ForegroundNegative=255,255,255
    ForegroundNeutral=255,255,255
    ForegroundNormal=255,255,255
    ForegroundPositive=255,255,255
    ForegroundVisited=255,255,255

    [Colors:Tooltip]
    BackgroundAlternate=255,190,11
    BackgroundNormal=255,190,11
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [Colors:View]
    BackgroundAlternate=255,255,255
    BackgroundNormal=255,255,255
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [Colors:Window]
    BackgroundAlternate=255,190,11
    BackgroundNormal=255,190,11
    DecorationFocus=255,0,110
    DecorationHover=255,0,110
    ForegroundActive=255,0,110
    ForegroundInactive=128,128,128
    ForegroundLink=49,133,252
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=0,0,0
    ForegroundPositive=39,174,96
    ForegroundVisited=155,89,182

    [General]
    ColorScheme=NeoBrutalist
    Name=Neo-Brutalist
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground=255,190,11
    activeForeground=0,0,0
    inactiveBackground=255,190,11
    inactiveForeground=128,128,128
  '';

  # Simple approach: Just change the folder icon color via CSS filter
  home.file.".config/dolphin/dolphinrc".text = ''
    [General]
    Version=202
    
    [IconsMode]
    PreviewSize=64
    
    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22
    
    [MainWindow]
    MenuBar=Disabled
    ToolBarsMovable=Disabled
    
    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail,ffmpegthumbnail
  '';
}