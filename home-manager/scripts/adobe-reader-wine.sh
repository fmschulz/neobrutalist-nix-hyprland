#!/usr/bin/env bash
# Adobe Reader DC installer script for Wine

set -euo pipefail

WINE_PREFIX="$HOME/.wine-adobe-reader"
ADOBE_READER_URL="https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820555/AcroRdrDC2300820555_en_US.exe"
INSTALLER_PATH="$HOME/.cache/adobe-reader-installer.exe"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Adobe Reader Wine Setup${NC}"
echo "=============================="

# Create Wine prefix if it doesn't exist
if [ ! -d "$WINE_PREFIX" ]; then
    echo -e "${YELLOW}Creating Wine prefix at $WINE_PREFIX...${NC}"
    WINEPREFIX="$WINE_PREFIX" winecfg -v win10
fi

# Download Adobe Reader installer if not already downloaded
if [ ! -f "$INSTALLER_PATH" ]; then
    echo -e "${YELLOW}Downloading Adobe Reader DC installer...${NC}"
    mkdir -p "$(dirname "$INSTALLER_PATH")"
    curl -L -o "$INSTALLER_PATH" "$ADOBE_READER_URL"
else
    echo -e "${GREEN}Adobe Reader installer already downloaded.${NC}"
fi

# Install required Windows components
echo -e "${YELLOW}Installing required Windows components...${NC}"
WINEPREFIX="$WINE_PREFIX" winetricks -q atmlib corefonts vcrun2019 fontsmooth=rgb

# Install Adobe Reader
echo -e "${YELLOW}Installing Adobe Reader DC...${NC}"
echo -e "${YELLOW}Note: Click through the installer. Uncheck any unwanted options.${NC}"
WINEPREFIX="$WINE_PREFIX" wine "$INSTALLER_PATH"

# Create launcher script
LAUNCHER_PATH="$HOME/.local/bin/adobe-reader"
cat > "$LAUNCHER_PATH" << 'EOF'
#!/usr/bin/env bash
WINEPREFIX="$HOME/.wine-adobe-reader" wine "$HOME/.wine-adobe-reader/drive_c/Program Files (x86)/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe" "$@"
EOF

chmod +x "$LAUNCHER_PATH"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "You can now run Adobe Reader with: ${GREEN}adobe-reader${NC}"
echo -e "Or open a PDF directly: ${GREEN}adobe-reader document.pdf${NC}"

# Create desktop entry
DESKTOP_ENTRY="$HOME/.local/share/applications/adobe-reader-wine.desktop"
mkdir -p "$(dirname "$DESKTOP_ENTRY")"
cat > "$DESKTOP_ENTRY" << EOF
[Desktop Entry]
Name=Adobe Reader (Wine)
Comment=View PDF documents
Exec=$HOME/.local/bin/adobe-reader %f
Icon=AdobeReader
Terminal=false
Type=Application
Categories=Office;Viewer;
MimeType=application/pdf;
EOF

echo -e "${GREEN}Desktop entry created. Adobe Reader should appear in your application menu.${NC}"