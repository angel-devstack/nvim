# Slice 2: Navigation - Auditoría Neovim Config

**Fecha:** 2025-02-18
**Slice:** Navigation (Telescope, Nvim-tree, Trouble)

---

## Baseline Slice 2

### Plugins involucrados

| Plugin | Archivo | Purpose (1 línea) | Load strategy actual |
|--------|---------|-------------------|---------------------|
| Telescope | `lua/angel/plugins/ui/telescope.lua` | Fuzzy find archivos, grep, oldfiles | cmd + keys |
| Nvim-tree | `lua/angel/plugins/ui/nvim-tree.lua` | File explorer sidebar (reemplaza netrw) | cmd + keys |
| Trouble | `lua/angel/plugins/ui/trouble.lua` | Diagnostics/references navigator | dependencies + keys |

**Notas:**
- Ya fixeado tree-sitter error en Telescope (commit `6902005`)
- Telescope usa `preview.treesitter = false` como workaround

---

## Diagnóstico por Plugin

### 1. Telescope ✅ STATUS: FIXED

**Estado:** ✅ Fix aplicado (tree-sitter en previews desactivado)

**Configuración actual (post-fix):**
```lua
defaults = {
  preview = { treesitter = false },
  file_previewer = require("telescope.previewers").vim_buffer_cat.new,
  grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
}
```

**Keymaps actuales:**
```lua
<leader>ff  -- find files
<leader>fr  -- recent files
<leader>fs  -- live grep
<leader>fc  -- grep_string (cursor word)
<leader>ft  -- TODOs
```

**Problemas detectados:**
1. `command = "Telescope"` + `branch = "0.1.x"` (stable)
2. **¿Branch correcto?** Telescope 0.1.x = versión legacy, ¿usando versión actual?
3. Configuración relativamente simple, sin custom filters complejos

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener config actual.
Pros: Ya fixeado tree-sitter, estable.
Cons: No agregar features extras.
Riesgo: Ninguno.
```

#### Option B - Mejor UX
```
Agregar extensiones extra:
  - telescope-ui-select (better UI)
  - telescope-file-browser (explorer dentro de telescope)

No recomendado: duplica Nvim-tree functionality.
Riesgo: Medio.
```

#### Option C - Simplificación
```
Ya es simple. No requiere cambios.

Mantener: find_files, oldfiles, live_grep, grep_string, todo search
```

**Acción:** Keep (estable, fix aplicado)

---

### 2. Nvim-tree ✅ COMPLETO (Keep ee*)

**Estado:** ✅ Bien configurado (keep ee* por user decision)

**Configuración actual:**
```lua
view = { width = 40, relativenumber = true }
renderer = { indent_markers = { enable = true } }
filters = { custom = { ".DS_Store", "node_modules", "vendor" } }
git = { enable = true, ignore = false }
actions = { open_file = { quit_on_open = false, resize_window = true } }
```

**Keymaps actuales:**
```lua
<leader>ee  -- tree toggle
<leader>ef  -- focus current file
<leader>ec  -- collapse explorer
<leader>er  -- refresh
```

**Problemas detectados:**
1. **Prefijo inconsistente:** `<leader>ee/ef/ec/er` vs Telescope `<leader>ff/fs`
   - `e*` = explorer, `f*` = find - OK
   - Pero ¿por qué no `<leader>ex` explorer? (consistente con Telescope `<leader>xx` trouble)

2. **Configuración pesada:** Nvim-tree carga en startup (cmd + keys)
   - `width = 40` puede ser personalizable por usuario
   - `relativenumber` en tree = ¿útil? Puede ser ruido visual

3. **Custom filters:** `.DS_Store`, `node_modules`, `vendor`
   - ¿Faltan `.git` (ya oculto por tree)?
   - ¿Suficientes filtros?

**Opciones (A/B/C):**

#### Option A - Conservadora ✅ **ELEGIDA POR USUARIO**
```
Mantener config actual.
Pros: Funcional, estable.
Cons: Prefijo e* vs f* menos coherente.
Riesgo: Bajo.

Usuario decisión: Keep ee* (no cambio).
```

#### Option B - Mejor UX
```
Ajustes menores (no elegida):
  1. Cambiar <leader>ee* → <leader>xe* (x = explorer)
  2. Configuración opcional (width, icons.show)
  3. Filtros adicionales

Pros: Más coherencia en prefijos
Cons: Cambio de keymaps
Riesgo: Medio (keymaps)
```

**Acción:** Keep (Option A elegida)

---

### 3. Trouble ✅ COMPLETO (Simplify keymaps)

**Estado:** ✅ Bien lazy-load (keys)

**Configuración actual:**
```lua
dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" }
```

**Keymaps actuales:**
```lua
<leader>xx  -- toggle trouble
<leader>xw  -- workspace diagnostics
<leader>xd  -- document diagnostics
<leader>xq  -- quickfix
<leader>xl  -- loclist
<leader>xt  -- todos
```

**Problemas detectados:**
1. **Prefijo coherente:** `<leader>x*` = x = list/diagnostics (OK)
2. **¿Se usan todos?**
   - `xw` workspace diagnostics - ¿útil?
   - `xd` document diagnostics - ¿útil?
   - `xq` quickfix - ¿usar `<leader>co` en built-in?
   - `xl` loclist - ¿usar `<leader>cq?`

3. **Dependencies:** `todo-comments.nvim` - ¿necesario?

**Análisis de uso:**

| Keymap | ¿Útil? | Frecuencia |
|--------|--------|-----------|
| <leader>xx | Toggle trouble | Alta |
| <leader>xw | Workspace diagnostics | Media |
| <leader>xd | Document diagnostics | Baja |
| <leader>xq | Quickfix | Baja (built-in) |
| <leader>xl | Loclist | Baja (built-in) |
| <leader>xt | TODOs en trouble | **ALTA** |

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener todos los keymaps.
Pros: Flexibilidad total.
Cons: Keymaps no usados acumulan.
```

#### Option B - Mejor UX ✅ **ELEGIDA POR USUARIO**
```
Simplificar a 3 keymaps alto valor:
  <leader>xx  -- toggle
  <leader>xt  -- todos (HIGH VALOR)
  <leader>xw  -- workspace diagnostics (MEDIO)

  Quitar baja utilidad (usar built-in):
    <leader>xd (doc diag) → usar <leader>gd (LSP diagnostics)
    <leader>xq (quickfix) → usar :copen
    <leader>xl (loclist) → usar :lopen

Pros: Menos keymaps, menos confusión.
Cons: Perdida de shortcuts para casos edge.
Riesgo: Bajo.

**Commit:** `4a0f304` - refactor(trouble): simplify keymaps to high-value only
```

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Performance | Opción preferida | Riesgo |
|--------|--------|-------------|-------------|-----------------|--------|
| Telescope | ✅ Fix tree-sitter | Estable, branch 0.1.x | Good (cmd) | A (keep) | None |
| Nvim-tree | ✅ Keep ee* | Prefijo e* (OK) | Good (cmd) | A (keep) | None |
| Trouble | ✅ Simplificado | 3 keymaps alto valor | Good (keys) | B (simplify) | Bajo |

---

## Cambios Aplicados

### Cambio 1: Trouble keymaps simplify ✅ (commit `4a0f304`)
```
Mantener solo alto valor (3 keymaps):
  <leader>xx  -- toggle trouble (HIGH)
  <leader>xt  -- todos (HIGH)
  <leader>xw  -- workspace diagnostics (MEDIO)

Quitados baja utilidad (xd/xq/xl):
  <leader>xd (doc diag) → usar <leader>gd (LSP diagnostics)
  <leader>xq (quickfix) → usar :copen
  <leader>xl (loclist) → usar :lopen

Commit: refactor(trouble): simplify keymaps to high-value only

Verificación:
  <leader>xt -- todos en trouble
  <leader>xx -- toggle trouble
  <leader>xw -- workspace diagnostics
```

### Cambio 2: Nvim-tree keep ee* (no change) ✅
```
Mantener <leader>ee* (prefijo actual por user decision):

  <leader>ee  -- explorer toggle
  <leader>ef  -- focus current file
  <leader>ec  -- collapse explorer
  <leader>er  -- refresh

Usuario respuesta: Keep ee* (no change).
```

---

## Verificación Usuario Respuesta

**Preguntas respondidas:**

1. **Trouble keymaps:** ¿Usar `<leader>xd/document/xq/xl`?
   - **Usuario:** Simplificar a alto valor (xx/xt/xw)
   - **Aplicado:** ✅ Commit `4a0f304`

2. **Nvim-tree prefijo:** ¿Cambiar `<leader>ee*` → `<leader>xee*`?
   - **Usuario:** Keep ee* (sin cambio)

3. **Telescope:** ¿Agregar extensiones?
   - **N/A** (respondido en baseline)

---

## Pendientes / Riesgos

**Pendientes:**
- [x] Feedback de usuario sobre Trouble keymaps → Simplificar a 3 (aplicado)
- [x] Feedback de usuario sobre Nvim-tree prefijo → Keep ee* (no cambio)

**Riesgos:**
- Keymaps changes → bajo riesgo ( Trouble simplificado solo 1 commit)

---

**Estado Slice 2:**
- ✅ Diagnóstico completo
- ✅ Cambios aplicados (1 commit: 4a0f304)
- ✅ Doc actualizada

**Comits Slice 2:**
```
4a0f304 refactor(trouble): simplify keymaps to high-value only
```

**Total commits (todos):** 16 (incluyendoSlice1 + fixes previos)