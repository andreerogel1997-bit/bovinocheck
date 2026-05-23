# 🧪 Guía de Testers — BovinoCheck AI Pro

> Para los alumnos del proyecto integrador Unidades III-V · UTMACH 2026

---

## 1. Antes de empezar

**Lo que necesitas tener**:

- Celular Android 5.0+ (la mayoría de Android de los últimos 8 años sirve)
- Conexión a internet (al menos para el primer uso y para los análisis)
- Acceso a una vaca real para fotografiar/grabar (mejor varias, ver §4)
- Una API key gratis de Google AI Studio (5 min, ver §3)

**Lo que NO necesitas**: cuenta de la app, pago, registro. Todo es local y gratis.

---

## 2. Cómo instalar el APK

### Ruta A — Descarga directa (más fácil)

1. En tu celular Android, abre el enlace que el tutor te comparta por WhatsApp/Drive.
2. Descarga `BovinoCheck AI.apk`.
3. Al abrirlo, Android te dirá "*Por seguridad, tu teléfono no permite instalar apps desconocidas*".
4. Pulsa **Configuración** → activa **"Permitir desde esta fuente"** (solo para WhatsApp o el navegador que usaste).
5. Vuelve atrás y pulsa **Instalar**.
6. Aparece `BovinoCheck` en tu launcher con icono verde.

### Ruta B — Si la Ruta A falla

Abre Chrome y entra a: https://andreerogel1997-bit.github.io/bovinocheck/

En el menú ⋮ → **"Instalar app"** o **"Agregar a pantalla principal"**. Chrome la empaqueta automáticamente. Funcionalmente es idéntica al APK.

---

## 3. Configurar tu API key de Google AI (5 min, gratis)

1. Abre https://aistudio.google.com/apikey en tu celular o computadora.
2. Inicia sesión con cualquier cuenta Google.
3. Pulsa **"Create API key"** → **"Create API key in new project"**.
4. Copia la cadena que aparece (algo como `AIzaSy...`).
5. Abre la app BovinoCheck.
6. Pulsa el icono ⚙ arriba a la derecha.
7. Pega la API key en el campo correspondiente.
8. Pulsa **"Probar conexión"** — debe decir ✓.
9. Pulsa **"Guardar"**.

**Cuota gratis**: 1,500 análisis por día por API key. Más que suficiente para testing.

---

## 4. Qué probar (Plan de Testing)

### 🎯 Objetivo del testing
Confirmar que la app diagnostica correctamente vacas reales en condiciones de campo, no en laboratorio.

### 4.1 Captura de vacas (mínimo recomendado)

Intenta capturar al menos **5 vacas diferentes** en distintos grados:

| Grado a buscar | Cuántas | Cómo identificarlas |
|---|---|---|
| **G1 Normal** | 2 | Lomo recto, paso largo, sin cojera visible |
| **G2 Leve** | 1 | Lomo arqueado solo al caminar |
| **G3 Moderada** | 1 | Lomo arqueado parada y caminando |
| **G4-G5 Severa** | 1 (si hay) | Cojea evidente, casi no apoya una pata |

### 4.2 Cómo grabar bien

- **Lateral**: vaca caminando en línea recta vista de costado (NO de frente o trasera).
- **8-10 pasos**: necesitamos al menos 8 pasos visibles para análisis dinámico.
- **Plano**: superficie de pasto firme o cemento, NO barro profundo.
- **Sin obstrucciones**: que se vea el lomo y las 4 patas completas.
- **Luz natural**: evita contraluz directo (la vaca oscura sobre cielo brillante).
- **Estable**: pon el celular apoyado o usa ambas manos, evita videos temblorosos.

### 4.3 Para cada vaca, en la app

1. Selecciona la pestaña **Analizar**.
2. Ingresa el **arete** (cualquier identificador que se reconozca después).
3. Selecciona el **tipo de ganado** (default Cebú en El Oro).
4. Pulsa **Video** (mejor que foto) o **Cámara**.
5. Graba 5-10 segundos o saca la foto.
6. Pulsa **Lanzar agentes IA**.
7. Espera el resultado (5-15 seg).
8. **Anota** en tu cuaderno o el Google Form (link más abajo):
   - El grado que devolvió la IA
   - El grado que TÚ crees que tiene la vaca (lo que viste en vivo)
   - Si coinciden o no, y por qué

---

## 5. Qué bugs/observaciones reportar

Repórtanos **TODO** lo que veas raro. Es valiosísimo para el paper. Categorías:

### 🐛 Bugs técnicos
- La app se cierra sola.
- La pantalla se queda en blanco.
- El botón no responde.
- El análisis nunca termina (>2 min esperando).
- Error mostrado en pantalla.
- El PDF no se descarga o sale en blanco.

### 🧠 Errores de IA
- La IA dice **G2** pero la vaca claramente está **G4** (o viceversa).
- La IA no encuentra evidencia obvia (ej. cojera severa pero "evidence" está vacío).
- La descripción del análisis es genérica o no menciona lo que ves.

### 📱 Problemas de uso (UX)
- No entiendes qué hace un botón.
- El texto es muy pequeño bajo el sol.
- Botones difíciles de pulsar con guantes.
- Tarda demasiado en cargar.

### 💡 Sugerencias
- "Sería útil si..." → cualquier idea.

---

## 6. Cómo enviar el feedback

**Opción rápida** (recomendada): pulsa el botón "Exportar evaluaciones (JSON)" en ⚙ Configuración → manda el `.json` al tutor por WhatsApp + escribe tus observaciones.

**Opción detallada**: llena el Google Form que el tutor compartirá (link a definir antes del 5 jun).

**Plazo**: hasta **15 de julio de 2026** para entregar tu testing antes del cierre del proyecto integrador (20 jul).

---

## 7. Datos importantes para el paper futuro

Si tu testing produce **al menos 20 vacas evaluadas** con buena variedad de grados, **TU NOMBRE APARECE COMO CO-AUTOR** en el paper que publicaremos. Es ciencia real — no es tarea simulada.

Lo que se busca medir:
- Concordancia entre lo que la IA dice y lo que un humano (tú) ve = **κ de Cohen**
- Sensibilidad y especificidad por grado
- Performance específica en Cebú tropical El Oro (nadie ha hecho esto, ése es el aporte original)

---

## 8. Privacidad y ética

- Los datos se guardan en TU celular, no se suben a ningún servidor del tutor.
- Solo la foto/video va a Google AI para análisis (con tu propia API key).
- Pide autorización al dueño del hato antes de fotografiar las vacas.
- Si exportas tu JSON al tutor, es libre y voluntario — puedes exportar sin cierta vaca si quieres.
- Política completa: https://andreerogel1997-bit.github.io/bovinocheck/PRIVACY.html

---

## 9. Disclaimer académico

Esta app es **soporte a la decisión, no sustituye al MVZ**. Si encuentras una vaca G4 o G5 reportala al propietario y al MVZ del hato — no decidas tratamientos solo con el output de la IA.

---

## 10. Contacto

- Tutor: **Mvz. Andreé Vitonera Rogel, MSc.** — UTMACH
- Email: andreerogel1997@gmail.com
- Issues técnicos: https://github.com/andreerogel1997-bit/bovinocheck/issues

---

**¡Gracias por testear!** Cada evaluación tuya nos acerca al paper Q1.
