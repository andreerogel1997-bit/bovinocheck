# BovinoCheck — Master Plan V7.5 → V8.0 → Paper Q1

**Última actualización**: 2026-05-22
**Owner**: Mvz. Andreé Vitonera, UTMACH
**Tiempo total estimado**: 8 meses (mayo 2026 → enero 2027)

---

## Visión consolidada

**Tesis**: existe un hueco editorial claro para una app **smartphone-based de scoring de cojera validada en Bos indicus tropical**. SOTA 2022-2026 cubre Holstein/Jersey en freestall con cámaras fijas; nadie cubre Cebú pastoral LATAM. Si combinamos (a) la app que ya tienen los alumnos como prueba de concepto, (b) la infraestructura CORTEX (Beelink + LiteLLM + Letta), (c) acceso clínico AMC + UTMACH a hatos cebuinos El Oro, hay paper Q1 + producto en 8 meses.

---

## Sprint 0 — Cierre académico (V7.5) · 22 mayo → 20 julio 2026

**Objetivo**: que los alumnos entreguen V7.5 funcional + presentación + póster el 20-jul.

| # | Tarea | Owner | Estado | Deadline |
|---|---|---|---|---|
| 0.1 | V7.5 código (IndexedDB + API + dual scale + PWA) | Andreé+Claude | ✅ HECHO | 22-may |
| 0.2 | Generar 5-10 videos test reales en AMC o cliente Andreé | Andreé | pendiente | 1-jun |
| 0.3 | Walkthrough V7.5 con alumnos (sesión 1h) | Andreé | pendiente | 5-jun |
| 0.4 | Deploy a GitHub Pages o Netlify | Alumnos | pendiente | 15-jun |
| 0.5 | Generar APK Bubblewrap (seguir QUICKSTART) | Alumnos guiados | pendiente | 30-jun |
| 0.6 | Testing en 20-30 vacas reales (UTMACH facultad o granja partner) | Alumnos | pendiente | 15-jul |
| 0.7 | Póster científico + presentación final | Alumnos | pendiente | 20-jul |

**Riesgos Sprint 0**:
- Google AI Studio puede rate-limitear free tier → mitigar con 3-4 API keys de alumnos rotando
- Bubblewrap requiere Java 17 → puede ser bloqueador para alumnos sin Mac (alternativa: PWA Builder online)

---

## Sprint 1 — V8.0 prototipo pose estimation · 21 julio → 30 septiembre 2026

**Objetivo**: integrar pose estimation real (RTMPose) sobre la base de V7.5, generar overlay esqueleto en vivo, capturar keypoints en cada análisis.

| # | Tarea | Owner | Bloqueado por |
|---|---|---|---|
| 1.1 | Decidir licencia comercial (Apache vs AGPL) — define modelo | Andreé | — |
| 1.2 | Setup CVAT en Beelink para anotar dataset propio | Andreé | — |
| 1.3 | Anotar 100 videos Cebú El Oro (12 keypoints lateral) | Estudiantes + Andreé | 1.2 |
| 1.4 | Fine-tune RTMPose-s sobre AnimalPose + dataset propio | Andreé | 1.3 |
| 1.5 | Exportar modelo a ONNX para web (ONNX Runtime Web) | Andreé | 1.4 |
| 1.6 | Integrar inferencia pose en v8.0.html con overlay | Andreé+Claude | 1.5 |
| 1.7 | Capturar keypoints + frames en IndexedDB junto al resultado | Andreé+Claude | 1.6 |
| 1.8 | Validación interna: 30 videos test, comparar pose vs IA-solo | Andreé | 1.7 |

**Output Sprint 1**: V8.0-alpha con esqueleto visible, mismo flow UX, modelo corre on-device en mobile moderno.

---

## Sprint 2 — Features biomecánicos + clasificador · 1 oct → 15 noviembre 2026

**Objetivo**: extraer features cinemáticos validados literatura, entrenar XGBoost interpretable.

| # | Tarea | Owner | Notas |
|---|---|---|---|
| 2.1 | Implementar 6 features de Russello 2024: BPM, head bob, stride sym, tracking ratio, joint range, walking speed | Andreé | Paper [doi.org/10.1016/j.compag.2024.109040] |
| 2.2 | Adaptación features para Cebú: excluir T2-T5 del back curve | Andreé | Por sesgo giba |
| 2.3 | Etiquetar 200 videos con Sprecher por 2 MVZ ciegos (kappa target ≥0.6) | Andreé+otro MVZ | Costo: ~40h trabajo MVZ |
| 2.4 | Entrenar XGBoost en features → Sprecher 1-5 | Andreé | Train/val 80/20 |
| 2.5 | SHAP values para explicabilidad por feature | Andreé | Panel "por qué este score" en V8.0 |
| 2.6 | Integrar XGBoost ONNX en v8.0.html | Andreé+Claude | Doble check: IA-Gemini vs XGBoost-features ratificación |
| 2.7 | Confidence intervals via bootstrap | Andreé | UX: alerta si confidence <0.7 |

**Output Sprint 2**: V8.0-beta con pipeline completo pose → features → XGBoost → score interpretable.

---

## Sprint 3 — Validación clínica + Paper · 16 noviembre 2026 → 31 enero 2027

**Objetivo**: estudio de validación n=200 vs gold standard humano + submit paper Q1.

| # | Tarea | Owner | Notas |
|---|---|---|---|
| 3.1 | Protocolo de validación: 200 vacas Cebú, 5 granjas El Oro, 2 MVZ independientes | Andreé | IRB UTMACH si aplica |
| 3.2 | Recolección datos campo (4 semanas, fines de semana) | Andreé + tesistas | |
| 3.3 | Análisis estadístico: kappa AI vs MVZ, sensibilidad/especificidad por grado | Andreé | R + jamovi |
| 3.4 | Draft paper en LaTeX: "Smartphone-based lameness scoring in tropical Bos indicus cattle: validation of a deep learning system in El Oro, Ecuador" | Andreé + SlideArchitect/Claude | Target: Comp Electron Agric |
| 3.5 | Pre-submission peer review: 2 colegas + co-autores alumnos | Andreé | 1 semana |
| 3.6 | Submit a Computers and Electronics in Agriculture | Andreé | Q1, IF 8.9 |

**Output Sprint 3**: paper submitted enero 2027 + dataset publicable + app deployable.

---

## Stack técnico decidido (V8.0)

| Componente | Tecnología | Por qué |
|---|---|---|
| Frontend | Tailwind + vanilla JS single-file | Mantener portabilidad PWA, Bubblewrap-friendly |
| Persistencia | IndexedDB (vía idb 8.x) | Local-first, soporta blobs grandes (videos) |
| Pose estimation | RTMPose-s (MMPose, Apache-2.0) | Top-1 análisis pose models; ONNX-Web compatible |
| Inferencia web | ONNX Runtime Web + WebGPU | Compatible Chrome+Safari mobile |
| Features | 6 features Russello 2024 + ajustes Cebú | Validados literatura Q1 |
| Clasificador | XGBoost ONNX | Interpretable, ya en stack Pondera AI |
| IA backup/segunda opinión | Gemini 2.5 Flash | Para casos baja confidence o sin red local |
| Explicabilidad | SHAP values + frame del momento crítico | Diferenciador competitivo |
| Mobile app | PWA + Bubblewrap TWA → APK | Sin Capacitor por simplicidad inicial |
| Backend opcional | None V7.5 · Beelink Postgres + FastAPI V8.1 | Solo si se necesita sync hatos |

---

## Dataset plan

| Fase | n | Origen | Etiquetado por | Uso |
|---|---|---|---|---|
| Bootstrap | 1500 | CowScreeningDB (público, Holstein) | Autores originales | Pre-train RTMPose |
| Anotación 1 | 100 | UTMACH + AMC clientes (Cebú) | Andreé + alumnos | Fine-tune RTMPose keypoints |
| Anotación 2 | 200 | 5 granjas El Oro | 2 MVZ ciegos | Train XGBoost + validación |
| Validación final | 50 | 1-2 granjas no vistas | 3 MVZ + estándar clínico | Test set definitivo |

**Total esfuerzo anotación**: ~80h humanas (CVAT auto-asistido)

---

## Co-autoría sugerida del paper

1. **Andreé Vitonera** (UTMACH, AMC) — concepción, supervisión, validación clínica · *corresponding author*
2. **[Alumnos del proyecto integrador]** — 3-5 estudiantes que aporten data collection, validación, anotación
3. **MVZ independiente** (granja partner) — etiquetado ciego ground truth
4. **[Opcional] Colaborador UAM** — análisis estadístico avanzado, escritura inglés

---

## Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Beelink offline UTMACH bloquea Tailscale | Alta | Alto | Trabajar Mac-local; ya tenemos esto resuelto |
| Drive sync corrompe .git | Media | Alto | Mover repo a `~/cortex/02_PROJECTS/` (fuera de Drive) en Sprint 1 |
| Gemini free tier insuficiente | Alta | Medio | Migrar inferencia a XGBoost local en Sprint 2 |
| Dataset Cebú insuficiente (<100 vacas) | Media | Alto | Partner con cooperativa ganadera Machala |
| Licencia AGPL bloquea comercialización | Baja | Crítico | Usar RTMPose Apache desde el inicio (decidido) |
| Bubblewrap APK rechazado en Play Store | Baja | Bajo | Plan B: distribuir APK directo, no Play Store |

---

## Métricas de éxito

| Hito | Métrica de éxito |
|---|---|
| V7.5 entrega alumnos | ≥3 alumnos completan APK funcional + póster |
| V8.0-alpha | Pose overlay corre <100ms/frame en Android medio |
| V8.0-beta | Kappa AI vs human ≥0.6 en validación interna |
| Paper submit | Submitted a Q1 antes 31-ene-2027 |
| Producto | Mínimo 1 cliente UTMACH usando app en producción |

---

## Referencias cruzadas

- `research/01_sota_lameness_detection.md` — top 20 papers con DOIs verificados
- `research/02_lameness_scales_comparison.md` — Sprecher vs Flower-Weary vs WQ
- `research/03_pose_models_landscape.md` — RTMPose vs YOLO11 vs DeepLabCut
- `android/QUICKSTART_BUBBLEWRAP.md` — empaquetado APK
- Pondera AI (proyecto hermano de Andreé) — stack YOLO11 cebuino compartible
