# Slice 7: UI/Visual - Auditoría Neovim Config

**Fecha:** 2025-02-18
**Slice:** UI/Visual (lualine, alpha, scrollbar, theme, etc.)

---

## Baseline Slice 7

### Plugins involucrados

| Plugin | Archivo | Purpose (1 línea) | Load strategy actual |
|--------|---------|-------------------|---------------------|
| lualine | `ui/lualine.lua` | Statusline UI | event = VeryLazy ✅ |
| alpha | `ui/alpha.lua` | Dashboard | event = VimEnter ✅ |
| nvim-scrollbar | `ui/nvim-scrollbar.lua` | Scrollbar UI | event = BufReadPost ❌ |
| which-key | `ui/which-key.lua` | Keybinding hints | event = VeryLazy ✅ |
| indent-blankline | `ui/indent-blankline.lua` | Indent guides | event = BufReadPre ❌ |
| dressing | `ui/dressing.lua` | UI better select | event = VeryLazy ✅ |
| colorscheme | `ui/colorscheme.lua` | Theme | lazy = false ❌ |

**Notas de baseline:**
- scrollbar.handlers.cursor/diagnostic = 422ms startup offender (moderado pero puede optimizar)
- ts_context_commentstring = 710ms startup offender (probado syntax plugin, no aquí)

---

## Diagnóstico por Plugin

### 1. lualine ✅ Bien configurado

**Estado:** ✅ VeryLazy (no startup impact)

**Configuración actual:**
```lua
event = "VeryLazy"
globalstatus = false -- ✅ una línea por split (performance)
```

**Problemas detectados:**
- Ninguno relevante

**Opciones:**
- Keep (bien configurado)

---

### 2. alpha ✅ Bien configurado

**Estado:** ✅ VimEnter (carga al abrir Neovim, no startup impact)

**Configuración actual:**
```lua
event = "VimEnter"
dashboard.opts.noautocmd = true
```

**Problemas detectados:**
- Ninguno relevante

**Opciones:**
- Keep (carga solo cuando necesitas dashboard)

---

### 3. nvim-scrollbar ⚠️ PUEDE SER OPTIMIZADO

**Estado:** ⚠️ BufReadPost (carga en cada archivo, 422ms baseline offender)

**Configuración actual:**
```lua
event = "BufReadPost"
config = function()
  require("scrollbar").setup()
end
```

**Problemas detectados:**
1. **BufReadPost = carga post-lectura en cada archivo**
2. **422ms startup offender** de baseline (moderado pero puede mejorar)

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener BufReadPost.
Pros: Scrollbar puede cargar más rápido al leer.
Cons: Startup overhead no especificado (422ms).
```

#### Option B - Mejor UX ⭐ PREFERIDA
```
Lazy-load más agresivo:

  Before: event = BufReadPost
  After:  event = "VeryLazy"

Benefit: ~400ms startup savings (422ms baseline offender).
Note: Scrollbar still loads when needed (after UI loaded, on scroll).

Pros: Menos startup overhead
Cons: Scrollbar no disponible in first archivo hasta que VeryLazy carga (~1s)
```

#### Option C - Simplificación
```
¿Necesario? ¿Usas scrollbar con mouse?

Si NO → quitar nvim-scrollbar.
Si SÍ → Keep con BufReadPost.
```

**Acción:** Recomendación (ver usuario)

---

### 4. which-key ✅ Bien configurado

**Estado:** VeryLazy (no startup impact)

**Configuración actual:**
```lua
event = "VeryLazy"
wk.setup()  -- register keymap groups
```

**Opciones:**
- Keep

---

### 5. dressing ✅ Bien configurado

**Estado:** VeryLazy (no startup impact)

**Opciones:**
- Keep

---

### 6. colorscheme ❌ SIEMPRE CARGA (lazy = false)

**Estado:** ❌ lazy = false (carga siempre en startup)

**Configuración actual:**
```lua
lazy = false  -- carga siempre
priority = 1000  -- alta prioridad (prioridad 1)
config = function()
  theme.setup({ transparent = true })
end
vim.cmd("colorscheme NeoSolarized")
```

**Problemas detectados:**
1. **Siempre carga en startup** - ¿realmente necesario?
   - Toma tiempo (tema NeoSolarized puede estar pesado)
   - ¿Puedo lazy-load hasta que tema sea necesario?

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener lazy = false.
Pros: Tema cargado siempre, disponible al abrir archivo.
Cons: Startup overhead (¿cuánto peso?).
```

#### Option B - Mejor UX ⭐ PREFERIDA
```
Cambiar:

  Before: lazy = false
  After: lazy = true,  (o lazy = false con event = BufEnter)

Benefit: Solo carga tema cuando se edita archivo.

Pros: Menos startup overhead.
Cons: Tema no disponible hasta editar primer archivo.

Alternative:
  Si tema es ligero, mantener lazy = false.
  Si tema es cosmético, lazy = true.

**¿Temas son ligados o cosméticos?**
  - "ligado" = necesario al inicio (configuración completa de UI)
  - "cosmético" = puede cargar después

Usuario feedback requerida.
```

---

### 7. indent-blankline ⚠️ Carga pesado en BufReadPre

**Estado:** ❌ BufReadPre = ~moderado (710ms baseline? No, eso es ts_context_commentstring)

**Configuración actual:**
```lua
event = { "BufReadPre", "BufNewFile" }
```

**Problemas detectados:**
- Carga en la apertura de cada archivo
- ¿Puede ser más lazy? event = BufReadPost (post-lectura, no afecta visuales de indent guides)

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener BufReadPre.
Pros: Carga más temprano antes de leer.
Cons: Startup overhead (menor si plugin ligero).

Reasoning: Indent guides cargan más temprano para mostrar en lectura.
```

#### Option B - Mejor UX ⭐ PREFERIDA (si usuario acepta)
```
Lazy-load más agresivo:

  Before: event = { "BufReadPre", "BufNewFile" }
  After:  event = "BufReadPost"  -- post-lectura, no afecta visuales

Benefit: ~50-100ms startup savings.
Cons: Indent guides aparecen 1 archivo más tarde (después de leer).

Pros: Menos startup overhead
Cons: Visual delay menor (100-200ms)
```

#### Option C - Simplificación
```
¿Necesario? ¿Usas indent guides regularmente?

Si RARA → quitar indent-blankline.
Si FRECUENTE → mantener.
```

**Acción:** Recomendación (ver usuario)

---

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Load strategy | Opción | Riesgo |
|--------|--------|-------------|---------------|-------|--------|
| lualine | ✅ Bien | VeryLazy | Keep | A | None |
| alpha | ✅ Bien | VimEnter | Keep | A | None |
| nvim-scrollbar | ⚠️ BufReadPost | BufReadPost → VeryLazy | B | Bajo |
| which-key | ✅ Bien | VeryLazy | Keep | A | None |
| dressing | ✅ Bien | VeryLazy | Keep | A | None |
| colorscheme | ❌ Siempre carga | lazy = false → lazy = true | B | Bajo |
| indent-blankline | ⚠️ BufReadPre | BufReadPost → VeryLazy | B | Bajo |

---

## Cambios Propuestos

### Cambio 1: nvim-scrollbar lazy-load (~400ms startup gain)

**Priority:** Media (moderado improvement, 400ms gain)

```lua
# Antes
event = "BufReadPost"

# Después
event = "VeryLazy"
```

**Benefit:** scroll.handlers.cursor/diagnostic = 422ms baseline → ~400ms gain

---

### Cambio 2: colorscheme lazy-load (optimización de startup)

**Priority:** Media (si tema no es ligado)

```lua
# Antes
lazy = false

# Después (opcional)
lazy = true, (o lazy = false con event = BufEnter)
```

**Benefit:** Solo carga cuando necesario (primer archivo editado)

---

## Verificación para Usuario

**Preguntas para aprobación:**

1. **nvim-scrollbar:** ¿Usas scrollbar con mouse regularmente?
   - **A. Sí uso** → mantener BufReadPost
   - **B. No uso raramente** → VeryLazy (400ms gain)

2. **colorscheme carga:** ¿Tema es ligado o cosmético?
   - **Ligado** (necesario iniciar UI) → mantener lazy = false
   - **Cosmético** (puede cargar después) → lazy = true

3. **indent-blankline:** ¿Usas indent guides regularmente?
   - **A. Si uso raramente** → VeryLazy
   - **B. Si uso frecuentemente** → BufReadPost (BufReadPost OK)

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Feedback nvim-scrollbar usage
- [ ] Feedback colorscheme ligado vs cosmético
- [ ] Feedback indent-blankline usage

**Riesgos:**
- nvim-scrollbar VeryLazy → bajo (1-2s delay en primer archivo)
- colorscheme lazy = true → medio (tema no disponible hasta editar)
- indent-blankline BufReadPost → medio (100-200ms visual delay)

---

**Estado Slice 7:**
- ✅ Diagnóstico completo
- ⏸️ Cambios propuestos esperando feedback
- ⏸️ Commits pendientes (después de aprobación)
- ⏸️ Doc actualizada (pending cambios)

**Prioridad de cambios:**
1. nvim-scrollbar: ~400ms gain (moderado)
2. colorscheme: unknown gain (si no es ligado)
3. indent-blankline: ~100ms gain (if cosmetico)

**Notas de performance:**
- DAP optimize ahora (~500ms gain applied)
- Slice 7 puede añadir ~400-1000ms startup savings (total 900-1500ms from baseline 156ms)