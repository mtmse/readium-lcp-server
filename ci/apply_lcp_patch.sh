#!/bin/bash
set -euo pipefail

# Förvänta oss att få både secure file path och LCP server source path
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <path-to-secure-file> <lcp-server-src>"
  exit 1
fi

SECURE_FILE_PATH="$1"
LCP_SERVER_SRC="$2"
PATCHER_DIR="ci/lcp-patcher-v1p2"
PLATFORM="linux-x64"      # Ändra till rätt plattform om nödvändigt

echo "Använder LCP server source: $LCP_SERVER_SRC"

echo "Using secure file from: $SECURE_FILE_PATH"

# Radera eventuell befintlig patcher-mapp och skapa en ny
rm -rf "$PATCHER_DIR"
mkdir -p "$PATCHER_DIR"

# Kontrollera att 7z är installerat
if ! command -v 7z &> /dev/null; then
    echo "7z-kommandot kunde inte hittas. Installera p7zip (t.ex. p7zip-full) och försök igen."
    exit 1
fi

# Kontrollera att lösenordet är satt
if [ -z "${LCP_PATCHER_PASSWORD:-}" ]; then
    echo "Miljövariabeln LCP_PATCHER_PASSWORD är inte satt! Sätt den till rätt lösenord för patch-arkivet."
    exit 1
fi

echo "Extraherar patch-arkivet..."
7z x "$SECURE_FILE_PATH" -o"$PATCHER_DIR" -p"$LCP_PATCHER_PASSWORD" -y
echo "Extraktion slutförd."

# Ta bort den interaktiva prompten i install.sh
sed -i '/read -p/d' "$PATCHER_DIR/install.sh"

echo "Kör install.sh med LCP serverns källkod ($LCP_SERVER_SRC) och plattform ($PLATFORM)..."
chmod +x "$PATCHER_DIR/install.sh"
"$PATCHER_DIR/install.sh" "$LCP_SERVER_SRC" "$PLATFORM"

echo "LCP Patch har applicerats framgångsrikt!"
