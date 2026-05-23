# BovinoCheck Pro V8.0 — Pose Estimation Models Landscape (2026-05)

> **Scope:** modelos open-source disponibles HOY (mayo 2026) viables para overlay de esqueleto bovino en navegador móvil (TF.js / ONNX Runtime Web / MediaPipe Tasks / WebGPU) o on-device Android (Capacitor/Bubblewrap PWA + TFLite/NNAPI). Target: cojera Sprecher con keypoints en lomo (≥5), cabeza y 4 extremidades (hip/knee/hock/hoof).
>
> **Metodología:** mapeo realizado desde el conocimiento entrenado del modelo (cutoff 2026-01). **WebSearch, WebFetch y curl quedaron denegados por sandbox en esta sesión**, por lo que los enlaces, números de versión exactos, hashes de checkpoint y benchmarks "live" deben ser **re-verificados antes de citar en paper o de descargar pesos**. Cada celda con `[VERIFY]` requiere check empírico.
>
> **Documento hermano sugerido:** `04_pose_models_validation_log.md` (vacío) para anotar resultados reales una vez ejecutados los benchmarks en celulares testbed.

---

## 1. Tabla comparativa — modelos candidatos

| # | Modelo | Autor / Year | Licencia | Cattle nativo | Keypoints (total / útiles cojera) | Tamaño nominal | Export móvil | Latencia móvil estimada¹ | Web-runtime listo |
|---|---|---|---|---|---|---|---|---|---|
| 1 | **YOLO11-pose** (n/s/m) | Ultralytics, 2024 | **AGPL-3.0** (comercial requiere licencia paga) | No — fine-tuning sobre AP-10K/dataset propio | Configurable (default 17 COCO; custom N) | n=6 MB, s=22 MB, m=50 MB | ONNX / TFLite / TF.js / CoreML / NCNN | n: ~25-40 ms · s: ~60-90 ms · m: ~150-220 ms (SD 6 Gen 1) | Sí (tfjs + onnxruntime-web) |
| 2 | **YOLOv8-pose** (n/s) | Ultralytics, 2023 | **AGPL-3.0** | No — fine-tuning | Configurable | n=6 MB, s=23 MB | ONNX / TFLite / TF.js / CoreML | n: ~30-50 ms · s: ~70-100 ms | Sí |
| 3 | **MMPose RTMPose-t/-s/-m** | OpenMMLab, 2023-2024 | **Apache-2.0** | No nativo, pero **checkpoint oficial AP-10K** sí (incluye Bos taurus) | AP-10K = 17 (cabeza, hombros, codos, muñecas/fetlock, caderas, rodillas, tobillos/hock, ojos) | t≈4 MB, s≈10 MB, m≈30 MB | ONNX vía MMDeploy; TFLite vía conversor; **sin TF.js oficial** | t: ~20-35 ms · s: ~40-60 ms | Parcial (ONNX Runtime Web posible) |
| 4 | **DeepLabCut ModelZoo — Quadruped / SuperAnimal-Quadruped** | Mathis Lab, 2023-2024 | **LGPL-3.0** (permite comercial con linking) | **Sí — SuperAnimal-Quadruped** entrenado sobre 16 datasets incluyendo cattle/sheep/goat | 27-39 (versión "quadruped80" tiene 39 incl. columna densa) | ResNet50: ~95 MB · MobileNetV2-1.0: ~16 MB | TFLite (oficial desde DLC 2.3+); ONNX experimental; **TF.js no oficial** | MobileNetV2: ~120-200 ms · ResNet50: ~400-700 ms | Difícil en browser; viable en Android nativo / Capacitor |
| 5 | **MediaPipe Pose Landmarker** | Google, 2023 (Tasks API 2024) | **Apache-2.0** | **Solo humanos** — no transferible directo (clases hard-coded en BlazePose) | 33 humanos | Lite=3 MB · Full=6 MB · Heavy=26 MB | TFLite / **Web (MediaPipe Tasks)** / iOS / Android | Lite: ~15 ms · Full: ~30 ms (SD 6 Gen 1) | Sí — runtime web oficial (WASM+WebGL) |
| 6 | **MoveNet Lightning/Thunder** | Google TF Hub, 2021 | **Apache-2.0** | Solo humanos; transfer learning posible pero **arquitectura cerrada al keypoint head** | 17 (COCO humanos) | Lightning=3 MB · Thunder=12 MB | TFLite / **TF.js oficial** / CoreML | Lightning: ~15-20 ms · Thunder: ~40-60 ms | Sí — TF.js demo oficial |
| 7 | **AP-10K dataset (no modelo)** | Yu et al., NeurIPS 2021 | **Apache-2.0** (anotaciones) | **Sí, Bovidae incl. cattle, yak, buffalo** entre 54 especies | 17 keypoints estándar | Dataset, no checkpoint | — (úsalo para fine-tuning) | — | — |
| 8 | **Animal Kingdom** | Ng et al., CVPR 2022 | **MIT / CC-BY** dataset | 850 especies incl. mamíferos; **cattle limitado, mejor para variedad** | 23 (full body + facial) | Dataset | — | — | — |
| 9 | **AnimalPose v1/v2** | Cao et al., 2019 / Yu update | **MIT** | Sí — 5 mamíferos: dog/cat/cow/horse/sheep (**cow incluido nativo**) | 20 (cabeza 4 + cuerpo + 4 extremidades 3 pts c/u) | Dataset (~6k imágenes) | — | — | — |
| 10 | **ATRW (Amur Tiger)** | CVWC 2019 | **CC-BY-NC-SA 4.0** ⚠ **No comercial** | Tiger only; transfer arquitectónico viable, **dataset NO usable comercial** | 15 | Dataset | — | — | — |
| 11 | **DeepPoseKit + Quadruped legacy** | Graving 2019 | MIT | Mosca, locust; cattle requiere full re-train | Variable | Pequeño | TF only | — | No mantenido |
| 12 | **VHR-Pose / VitPose-Animal (HuggingFace)** | TransPose group, 2023-2024 | **Apache-2.0** | Fine-tuned sobre AP-10K (mismo set que MMPose) | 17 AP-10K | ViT-S ≈ 90 MB · ViT-B ≈ 350 MB | ONNX experimental | ViT-S: ~250-400 ms (no recomendado móvil) | No |

¹ **Latencia móvil** = estimación basada en benchmarks publicados sobre Snapdragon 8 Gen 1 / Pixel 6 escalada a Snapdragon 6 Gen 1 (≈0.5x throughput GPU/NPU). **Re-medir en device real.**

---

## 2. Análisis por candidato (detalle)

### 2.1 YOLO11-pose / YOLOv8-pose (Ultralytics)
- **Repo:** `github.com/ultralytics/ultralytics`
- **Pros:** export pipeline maduro (un comando `yolo export format=tfjs|onnx|tflite|coreml`); comunidad masiva; arquitectura anchor-free moderna; sliders n/s/m/l/x dejan trade-off granular; soporta keypoints custom (definir N en `data.yaml`); ya hay forks con AP-10K (`yolo-animal-pose` etc.).
- **Contras críticos:**
  - **AGPL-3.0**: si BovinoCheck se distribuye como producto comercial (App Store, venta de licencia), Ultralytics exige **licencia Enterprise paga** (≈USD 5k+/año confirmar). Solo gratis si todo el código + modelos derivados se libera AGPL.
  - **No hay checkpoint cattle público oficial** — hay que entrenar.
- **Keypoints útiles cojera:** configurables; recomendado custom set de 23 puntos: 5 columna (cervical, cruz, dorso, lomo, base cola) + cabeza (2) + 4 patas × 4 articulaciones (escapulohumeral/hip, codo/stifle, carpo/hock, pezuña).
- **Recomendación:** YOLO11n-pose es el sweet spot para móvil **si la licencia es aceptable** (validar con Andreé si BovinoCheck va a ser GPL-compatible o si se compra Enterprise).

### 2.2 MMPose RTMPose (OpenMMLab)
- **Repo:** `github.com/open-mmlab/mmpose`
- **Pros:** **Apache-2.0 puro** (uso comercial libre); checkpoints oficiales para AP-10K (incluye cattle); RTMPose-t es el modelo "real-time mobile" diseñado para edge (≈ 90 fps en Snapdragon 865 según paper); pipeline MMDeploy → ONNX bien documentado.
- **Contras:**
  - **No hay export oficial a TF.js** — para correr en browser hay que convertir ONNX → ONNX Runtime Web (sí funciona) o ONNX → TF SavedModel → TF.js (frágil).
  - 17 keypoints de AP-10K solo dan 1 punto de columna (cruz/withers). Para Sprecher con ≥5 puntos lomo hay que **fine-tunear con keypoints extra** sobre AnimalPose extendido o anotar dataset propio.
- **Recomendación:** mejor opción **si la licencia es bloqueante para YOLO**. Plan: RTMPose-s + ONNX Runtime Web (WASM SIMD + WebGL backend).

### 2.3 DeepLabCut SuperAnimal-Quadruped
- **Repo:** `github.com/DeepLabCut/DeepLabCut`, modelzoo en HuggingFace `mwmathis/DeepLabCutModelZoo-SuperAnimal-Quadruped`
- **Pros:** **único modelo plug-and-play que reconoce cattle out-of-the-box** sin fine-tuning (entrenado sobre 16 datasets de cuadrúpedos incluyendo cattle barn footage); 39 keypoints densos incluyendo columna multi-punto (cervical 2, withers, mid-back, croup, tail-base) — **ideal para Sprecher**; investigación neurociencia veterinaria → arquitectura pensada para video.
- **Contras:**
  - **Latencia: el cuello de botella crítico** — ResNet50 backbone no corre en móvil <300 ms; MobileNetV2 variant existe pero con drop notable de PCK en cattle (≈ -8%).
  - **No hay TF.js oficial**, solo TFLite. Para browser hay que hacer pipeline: DLC checkpoint → TF SavedModel → tfjs_converter (frágil, breaks frecuentes).
  - **LGPL-3.0** del código DLC; los pesos del modelzoo son CC-BY-NC-SA 4.0 en algunos casos ⚠ **verificar el modelo concreto** — algunos checkpoints SuperAnimal son CC-BY 4.0 (comercial OK), otros NC.
- **Recomendación:** **fallback nativo Android**, no browser. Empacar via Capacitor con TFLite runtime + GPU delegate. Mejor opción **si precisión anatómica es no-negociable** y se acepta perder fluidez (≈ 3-5 fps en SD 6 Gen 1 con MobileNetV2 variant).

### 2.4 MediaPipe Pose Landmarker
- **No usable directo** — BlazePose head está hard-coded a 33 keypoints humanos; no hay forma soportada de hacer transfer a animales sin reentrenar todo desde cero (y el dataset BlazeGAN es propietario).
- **Único uso útil:** **detector de bounding-box previo**. MediaPipe Object Detector (EfficientDet-Lite0) puede correr a >60 fps en navegador móvil y servir como crop stage antes de enviar al modelo pose. Esto acelera cualquier pipeline 2-3x.

### 2.5 MoveNet
- Mismo problema que MediaPipe: arquitectura cerrada a humanos. La técnica de "centernet + heatmaps" es transferible pero requiere re-training completo; ya existen forks (no oficiales) que aplican MoveNet a perros, **ninguno público para cattle** [VERIFY].
- **Veredicto:** descartar.

---

## 3. Recomendación TOP-1 para V8.0

### **RTMPose-s (MMPose) fine-tuned sobre AnimalPose + anotaciones cattle propias, exportado a ONNX Runtime Web (WASM SIMD + WebGL backend)**

**Justificación del trade-off:**

| Eje | RTMPose-s | YOLO11n-pose | DLC SuperAnimal | Por qué gana RTMPose |
|---|---|---|---|---|
| Licencia comercial | **Apache-2.0 limpia** | AGPL bloqueante | LGPL + pesos mixtos | ✅ Sin riesgo legal para BovinoCheck Pro |
| Tamaño on-device | ~10 MB | 6 MB | 16-95 MB | ✅ Cabe holgado |
| Latencia SD 6 Gen 1 | ~40-60 ms (objetivo <100) | ~25-40 ms (mejor) | 200-700 ms (no cumple) | ⚠ YOLO gana, pero RTMPose cumple target |
| Keypoints cattle | 17 AP-10K + extensible | Custom desde cero | 39 nativos densos | ✅ Base sólida + fine-tune barato |
| Web runtime | ONNX Runtime Web (estable) | tfjs / ort-web (ambos OK) | Ninguno bueno | ✅ Cubierto |
| Comunidad veterinaria | Media | Baja | **Alta** (Mathis Lab vet collab) | ⚠ DLC gana en literatura |

**Top-1 = RTMPose-s** por: licencia limpia, latencia dentro de target, export web estable, y posibilidad real de extender a 23-27 keypoints custom para Sprecher con presupuesto razonable de anotación (~1500 imágenes etiquetadas).

**Si el usuario decide pagar Enterprise license de Ultralytics**, swap a YOLO11n-pose (más rápido y con tooling superior).

---

## 4. Plan de fallback (si TOP-1 falla en práctica)

**Cascada de degradación pensada antes de empezar a quemar tiempo:**

1. **Fallback A — RTMPose-s funciona en backend pero >100 ms en device:**
   - Bajar a **RTMPose-t** (≈4 MB, ~20-35 ms estimado, perderemos ~3% mAP).
   - Reducir input resolution de 256×192 → 192×144 (gana ~30% latencia, pierde ~5% PCK en keypoints distales = hooves).
2. **Fallback B — ONNX Runtime Web no acepta operadores custom de RTMPose:**
   - Convertir a TFLite + correr via **Capacitor + tflite-react-native plugin** (sale del navegador puro, pero sigue PWA-empaquetable).
   - Alternativa: TF.js converter desde ONNX (uses `onnx-tensorflow` bridge — frágil pero documentado).
3. **Fallback C — precisión anatómica insuficiente para Sprecher:**
   - Switch a **DeepLabCut SuperAnimal-Quadruped MobileNetV2** vía Capacitor + TFLite + GPU delegate. Aceptar 3-5 fps (modo "análisis offline" en lugar de overlay live; el usuario graba video 5s, procesa post-captura).
4. **Fallback D — todo el stack web falla:**
   - Pipeline 2-stage server-side: PWA captura → upload frame → inference en Beelink (RTMPose-m FP16 ~15 ms/frame) → devuelve keypoints. Funciona en cualquier celular pero requiere conectividad rural buena (no es el caso en muchas haciendas tropicales Ecuador, validar con UTMACH field deployments).

---

## 5. Datasets para validación y fine-tuning (ganado tropical)

### Open / comercial-friendly

| Dataset | Año | Licencia | Especies | Notas para cattle tropical |
|---|---|---|---|---|
| **AnimalPose v1** (cow subset) | 2019 | MIT | dog/cat/cow/horse/sheep | ~600 imágenes cow, lateral view; **bias razas europeas** (Holstein, Hereford). Útil para warm-start, **no suficiente para Brahman/cebuino**. |
| **AP-10K** | 2021 | Apache-2.0 | 54 species incl. Bos taurus, Bubalus | ~10k imágenes; cattle ~250 anotadas; same bias europeo. |
| **Animal Kingdom** | 2022 | MIT / CC-BY | 850 species | Video-based; útil para temporal smoothing. Cattle subset pequeño. |
| **AcinoSet (cheetah)** | 2021 | MIT | Acinonyx | Solo metodología útil (multi-view 3D), no transferible directo. |
| **Cornell Cow Locomotion** | [VERIFY] — existe paper Bewley/Schulze, dataset puede no ser abierto | — | Holstein-Friesian | Si abierto, gold-standard para gait scoring. |
| **Aarhus Cattle Behavior** | [VERIFY] 2020-2023 publicaciones Munksgaard et al. | Variable, probable academic-only | Dairy cattle | Buscar `aarhus animal science cattle gait video`. |
| **Wageningen DairyCattle Vision** | [VERIFY] Hogeveen group | Academic restricted típicamente | Dairy | Mastitis + lameness, video lateral. |

### Recomendación de fine-tuning para Brahman/cebuino tropical Ecuador

**Hay que anotar dataset propio.** AnimalPose + AP-10K no cubren morfología cebuina (giba, papada, ancas más altas). Plan mínimo viable:

1. **300-500 imágenes** capturadas en hato AMC y haciendas UTMACH (Pasaje, Machala) — lateral view, marcha lineal.
2. **23 keypoints** custom siguiendo esquema Sprecher (definir en `04_keypoint_schema.md` aparte).
3. Anotador: **CVAT** o **Labelbox** free tier (CVAT recomendado, self-hostable en Beelink, sin riesgo PII / sin envío a cloud).
4. Train/val/test 70/15/15, **estratificar por BCS y por raza** (Brahman puro vs cruce europeo).
5. Fine-tune sobre RTMPose-s pre-entrenado en AP-10K → expectativa PCK@0.05 ≥ 80% en keypoints proximales, ≥ 65% en hocks/pezuñas (más difíciles por barro/oclusión).

---

## 6. Decisiones pendientes (input requerido del usuario)

1. **¿BovinoCheck Pro será software libre AGPL-3.0 o producto comercial cerrado?** — bloquea elección YOLO vs RTMPose.
2. **¿Se acepta dependencia de inferencia server-side (Beelink)?** — si sí, el espacio de modelos se abre (RTMPose-m, ViTPose, DLC ResNet50).
3. **¿Hay budget para Enterprise license Ultralytics (~5k USD/año)?**
4. **¿Hay budget de tiempo del estudiante / Andreé para anotar 500 imágenes en CVAT?** — sin esto, modelos genéricos darán PCK insuficiente para usar el resultado en publicación científica veterinaria.

---

## 7. Próximos pasos accionables (V8.0 sprint)

- [ ] **Verificar URLs y licencias** de cada modelo de la tabla 1 (live web check cuando se restaure WebFetch).
- [ ] Decidir top-1 final con el usuario (RTMPose-s vs YOLO11n licenciado).
- [ ] Stand up minimal `pose-test.html` con ONNX Runtime Web cargando RTMPose-s genérico (sin fine-tune) para validar el runtime end-to-end en un celular real.
- [ ] Medir latencia real en 3 celulares testbed (Snapdragon 6 Gen 1, MediaTek Helio G99, Snapdragon 8 Gen 2 high-end).
- [ ] Comenzar anotación piloto: 50 imágenes cattle Brahman lateral en CVAT, schema 23 keypoints.
- [ ] Decidir bbox-detector: MediaPipe ObjectDetector (EfficientDet-Lite0) vs YOLOv8n-detect (no pose, solo cattle class).

---

## 8. Caveats de esta investigación

- **Sin acceso web esta sesión** (WebSearch/WebFetch/curl denegados por sandbox). Todos los datos provienen de conocimiento entrenado al 2026-01. Antes de comprometer arquitectura o citar en paper, verificar:
  - Versión actual y release notes de YOLO11/RTMPose/DLC al día de la decisión.
  - Licencia exacta de cada checkpoint DeepLabCut modelzoo (algunos CC-BY-NC).
  - Disponibilidad real de datasets Cornell/Aarhus/Wageningen (marcado `[VERIFY]`).
- **Latencias móvil son estimaciones**, no mediciones. El paso 7 corrige esto.
- **AGPL de Ultralytics es interpretación común pero conviene legal review** si se monetiza.

---

*Documento generado para Andreé Vitonera — BovinoCheck Pro V8.0 planning. Mantener este archivo como living doc; actualizar tras cada validación empírica en `04_pose_models_validation_log.md`.*
