# BovinoCheck → Android APK con Bubblewrap (TWA)

**Tiempo estimado**: 30-45 min la primera vez, 5 min en builds siguientes.

**Qué obtienes**: APK firmado instalable en cualquier Android 5.0+, con icono propio en el launcher, modo standalone (sin barra del navegador), funciona offline. Tamaño ~3 MB.

**Cómo funciona TWA (Trusted Web Activity)**: Android empaqueta un Chrome Custom Tab a pantalla completa que carga tu PWA hosteada. NO es un WebView (mejor performance, todas las APIs web modernas).

---

## 1. Prerequisitos (instalar una sola vez)

```bash
# Node 18+
node --version  # → 18.x o superior

# Java 17 JDK (OpenJDK)
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# Bubblewrap CLI
npm install -g @bubblewrap/cli

# Android SDK (Bubblewrap lo instala automáticamente la primera vez)
bubblewrap doctor
```

## 2. Hostear la PWA con HTTPS (REQUISITO Bubblewrap)

TWA requiere que tu PWA esté en HTTPS. Tres opciones:

### Opción A — GitHub Pages (gratis, recomendado)
```bash
cd /Users/andree/Library/CloudStorage/.../BovinoCheck/src

# Crea repo en github.com/andree-utmach/bovinocheck
git init && git add -A && git commit -m "init"
git remote add origin git@github.com:andree-utmach/bovinocheck.git
git push -u origin main

# Activa GitHub Pages en Settings → Pages → Branch: main, Folder: /
# Tu app vivirá en: https://andree-utmach.github.io/bovinocheck/
```

### Opción B — Netlify drop (1 clic, gratis)
1. Ve a https://app.netlify.com/drop
2. Arrastra la carpeta `src/`
3. Te dan una URL `https://random-name.netlify.app`

### Opción C — Forgejo Beelink (control total)
Sirve `src/` desde nginx en `100.91.122.11:443` con certificado Let's Encrypt vía Tailscale Funnel.

## 3. Generar el proyecto Android

```bash
cd /Users/andree/Library/CloudStorage/.../BovinoCheck/android

# Inicia el wizard (responde las preguntas)
bubblewrap init --manifest https://andree-utmach.github.io/bovinocheck/manifest.json
```

**Respuestas sugeridas al wizard:**

| Pregunta | Respuesta |
|---|---|
| Application name | `BovinoCheck AI Pro` |
| Short name | `BovinoCheck` |
| Application ID | `ec.utmach.bovinocheck` |
| Start URL | `/v7.5.html` |
| Display mode | `standalone` |
| Orientation | `portrait` |
| Theme color | `#065f46` |
| Background color | `#f8fafc` |
| Icon URL | `https://andree-utmach.github.io/bovinocheck/icon-512.png` |
| Splash color | `#065f46` |
| Signing key location | `./android.keystore` (acepta default) |
| Signing key alias | `bovinocheck` |
| Password | **¡guarda esto en tu password manager!** |

## 4. Build del APK

```bash
bubblewrap build
# → genera app-release-signed.apk en el directorio actual
```

## 5. Instalar en dispositivo

```bash
# USB debugging activado en el celular
adb install app-release-signed.apk

# O envía el APK por WhatsApp/email/Drive y abre en el teléfono
# (Necesita "Instalar apps de fuentes desconocidas" activado)
```

## 6. Verificación Digital Asset Links (CRÍTICO para que TWA no muestre la barra)

Bubblewrap genera un archivo `assetlinks.json`. Súbelo a:
```
https://andree-utmach.github.io/.well-known/assetlinks.json
```

Sin esto, la app abre pero muestra la URL en la parte superior (parece browser, no app nativa).

Verifica con:
```bash
curl https://andree-utmach.github.io/.well-known/assetlinks.json
```

## 7. Publicar en Play Store (opcional, US$25 una vez)

```bash
bubblewrap build --signingKeyPath ./android.keystore --signingKeyAlias bovinocheck
# El AAB generado se sube en https://play.google.com/console
```

**Requisitos Play Store para apps médicas/veterinarias:**
- Política de privacidad pública (texto + URL)
- Declaración de uso de cámara
- Si manejas datos sensibles: declaración Health Data
- Disclaimer "no sustituye criterio clínico"

---

## Alternativas a Bubblewrap (si quieres APIs nativas avanzadas)

### Capacitor (Ionic)
Más control. Acceso a cámara nativa (mejor que web getUserMedia), filesystem, BLE para tags RFID, etc. Útil para V8.0 cuando integremos pose estimation con TFLite nativo.

```bash
npm install -g @capacitor/cli
npx cap init BovinoCheck ec.utmach.bovinocheck --web-dir=../src
npx cap add android
npx cap sync android
npx cap open android  # abre Android Studio
```

### PWA Builder (Microsoft, online)
https://www.pwabuilder.com/ — pega tu URL, te genera APK/AAB sin tocar terminal. Más cómodo pero menos control.

---

## Notas específicas BovinoCheck

1. **API key**: la app pide la key de Gemini al primer uso. NO la incluyas en el APK — el usuario la configura en el dispositivo.
2. **Permisos**: el manifest pide solo cámara (vía web). Bubblewrap no añade permisos adicionales por defecto.
3. **Datos clínicos**: IndexedDB local, NO se sincronizan. Si se quiere sync hato → backend, se agrega en V8.0.
4. **Updates**: cada cambio en HTML/JS/CSS se refleja al abrir la app (TWA carga remoto). El APK solo cambia si modificas manifest/icons/configs.

---

## Troubleshooting

- **"Java 17 not found"**: confirma `/usr/libexec/java_home -v 17` devuelve un path. Si no, reinstala con `brew reinstall openjdk@17` y reaplica el symlink.
- **"assetlinks verification failed"**: TWA muestra URL bar. Solución: subir `assetlinks.json` exactamente en `/.well-known/assetlinks.json` con MIME `application/json`.
- **APK rechaza instalar**: activar "Instalar desconocidas" + firma debe ser consistente (no recrear el keystore entre builds).
- **App offline solo carga app shell**: el SW está cacheando solo recursos. Las llamadas a Gemini necesitan red — esto es esperado.

---

**Referencias**:
- Bubblewrap docs: https://github.com/GoogleChromeLabs/bubblewrap
- TWA quick start: https://developer.chrome.com/docs/android/trusted-web-activity/
- Capacitor docs: https://capacitorjs.com/docs
