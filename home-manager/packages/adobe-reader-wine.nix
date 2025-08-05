{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "adobe-reader-wine";
  version = "2023.008.20555";
  
  # Adobe Reader DC installer
  src = pkgs.fetchurl {
    url = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820555/AcroRdrDC2300820555_en_US.exe";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
  };
  
  nativeBuildInputs = with pkgs; [
    wineWowPackages.stable
    winetricks
    makeWrapper
  ];
  
  unpackPhase = "true";
  
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    
    # Create wrapper script
    makeWrapper ${pkgs.wineWowPackages.stable}/bin/wine $out/bin/adobe-reader-wine \
      --set WINEPREFIX "$HOME/.wine-adobe-reader" \
      --add-flags "$HOME/.wine-adobe-reader/drive_c/Program Files (x86)/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe" \
      --add-flags '"$@"'
    
    # Create desktop entry
    cat > $out/share/applications/adobe-reader-wine.desktop << EOF
    [Desktop Entry]
    Name=Adobe Reader (Wine)
    Comment=View PDF documents
    Exec=$out/bin/adobe-reader-wine %f
    Icon=AdobeReader
    Terminal=false
    Type=Application
    Categories=Office;Viewer;
    MimeType=application/pdf;
    EOF
  '';
  
  meta = with lib; {
    description = "Adobe Reader DC running under Wine";
    homepage = "https://www.adobe.com/acrobat/pdf-reader.html";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}