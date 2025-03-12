#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-secure-cert-file>"
    exit 1
fi

SECURE_CERT_FILE="$1"
EXTRACT_DIR="ci/prod-certs"

echo "Extraherar produktionscertifikat från: $SECURE_CERT_FILE"
rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

# Kontrollera att 7z finns
if ! command -v 7z &> /dev/null; then
    echo "7z-kommandot kunde inte hittas. Installera p7zip (t.ex. p7zip-full) och försök igen."
    exit 1
fi

# Om inget lösenord krävs kan du sätta PROD_CERT_PASSWORD till en tom sträng
7z x "$SECURE_CERT_FILE" -o"$EXTRACT_DIR" -p"${PROD_CERT_PASSWORD:-}" -y

echo "Extraktion klar."

# Ange mappen där filerna ska kopieras
DEST_CERT_DIR="app/cert"
mkdir -p "$DEST_CERT_DIR"

# Hitta .pem-filerna (förväntar oss att det finns minst två)
pem_files=($(find "$EXTRACT_DIR" -type f -name "*.pem"))
if [ ${#pem_files[@]} -lt 2 ]; then
    echo "Kunde inte hitta två .pem filer i $EXTRACT_DIR"
    exit 1
fi

# Använd de två första .pem-filerna: 
# Första filen antas vara certifikatet och andra filen den privata nyckeln.
CERT_FILE="${pem_files[0]}"
KEY_FILE="${pem_files[1]}"

echo "Kopierar certifikat från $CERT_FILE till $DEST_CERT_DIR/cert-provider-prod.pem"
cp "$CERT_FILE" "$DEST_CERT_DIR/cert-mtm.pem"
echo "Kopierar nyckel från $KEY_FILE till $DEST_CERT_DIR/privkey-provider-prod.pem"
cp "$KEY_FILE" "$DEST_CERT_DIR/privkey-mtm.pem"

echo "Produktionscertifikat och nyckel har kopierats framgångsrikt!"
