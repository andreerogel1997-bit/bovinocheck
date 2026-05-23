# Política de Privacidad — BovinoCheck AI Pro

**Última actualización**: 22 de mayo de 2026
**Aplica a**: BovinoCheck AI Pro v7.5 y v8.0 (web, PWA, Android APK)

---

## 1. Identidad del responsable

**Responsable**: Mvz. Ronald Andreé Vitonera Rogel, MSc. — Universidad Técnica de Machala (UTMACH), Facultad de Ciencias Agropecuarias, El Oro, Ecuador.
**Contacto**: andreerogel1997@gmail.com
**Repositorio público del código**: https://github.com/andreerogel1997-bit/bovinocheck

BovinoCheck AI Pro es una aplicación académica desarrollada como proyecto integrador de estudiantes de UTMACH, supervisada por el responsable mencionado. No es un producto comercial.

---

## 2. ¿Qué datos recopila la aplicación?

### 2.1 Datos que se almacenan localmente en tu dispositivo (NUNCA salen)

- **Número de arete** del animal (texto introducido por el usuario).
- **Tipo de raza** seleccionado (Holstein, Cebú, Mixto).
- **Foto o video** capturado del animal.
- **Resultado del análisis** devuelto por la inteligencia artificial (grado de cojera, recomendación, etc.).
- **Fecha y hora** de la evaluación.
- **Configuración de la app** (API key personal del usuario, modelo Gemini elegido).

Todos estos datos se guardan en la **base de datos local del navegador** (IndexedDB) del propio dispositivo. **No se envían a ningún servidor del responsable.**

### 2.2 Datos que se envían a Google

Cuando el usuario solicita un análisis con IA, **solamente la foto/video y el número de arete** se transmiten directamente desde el dispositivo del usuario a los servidores de **Google AI (Gemini API)** para procesamiento. Esta transmisión:

- Usa **la API key personal del propio usuario**, no una clave compartida.
- Está sujeta a la **Política de Privacidad de Google** ([https://policies.google.com/privacy](https://policies.google.com/privacy)) y a los **Términos de la Gemini API** ([https://ai.google.dev/terms](https://ai.google.dev/terms)).
- El responsable de BovinoCheck **no tiene acceso** a estos datos ni los almacena.

### 2.3 Datos que NO se recopilan

- ❌ No se recopilan datos personales del usuario (nombre, correo, ubicación, edad, etc.).
- ❌ No se usan cookies de seguimiento, analytics, ni publicidad de terceros.
- ❌ No se envían datos a servidores propios del responsable.
- ❌ No se identifica al animal con datos sensibles (la app trabaja únicamente con un número de arete asignado libremente por el usuario).
- ❌ No se recopila ubicación GPS.

---

## 3. Permisos del dispositivo y para qué se usan

| Permiso | Razón de uso |
|---|---|
| **Cámara** | Capturar fotos o video del animal para el análisis. Se accede solo cuando el usuario pulsa el botón correspondiente. |
| **Micrófono** (opcional) | Reconocimiento de voz para introducir el número de arete por dictado. Solo se activa al pulsar el botón de micrófono. El audio se procesa localmente vía Web Speech API del navegador, no se graba ni se transmite. |
| **Almacenamiento** | Guardar las evaluaciones localmente (IndexedDB). Permanece en el dispositivo. |

---

## 4. Tiempo de retención

Los datos persisten en el dispositivo del usuario **mientras la aplicación esté instalada y el almacenamiento no sea borrado**. El usuario puede borrar todos los datos en cualquier momento desde **Configuración → Borrar todos los registros**.

Si el usuario desinstala la aplicación, todos los datos locales se eliminan automáticamente con ella.

---

## 5. Derechos del usuario

El usuario tiene en todo momento el derecho a:

- **Acceder** a todos sus datos: visibles en las pestañas "Estadísticas" y "Buscar".
- **Exportar** sus datos en formato JSON: Configuración → Exportar evaluaciones.
- **Rectificar** o **borrar** cualquier evaluación individual o el conjunto completo.
- **Portabilidad**: el JSON exportado es legible por cualquier herramienta estándar.
- **Limitar** el procesamiento: simplemente no usar la función de análisis con IA (la app sigue funcionando como registro manual).

Para ejercer cualquiera de estos derechos, ya están disponibles directamente desde la app. Si necesita asistencia, contacte a andreerogel1997@gmail.com.

---

## 6. Datos de animales y bienestar animal

La aplicación trabaja exclusivamente con **datos de bovinos** y no con datos humanos sensibles. No obstante, los registros sobre el estado de salud animal pueden tener relevancia clínica y comercial para el propietario del hato. Por ello:

- El usuario es responsable de obtener autorización del propietario del animal antes de evaluar y registrar.
- Los datos no deben usarse para fines comerciales sin acuerdo expreso.
- La app **no sustituye el criterio veterinario profesional**.

---

## 7. Seguridad

- La API key personal del usuario se almacena cifrada en el almacenamiento local del navegador (IndexedDB) y nunca se transmite excepto a los servidores oficiales de Google.
- Las transmisiones a Google AI se realizan exclusivamente por HTTPS.
- El código fuente es **abierto y auditable** en GitHub: https://github.com/andreerogel1997-bit/bovinocheck
- Las dependencias se sirven por HTTPS desde CDNs reconocidos.

A pesar de las medidas, ningún sistema es 100 % seguro. Si detecta una vulnerabilidad, repórtela a andreerogel1997@gmail.com.

---

## 8. Menores de edad

La aplicación está dirigida a profesionales veterinarios y zootécnicos mayores de edad. No está pensada para uso por menores y no recopila intencionalmente datos de menores. Si se detecta uso por menores, los padres o tutores pueden solicitar borrado contactando al responsable.

---

## 9. Disclaimer médico/veterinario

> BovinoCheck AI Pro es una **herramienta de soporte a la decisión**, no un sistema de diagnóstico definitivo. Cualquier decisión clínica relevante debe ser confirmada mediante examen presencial por un médico veterinario zootecnista colegiado. El responsable y los desarrolladores **no asumen responsabilidad** por decisiones clínicas, productivas o de bienestar animal tomadas a partir del uso de la aplicación.

---

## 10. Cambios a esta política

Esta política puede actualizarse para reflejar mejoras de la aplicación o cambios regulatorios. Los cambios se reflejarán siempre en el repositorio público (commit visible) y en la versión publicada en:

**https://andreerogel1997-bit.github.io/bovinocheck/PRIVACY.html**

El uso continuado de la aplicación tras una actualización implica aceptación de la versión vigente.

---

## 11. Marco legal aplicable

Esta política se interpreta conforme a la **Ley Orgánica de Protección de Datos Personales del Ecuador** (LOPDP, 2021), y considera los principios del **Reglamento General de Protección de Datos** (RGPD/UE 2016/679) para usuarios fuera de Ecuador.

---

**Cualquier consulta**: andreerogel1997@gmail.com — Mvz. Ronald Andreé Vitonera Rogel, UTMACH.
