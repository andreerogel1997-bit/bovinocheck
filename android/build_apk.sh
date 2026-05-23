#!/usr/bin/env bash
# build_apk.sh — genera el APK firmado de BovinoCheck sin prompts interactivos.
#
# Requisitos:
#   - macOS con Keychain entry 'bovinocheck-keystore' (creado una sola vez)
#   - Java 17 (brew install openjdk@17)
#   - bubblewrap CLI (npm install -g @bubblewrap/cli)
#   - Internet (descarga Android SDK ~1GB primera vez)
#
# El keystore se guarda en ~/.bovinocheck-credentials/ (fuera del repo).
# La password del keystore vive en macOS Keychain (jamás en archivo).

set -euo pipefail

cd "$(dirname "$0")"

export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17}"
export PATH="$JAVA_HOME/bin:$PATH"

if ! command -v java >/dev/null; then
    echo "ERROR: java no encontrado. JAVA_HOME=$JAVA_HOME"
    echo "Instala con: brew install openjdk@17"
    exit 1
fi
if ! command -v bubblewrap >/dev/null; then
    echo "ERROR: bubblewrap no instalado."
    echo "Instala con: npm install -g @bubblewrap/cli"
    exit 1
fi

# Recupera password del Keychain (no echo)
KEYSTORE_PASS=$(security find-generic-password -a bovinocheck-keystore -s bovinocheck-keystore -w 2>/dev/null) || {
    echo "ERROR: no se encontró 'bovinocheck-keystore' en Keychain."
    echo "Crear con: security add-generic-password -a bovinocheck-keystore -s bovinocheck-keystore -w 'tu-password'"
    exit 1
}

KEYSTORE_DIR="$HOME/.bovinocheck-credentials"
KEYSTORE_PATH="$KEYSTORE_DIR/android.keystore"
mkdir -p "$KEYSTORE_DIR"
chmod 700 "$KEYSTORE_DIR"

BUILD_DIR="build"
cd "$BUILD_DIR"

# 1. Generar keystore propio si no existe (no-interactive)
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "→ Generando keystore en $KEYSTORE_PATH..."
    keytool -genkeypair -v \
        -keystore "$KEYSTORE_PATH" \
        -alias bovinocheck \
        -keyalg RSA -keysize 2048 -validity 36500 \
        -storepass "$KEYSTORE_PASS" \
        -keypass "$KEYSTORE_PASS" \
        -dname "CN=BovinoCheck AI Pro, OU=UTMACH Veterinaria, O=Andree Vitonera, L=Machala, ST=El Oro, C=EC" \
        -storetype PKCS12 2>&1
    chmod 600 "$KEYSTORE_PATH"
    echo "✓ Keystore generado"
fi

# 2. Init project si no existe
if [ ! -f gradlew ]; then
    echo "→ Initializing TWA project (descarga Android SDK ~1GB primera vez)..."
    # Bubblewrap necesita el twa-manifest.json en este dir (ya está)
    # Para no entrar al wizard, pasamos --manifest del web manifest
    bubblewrap init \
        --manifest="https://andreerogel1997-bit.github.io/bovinocheck/manifest.json" \
        --directory=. 2>&1
fi

# 3. Build APK firmado (feed passwords via stdin)
echo "→ Building APK firmado..."
printf '%s\n%s\n' "$KEYSTORE_PASS" "$KEYSTORE_PASS" | bubblewrap build --skipPwaValidation 2>&1

# 4. Reporte
if [ -f app-release-signed.apk ]; then
    APK_SIZE=$(du -h app-release-signed.apk | cut -f1)
    APK_PATH=$(pwd)/app-release-signed.apk
    echo ""
    echo "==========================================="
    echo "✓ APK firmado: $APK_PATH ($APK_SIZE)"
    echo "==========================================="
    echo ""
    echo "Próximo paso: instalar en celular Android"
    echo "  adb install $APK_PATH"
    echo "  (o copia el APK al celular y abre, acepta 'fuentes desconocidas')"
fi

unset KEYSTORE_PASS
