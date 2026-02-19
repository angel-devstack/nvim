# Slice 2: Navigation - Reporte Parcial

**Fecha:** 2025-02-18
**Slice:** Navigation (Telescope, Nvim-tree, Trouble)
**Estado:** ✅ Diagnóstico completo, cambios opcionales

---

## Resumen Ejecutivo

| Plugin | Estado | Diagnóstico | Cambio propuesto |
|--------|--------|-------------|-----------------|
| Telescope | ✅ Stable | tree-sitter fix aplicado | Ninguno |
| Nvim-tree | ✅ Well | Prefijo e* vs x* | Cambiar `<leader>ee*` → `<leader>xee*`? |
| Trouble | ⚠️ Keymaps extra | ¿Se usan todos? | Simplificar keymaps alto valor |

**Estado:** 0 cambios aplicados (3 cambios opcionales)

---

## 3 Plugins Analizados

### 1. Telescope ✅ STATUS: FIXED

**Fix aplicado (commit `6902005`):**
```lua
preview = { treesitter = false }
file_previewer = require("telescope.previewers").vim_buffer_cat.new
```

**No cambios requeridos** - plugin estable y funcional.

**Keymaps actuales:**
```lua
<leader>ff  -- find files
<leader>fr  -- recent files
<leader>fs  -- live grep
<leader>fc  -- grep_string (cursor)
<leader>ft  -- TODOs
```

**Acción:** Keep

---

### 2. Nvim-tree ⚠️ OPTIMAL: Prefijo coherencia [PREGUNTA 1]

**Problema:**
- Prefijo `<leader>ee/ef/ec/er` vs `<leader>xff/fs` (Telescope)
- `e*` = explorer, `f*` = find
- Trouble usa `<leader>xx` (x = list)
- ¿Por qué Nvim-tree no usa `<leader>x*` (x = explorer)?

**Propuesta:**
```lua
# Antes
<leader>ee  -- explorer toggle
<leader>ef  -- focus current file
<leader>ec  -- collapse explorer
<leader>er  -- refresh

# Después
<leader>xee -- explorer toggle
<leader>xef -- focus current file
<leader>xec -- collapse explorer
<leader>xer -- refresh
```

**¿Prefieres?**

| Opción | Keymaps | Pros/Cons | Riesgo |
|--------|---------|-----------|--------|
| A (Keep) | <leader>ee* | Menos cambio, usuario acostumbrado | None |
| B (Change) | <leader>xee* | Coincidente con Trouble x* (x = explorer/list) | Medio |

---

### 3. Trouble ⚠️ OPTIMAL: Simplificar keymaps [PREGUNTAS 2]

**Keymaps actuales (6):**
```lua
<leader>xx  -- toggle trouble (HIGH)
<leader>xw  -- workspace diagnostics (MEDIO)
<leader>xd  -- document diagnostics (BAJO)
<leader>xq  -- quickfix (BAJO - built-in)
<leader>xl  -- loclist (BAJO - built-in)
<leader>xt  -- todos (ALTA)
```

**Frecuencia estimada:**
- `xx` toggle: 🟢 Alta
- `xt` todos: 🟢 Alta
- `xw` workspace diag: 🟡 Media
- `xd` doc diag: 🔴 Baja
- `xq` quickfix: 🔴 Baja (usar :copen)
- `xl` loclist: 🔴 Baja (usar :lopen)

**Propuesta (simplificar a alto valor):**
```lua
# Mantener alto valor
<leader>xx  -- toggle trouble
<leader>xt  -- todos (HIGH)
<leader>xw  -- workspace diagnostics

# Quitar baja utilidad (built-in existe)
# <leader>xd -- usar <leader>gd (LSP diagnostics)
# <leader>xq -- usar :copen
# <leader>xl -- usar :lopen
```

**¿Prefieres?**

| Opción | Keymaps | Pros/Cons | Riesgo |
|--------|---------|-----------|--------|
| A (Keep todos) | xx/xw/xd/xq/xl/xt | Flexibilidad total, shortcuts para edge cases | Low |
| B (Simplify) | xx/xt/xw | Menos keymaps, menos confusión, usar built-in para otros | Low |

---

## Decisiones Pendientes (Opcionales)

### Decision 1: Nvim-tree prefijo
**¿Cambiar `<leader>ee*` → `<leader>xee*`?**
- Coerente con Trouble x* (x = explorer/list)
- Cambio 4 keymaps → medio riesgo (re-aprendizaje)

**Opciones:**
- ✅ Keep `<leader>ee*` (sin cambio)
- ✅ Change `<leader>xee*` (más coherente)

### Decision 2: Trouble keymaps simplify
**¿Mantenir 6 keymaps o simplificar a 3 alto valor?**
- Mantener todos = flexibilidad para casos edge
- Simplificar = menos confusión, usar built-in para otros

**Opciones:**
- ✅ Keep 6 keymaps (xx/xw/xd/xq/xl/xt)
- ✅ Simplificar a 3 (xx/xt/xw), quitar baja utilidad (xd/xq/xl)

---

## Próximo paso: Slice 3 - LSP + Completion

**Plugins en scope:**
- Mason (package manager)
- lspconfig (LSP servers config)
- nvim-cmp (completion engine)
- Luasnip (snippets)
- LSP diagnostics UI

**Metodología igual:** analizar cada plugin por purpose, load strategy, problems, performance.

---

**Estado Slice 2:**
- ✅ Diagnóstico completo
- ⏸️ 2 preguntas opcional para usuario (decidir cambios)
- ⏸️ Commits pendientes (después de aprobación)

**¿Quieres responder preguntas ahora (y aplicar cambios) o continuar Slice 3 sin cambios opcionales?**