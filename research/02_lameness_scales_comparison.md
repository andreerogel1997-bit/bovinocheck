# Lameness Scales Comparison — BovinoCheck Pro (Bos indicus tropical context)

**Author**: Research Analyst (Claude Opus 4.7) para Andreé Vitonera
**Date**: 2026-05-22
**Status**: DRAFT — todas las citas y números requieren verificación contra fuente primaria. WebFetch/Search estaban denegadas en sesión del subagente. Las marcas `[VERIFY]` señalan items que NO deben pasar a un manuscrito sin confirmación.
**Scope**: technical decision support para selección de escala en BovinoCheck Pro

---

## 1. Executive recommendation (TL;DR)

**Recomendación**: arquitectura **dual con mapeo determinístico**, no toggle pasivo.

1. **Mantén Sprecher (1997) como score interno canónico** (1–5). Es la lingua franca de la literatura — cambiar el almacenamiento rompe interoperabilidad y trazabilidad de cohortes pasadas.
2. **Expón Welfare Quality (0/2/3) como output de UI por defecto** para el triaje del técnico de campo. Es la salida más accionable (no-lame / lame / severely lame), mapea trivialmente a Sprecher y es la convención EU para auditorías — útil si el cliente exporta a programas de bienestar.
3. **Ofrece Flower & Weary NRS (1–5 continuo con 6 atributos) como modo "experto"** para usuarios que registran investigación o ensayos. Su valor real está en el sub-scoring por atributo (tracking up, joint flexion, asymmetric gait, reluctance to bear weight, head bob, back arch), no en el score agregado.
4. **NO desarrollar todavía una "BovinoCheck-Indicus scale" propia.** Antes de proponer una escala nueva necesitas: (a) un dataset etiquetado de Bos indicus tropical con tres etiquetadores independientes, (b) kappa baseline de las tres escalas existentes aplicadas a Cebú, (c) evidencia de que el back-arch (criterio dominante en Sprecher) tiene comportamiento diferente en presencia de giba torácica. Sin eso, una escala propia es ruido académico.
5. **Implementación técnica sugerida**: enum interno `SprecherScore ∈ {1,2,3,4,5}` + funciones puras `toWelfareQuality()` y `toFlowerWearyBucket()`. El modelo ML predice Sprecher; las demás escalas son vistas derivadas.

---

## 2. Tabla comparativa

| Criterio | Sprecher 1997 | Flower & Weary 2006 | Welfare Quality 2009 |
|---|---|---|---|
| **DOI** | 10.1016/S0093-691X(97)00018-3 [VERIFY exacto] | 10.3168/jds.S0022-0302(06)72193-9 [VERIFY] | Welfare Quality Consortium report, no DOI; ISBN 978-90-78240-04-4 [VERIFY] |
| **Granularidad** | 5 niveles enteros | 5 niveles + 6 sub-atributos visuales | 3 niveles (0, 2, 3) |
| **Criterio dominante** | Back arch (arqueo dorsal) parada y caminando | Multi-atributo: back arch, head bob, tracking up, joint flexion, asymmetric gait, reluctance | Habilidad de caminar (uneven gait, weight bearing) |
| **Tiempo / animal** | ~10–15 s | ~30–45 s (6 atributos) | ~5–10 s |
| **Entrenamiento requerido** | Bajo | Alto (necesita calibración inter-observer formal) | Muy bajo (apto técnico de campo) |
| **Inter-observer kappa típico** | κ ≈ 0.45–0.65 (moderado) [VERIFY rango] | κ ≈ 0.55–0.75 (moderado-bueno) [VERIFY] | κ ≈ 0.40–0.70 dependiendo collapse de categorías [VERIFY] |
| **Intra-observer** | Generalmente mejor que inter (κ > 0.7 reportado) [VERIFY] | Mejora con 6-atributos vs score único [VERIFY] | Alta por simplicidad |
| **Adopción literatura 2020+** | Sigue siendo escala más citada en lameness dairy (~50–60% estudios la usan o la mencionan como baseline) [VERIFY %] | Adoptada en welfare/precision livestock (~20–25%) [VERIFY] | Estándar de facto en auditorías EU + Welfare Quality / AssureWel; mainstream en producción comercial [VERIFY %] |
| **Validado en Bos indicus** | NO (desarrollada en Holstein USA) | NO (Holstein Canadá) | NO directamente; protocolo se aplica a beef Bos taurus pero no validado formal en indicus [VERIFY] |
| **Sensibilidad a estabulación vs pastoreo** | Diseñada freestall — back arch puede confundirse en suelos blandos / pastoreo | Multi-atributo más robusto a sustrato variable | Muy robusto pero pierde resolución temprana |
| **Detecta lameness sub-clínica (score 2)** | Sí, score 2 = "imperfect locomotion" | Sí, con mayor sensibilidad por sub-atributos | NO — categoría 0 absorbe sub-clínicos |
| **Adecuación Cebú tropical** | MEDIA — back arch confundible con giba | MEDIA-ALTA — multi-atributo compensa | ALTA para triaje, BAJA para detección temprana |
| **Output accionable para técnico** | Medio (requiere interpretación) | Bajo (denso) | Alto (decisión binaria-ternaria) |

---

## 3. Análisis por escala

### 3.1 Sprecher DJ, Hostetler DE, Kaneene JB. 1997. *A lameness scoring system that uses posture and gait to predict dairy cattle reproductive performance*. **Theriogenology** 47(6):1179–1187. [VERIFY DOI 10.1016/S0093-691X(97)00018-3]

**Estructura**: 5 niveles basados en (a) postura del dorso parado, (b) postura del dorso caminando, (c) anomalías de marcha.
- 1 = Normal (dorso plano parado y caminando)
- 2 = Mildly lame (dorso plano parado, arqueado caminando)
- 3 = Moderately lame (dorso arqueado parado y caminando, pasos cortos)
- 4 = Lame (arqueo evidente, favorece extremidad)
- 5 = Severely lame (rehúsa apoyar extremidad)

**Fortalezas**:
- Simple, rápida, ampliamente entrenable
- Validada contra performance reproductivo (objetivo original del paper)
- Es el "ground truth" implícito en la mayoría de papers de visión por computadora 2018–2025 [VERIFY]

**Limitaciones críticas para tu caso**:
- **Back arch es el criterio dominante** — en Cebú con giba torácica prominente (m. rhomboideus + apófisis espinosas T2–T5 elongadas), la línea dorsal "plana" del Holstein no aplica. Un Brahman score 1 puede parecer score 2 a un evaluador entrenado en Holstein.
- Desarrollada en freestall confinement — el sustrato (cemento ranurado) influye en la marcha de forma distinta a pastoreo tropical.
- Inter-observer reliability moderada incluso en Holstein: κ ≈ 0.45–0.65 en varios estudios de los 2010s [VERIFY rango concreto y cites].

### 3.2 Flower FC, Weary DM. 2006. *Effect of hoof pathologies on subjective assessments of dairy cow gait*. **J Dairy Sci** 89(1):139–146. [VERIFY DOI 10.3168/jds.S0022-0302(06)72193-9]

Nota: Flower & Weary publicaron varios papers en 2006–2009; el NRS de 6 atributos suele atribuirse a esta línea, pero el paper exacto que **define** el NRS de 6 atributos puede ser Flower & Weary 2006 J Dairy Sci 89:139 o un paper posterior. **[VERIFY paper específico del NRS]**.

**Estructura**: score 1–5 + 6 atributos categóricos:
1. Back arch
2. Head bob
3. Tracking up (huella posterior cae sobre huella anterior)
4. Joint flexion
5. Asymmetric gait
6. Reluctance to bear weight

**Fortalezas**:
- Multi-atributo reduce el peso de back arch — **importante para Cebú**
- Mayor reliability reportada vs scores únicos en varios estudios comparativos [VERIFY]
- Captura sub-clínicos (early lameness) mejor

**Limitaciones**:
- Tiempo de evaluación ~2–3x mayor
- Requiere entrenamiento formal; sin calibración inter-observer, los 6 atributos se vuelven ruido
- Para un técnico zootécnico de campo es excesivo

### 3.3 Welfare Quality® Consortium. 2009. *Welfare Quality® assessment protocol for cattle*. Lelystad, NL. [VERIFY ISBN/edición]

**Estructura**: 3 niveles
- 0 = not lame (caminata regular, sin paso desigual)
- 2 = lame (uneven gait o weight bearing reducido)
- 3 = severely lame (reluctancia fuerte / no apoya)

**Por qué saltan el 1**: convención del protocolo, los scores intermedios se colapsan; el "2" no implica equivalencia con Sprecher 2.

**Fortalezas**:
- Estándar EU para auditorías de bienestar
- Decisión accionable inmediata
- Excelente para reporting agregado a nivel hato/explotación

**Limitaciones**:
- No detecta lameness sub-clínica → inútil para early intervention
- Pierde 60% de la varianza diagnóstica vs Sprecher

### 3.4 Escalas alternativas

- **DairyCo Mobility Score (UK, AHDB)**: 0–3, similar conceptualmente a WQ pero con categorías ligeramente distintas. Mainstream en UK dairy. [VERIFY referencia AHDB]
- **Continuous Locomotion Score (CLS)**: propuesto en varios papers ML 2019–2023 [VERIFY autores], score continuo 0–100 o 1–5 con decimales. Atractivo para regresión vs clasificación, pero **no hay consenso de qué representa el continuo** — algunos lo derivan de probabilidades softmax, otros de visual analog scale humana.
- **Visual Analog Scale (VAS) 0–100**: usada en algunos papers de pose estimation deep learning [VERIFY ejemplos]. Útil internamente al modelo, pero NO interpretable clínicamente sin mapeo.

---

## 4. Gap específico para Bos indicus tropical

### 4.1 Diferencias biomecánicas Cebú vs Bos taurus relevantes para scoring

1. **Giba torácica (hump)**: distorsiona la línea dorsal de referencia. El criterio "flat back vs arched back" de Sprecher es **directamente confundible** con la conformación normal. Necesita una línea de referencia ajustada (e.g., línea lumbosacra, no toracolumbar).
2. **Conformación de aplomos**: Cebú tropical suele tener ángulo de corvejón más cerrado y cuartilla más vertical que Holstein → patrón de marcha basal distinto, "tracking up" tiene rangos normales distintos.
3. **Pezuñas más duras y pigmentadas**: menor prevalencia de dermatitis digital y laminitis tipo Holstein; lameness en Cebú tropical es más frecuentemente por punctura, footrot (Fusobacterium), o trauma vs claw horn disruption. Esto cambia la **distribución de patrones de marcha** que el modelo debe aprender.
4. **Comportamiento bajo manejo**: Cebú es más reactivo; videos de marcha capturados en manga vs en chute van a tener diferencias de velocidad y arousal que afectan el scoring.
5. **Pastoreo extensivo vs estabulación**: marcha sobre pasto/tierra atenúa varios signos sutiles. La sensibilidad de cualquier escala diseñada para freestall cae.

### 4.2 Lo que falta validar (research gap)

- **Kappa baseline de las 3 escalas aplicadas por mismos observadores a video de Cebú** — nadie lo ha publicado de forma definitiva en español o portugués que yo pueda verificar sin web. [VERIFY búsqueda SciELO Brazil + Pesquisa Veterinária Brasileira]
- **Prevalencia y distribución de scores** en hatos cebuinos tropicales — la mayoría de estudios LATAM en Cebú miden lameness binaria, no granular [VERIFY].
- **Validación contra gold standard clínico** (examen ortopédico + bloqueo diagnóstico) en Cebú.
- **Sesgo del back arch en presencia de giba** — estudio simple: 2 observadores ciegos puntúan 100 Cebú normales con Sprecher; si > 10% caen en score 2 sin patología, la escala está sesgada para esta raza.

---

## 5. Recomendación arquitectónica para BovinoCheck Pro

### 5.1 Decisión de almacenamiento
Almacena **Sprecher 1–5 como canónico**. Razones:
- Compatibilidad con literatura dominante → tus datos serán comparables
- Las otras escalas son colapsos determinísticos de Sprecher (información-preservante en una dirección)

### 5.2 Modos de UI (toggle por contexto de usuario)

| Modo | Escala mostrada | Usuario objetivo | Output |
|---|---|---|---|
| **"Campo"** (default) | Welfare Quality 0/2/3 + recomendación clínica | Técnico zootécnico, productor | "Sano / Cojo / Cojera severa — derivar a MVZ" |
| **"Clínico"** | Sprecher 1–5 + breve descripción de cada nivel | MVZ de campo | Score + signos esperados |
| **"Investigación"** | Sprecher 1–5 + sub-atributos Flower-Weary | Tesistas, ensayos | Score agregado + 6 atributos individuales |

### 5.3 Mapeo Sprecher → otras escalas

```
Sprecher 1 → WQ 0  | F-W 1 (no sub-atributos positivos)
Sprecher 2 → WQ 0  | F-W 2 (back arch caminando)
Sprecher 3 → WQ 2  | F-W 3 (≥2 sub-atributos positivos)
Sprecher 4 → WQ 2  | F-W 4 (≥3 sub-atributos + weight-bearing reducido)
Sprecher 5 → WQ 3  | F-W 5 (reluctancia marcada)
```

Nota: el mapeo Sprecher 2 → WQ 0 es **convención común** pero discutida; algunos protocolos mapean Sprecher 2 → WQ 2 [VERIFY consenso].

### 5.4 Ajuste explícito para Cebú (mitigación inmediata, sin re-validación)

En la UI del modo "Clínico", añadir un disclaimer visible:
> "Esta escala fue desarrollada en ganado Holstein. En Bos indicus, la giba torácica puede sesgar la evaluación de arqueo dorsal. Usar la línea lumbosacra (no toracolumbar) como referencia."

En el modelo ML:
- Si el dataset de entrenamiento tiene Cebú, **incluir la posición de la giba como landmark adicional** (extender el esquema YOLO11x-pose que ya usas en Pondera AI)
- Calcular curvatura dorsal **excluyendo el segmento T2–T5** (zona de giba)

### 5.5 Roadmap para "BovinoCheck-Indicus scale" propia (futuro, NO ahora)

Solo justificable si en 6–12 meses tienes:
1. Dataset ≥ 500 animales Cebú etiquetados por ≥ 3 observadores
2. Evidencia cuantitativa de que las 3 escalas existentes fallan en Cebú (κ < 0.4 o sesgo sistemático)
3. Un partner académico (UTMACH + UAM o Embrapa) que firme co-autoría

Antes: usa las existentes con el disclaimer y adjustment biomecánico.

---

## 6. Referencias clave (todas requieren verificación DOI antes de usar en manuscrito)

1. Sprecher DJ, Hostetler DE, Kaneene JB. 1997. Theriogenology 47:1179–1187. [VERIFY 10.1016/S0093-691X(97)00018-3]
2. Flower FC, Weary DM. 2006. J Dairy Sci 89(1):139–146. [VERIFY DOI y si es el paper exacto del NRS 6-atributos]
3. Welfare Quality® Consortium. 2009. Assessment protocol for cattle. Lelystad. [VERIFY ISBN]
4. Schlageter-Tello A et al. ~2014. Comparative review of locomotion scoring systems dairy cattle. [VERIFY autores/año/journal — review clave que compara escalas]
5. Thomsen PT et al. ~2008. Evaluation of agreement between observers for lameness scoring. [VERIFY]
6. AHDB Dairy. Mobility Score guidance. UK. [VERIFY URL]
7. Para Bos indicus / LATAM: **búsqueda pendiente** en SciELO Brasil (Pesquisa Veterinária Brasileira, Arquivo Brasileiro de Medicina Veterinária e Zootecnia) y Embrapa Gado de Corte [VERIFY existencia de papers específicos].

---

## 7. Próximos pasos sugeridos

1. **Para el código de BovinoCheck Pro hoy**: refactor `LamenessScore` a enum Sprecher + view models. Quita "Sprecher hardcoded" del acoplamiento UI.
2. **Verificación de citas (humano o agente con web)**: confirmar los 7 DOIs/URLs marcados `[VERIFY]` antes de citar en el documento de los alumnos.
3. **Estudio piloto barato (1 fin de semana)**: 30 videos Cebú El Oro, 2 observadores aplican las 3 escalas, calcula κ de Cohen. Esto te da el dato local sin pretensión de paper.
4. **Decisión definitiva post-piloto**: si κ Welfare Quality > 0.7 y κ Sprecher < 0.5 en Cebú → reforzar default WQ. Si ambos colapsan → ahí sí, considerar variante propia.

---

## Caveats finales

- Todo número (κ, %, año) en este documento es **estimación de mi conocimiento previo** y requiere verificación contra fuente primaria. WebSearch/WebFetch estuvieron denegadas en sesión del subagente.
- El mapeo Sprecher↔WQ↔Flower-Weary que doy es la **convención más común** pero hay variantes en literatura — verifica con el paper de Schlageter-Tello (review) antes de hardcodearlo.
- Recomendación de mantener Sprecher como score interno es **arquitectónica, no académica** — si el piloto local muestra que Sprecher falla en Cebú, el canónico interno debería migrar a una representación más rica (sub-atributos Flower-Weary) y Sprecher pasar a ser una vista.
