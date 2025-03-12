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

# Förutsätt att arkivet innehåller ett .pem- och ett .key-fil.
# Ange mappen där filerna ska kopieras. Här antar vi att du vill lägga dem i test/cert för att sedan
# (vid behov) ändra Dockerfile eller config så att produktionsfilerna används.
DEST_CERT_DIR="test/cert"
mkdir -p "$DEST_CERT_DIR"

# Hitta .pem- och .key-filerna (anpassa mönstret om filnamnen är specifika)
CERT_FILE=$(find "$EXTRACT_DIR" -type f -name "*.pem" | head -n 1)

if [ -z "$CERT_FILE" ]; then
    echo "Kunde inte hitta certifikat- eller nyckelfil i $EXTRACT_DIR"
    exit 1
fi

echo "Kopierar certifikat från $CERT_FILE till $DEST_CERT_DIR/cert-provider-prod.pem"
cp "$CERT_FILE" "$DEST_CERT_DIR/cert-provider-prod.pem"
echo "Kopierar nyckel från $KEY_FILE till $DEST_CERT_DIR/privkey-provider-prod.pem"
cp "$KEY_FILE" "$DEST_CERT_DIR/privkey-provider-prod.pem"

echo "Produktionscertifikat och nyckel har kopierats framgångsrikt!"
