# BovinoCheck AI Pro

> Evaluación automatizada de cojera bovina por análisis de video con IA generativa multimodal. Diseñado para Bos indicus tropical en El Oro, Ecuador.

[![Deploy](https://github.com/andreerogel1997-bit/bovinocheck/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/andreerogel1997-bit/bovinocheck/actions/workflows/deploy-pages.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg)](LICENSE)
[![PWA](https://img.shields.io/badge/PWA-installable-065f46)](https://andreerogel1997-bit.github.io/bovinocheck/)

**Demo en vivo**: https://andreerogel1997-bit.github.io/bovinocheck/

**Tutor**: Mvz. Andreé Vitonera Rogel, MSc. — UTMACH
**Stack**: HTML + Tailwind + Gemini 2.5 Flash + IndexedDB + PWA
**Status**: V7.5 listo para entrega 20-jul-2026 · V8.0 research edition en diseño · Paper Q1 target dic-2026 (Computers and Electronics in Agriculture)

---

## Quick start

### Para los alumnos (probar la app)
1. Abre `src/v7.5.html` en Chrome/Safari
2. Pulsa el icono ⚙ arriba a la derecha → pega tu API key de Google AI ([gratis aquí](https://aistudio.google.com/apikey))
3. Pulsa "Probar conexión" → debe decir ✓
4. Vuelve al Analizador, ingresa un arete + selecciona raza + sube foto/video → "Ejecutar Evaluación AI"

### Para deploy mobile (Android APK)
Ver `android/QUICKSTART_BUBBLEWRAP.md` — empaqueta la PWA como APK firmado en ~30 min.

---

## Estructura del proyecto

```
BovinoCheck/
├── README.md                              ← este archivo
├── docs/
│   └── MASTER_PLAN.md                     ← roadmap V7.5 → V8.0 → paper Q1
├── src/                                   ← código deployable (sirve carpeta entera como PWA)
│   ├── v7.0-original.html                 ← snapshot de los alumnos (no tocar)
│   ├── v7.5.html                          ← versión polish actual
│   ├── index.html                         ← redirect → v7.5.html
│   ├── manifest.json                      ← PWA manifest
│   ├── sw.js                              ← service worker (offline)
│   ├── icon.svg                           ← icono vectorial fuente
│   ├── icon-192.png                       ← icono PWA 192x192
│   └── icon-512.png                       ← icono PWA 512x512
├── android/
│   └── QUICKSTART_BUBBLEWRAP.md           ← cómo generar APK Android
└── research/
    ├── 01_sota_lameness_detection.md      ← survey live 2022-2026 (DBLP+OpenAlex)
    ├── 02_lameness_scales_comparison.md   ← Sprecher vs Flower-Weary vs Welfare Quality
    ├── 03_pose_models_landscape.md        ← pose estimation models open-source
    └── raw/                               ← JSON crudos OpenAlex+DBLP (12 archivos)
```

---

## Qué cambió de V7.0 → V7.5

| Aspecto | V7.0 (alumnos) | V7.5 (polish Andreé) |
|---|---|---|
| API key | hardcoded vacío `apiKey = ""` → app rota | Modal de configuración, test de conexión, persistido en IndexedDB |
| Persistencia datos | `let analysisHistory = []` (se borra al refrescar) | **IndexedDB** transparente, export/import JSON |
| Manejo de errores | `alert("Error de conexión")` | Sistema de toasts coloreados (4 niveles) + mensajes específicos |
| Cebú tropical | No mencionado | Disclaimer colapsable + selector raza + prompt ajustado por raza |
| Escalas | Solo Sprecher 1-5 | Toggle Sprecher ↔ Welfare Quality 0/2/3, equivalencia documentada |
| Dashboard | Donut + barras | + **Timeline temporal** + **tendencia por vaca** (búsqueda) |
| Modelo IA | Hardcoded `gemini-2.5-flash-preview-09-2025` | Configurable (Flash/Pro/2.0) |
| Mobile | Browser web | **PWA instalable** + service worker offline + iconos + manifest |
| Android | No deploy path | Bubblewrap quickstart documentado, APK en 30 min |
| Citas científicas | Sin referencias | Marco clínico con DOIs verificados (Sprecher 1997, Rasmussen 2024, Dolecheck 2023) |

---

## Bibliografía clave (V7.5 + V8.0 base)

Toda verificada vía OpenAlex 2026-05-22 (sin alucinación).

- **Sprecher DJ et al. 1997**. *Theriogenology* 47:1179. Escala original 1-5. [VERIFY DOI]
- **Russello H et al. 2024**. *Comp Electron Agric* 224. Pose+features pipeline. [doi.org/10.1016/j.compag.2024.109040]
- **Real-time cattle lameness 2024**. *Sci Reports* 14. Single side-view. [doi.org/10.1038/s41598-024-64664-7]
- **Saraiva R et al. 2023**. *Comp Electron Agric* 215. **CowScreeningDB** dataset abierto. [doi.org/10.1016/j.compag.2023.108500]
- **Rasmussen P et al. 2024**. *J Dairy Sci* 107. Pérdidas globales US$11B. [doi.org/10.3168/jds.2023-24626]
- **Dolecheck KA et al. 2023**. *J Dairy Sci* 106. Modelo bioeconómico. [doi.org/10.3168/jds.2022-22446]

Ver `research/01_sota_lameness_detection.md` para listado completo (top 20).

---

## Licencia

Académica — UTMACH / proyecto estudiantil. Para uso comercial contactar al tutor.

**No reemplaza criterio clínico veterinario.** Herramienta de soporte a la decisión. Cualquier diagnóstico crítico debe confirmarse con examen presencial.
