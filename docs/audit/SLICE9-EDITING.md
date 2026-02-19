# Slice 9 - Editing Plugins

**Fecha:** 2026-02-19  
**Status:** 🟡 Diagnóstico completo

---

## Plugins Auditados

| Plugin | Event/Trigger | Startup Impact | Función |
|---------|--------------|----------------|---------|
| **substitute** | `keys = { s, ss, S }` | ~0ms | Substitute texto (más potente que builtin `s`) |
| **splitjoin** | `keys = { gS, gJ }` | ~0ms | Split/join arguments/params multilínea |
| **tabular** | `keys = { <leader>a=, a:, a, }` + `cmd = Tabularize` | ~0ms | Align text por delimiter |
| **sort** | `keys = { <leader>so }` + `cmd = Sort, SortLines, SortWords` | ~0ms | Sort selección por líneas/palabras |
| **vim-maximizer** | `keys = { <leader>wsm }` | ~0ms | Maximize/minimize split window |

---

## Diagnóstico por Plugin

### 1. substitute.nvim (substitute.lua)

**Configuración actual:**
```lua
return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "s",
      function() require("substitute").operator() end,
      desc = "Substitute with motion",
    },
    {
      "ss",
      function() require("substitute").line() end,
      desc = "Substitute line",
    },
    {
      "S",
      function() require("substitute").eol() end,
      desc = "Substitute to end of line",
    },
    {
      "s",
      function() require("substitute").visual() end,
      mode = "x",
      desc = "Substitute (visual)",
    },
  },
  config = function()
    require("substitute").setup()
  end,
}
```

Estado: ✅ **Bien configurado (lazy-load con `keys = {}` trigger)**

**Funcionalidad:**
- `s motion` - Substitute con motion (ej: `s w` reemplaza palabra con lo que tipos, sin abrir replace mode)
- `ss` - Substituye línea completa con lo que tipos
- `S` - Substitute hasta fin de línea
- `s` (visual) - Substitute selección visual

**Conflictos:**
- **COLISIÓN con builtin `s` key:** En modo normal, `s` es `cl` (delete + insert mode)
- **Riesgo:** Plugin sobreescribe builtin `s` key (puede romper comportamiento nativo)

**Recomendación:** Verificar si usuario usa builtin `s` (si no, OK. Si sí, cambiar keymaps).

**Uso común de builtin `s`:**
- `s c` = lanza replace mode en character under cursor + insert (similar a `r` pero es more destructive)
- La mayoría de usuarios NO usan `s` builtin (prefiere `r` o `ciw`)

---

### 2. splitjoin.vim (splitjoin.lua)

**Configuración actual:**
```lua
return {
  "AndrewRadev/splitjoin.vim",
  keys = {
    { "gS", desc = "Split arguments/params" },
    { "gJ", desc = "Join arguments/params" },
  },
}
```

Estado: ⚠️ **Configuración incorrecta para lazy.nvim**

**Problema:**
1. `desc = "..."` en keys no es suficiente - lazy.nvim necesita keymaps definidos correctamente
2. Keymaps `gS` y `gJ` no están definidos como funciones o commands
3. Plugin carga siempre (sin lazy-charge real)

**Corrección necesaria:** Lazy.nvim necesita `keys = { "gS", "gJ" }` o `cmd = "SplitJoin"` para cargar on-demand.

**Funcionalidad:**
- `gS` - Split arguments/params multilínea a una línea por argumento
- `gJ` - Join arguments/params de multilínea a una línea
- Útil para: function calls, array declarations, object literals, etc.

---

### 3. tabular (misc/tabular.lua)

**Configuración actual:**
```lua
return {
  "godlygeek/tabular",
  cmd = { "Tabularize" },
  keys = {
    -- Changed from <leader>ta* to <leader>a* to avoid conflict with Testing
    { "<leader>a=", ":Tabularize /=<CR>", desc = "Align by '='" },
    { "<leader>a:", ":Tabularize /:<CR>", desc = "Align by ':'" },
    { "<leader>a,", ":Tabularize /,<CR>", desc = "Align by ','" },
  },
}
```

Estado: ✅ **Bien configurado (lazy-load con `cmd = {}` y `keys = {}`)**

**Funcionalidad:**
- `<leader>a=` - Align text por `=` (útil para props/assignments: `key1 = value`, `key2 = value`)
- `<leader>a:` - Align text por `:` (útil para configs: `key: value`, `key: value`)
- `<leader>a,` - Align text por `,` (útil para arrays/lists: `1, 2, 3` → `1, 2, 3`)

**Notes:**
- Plugin es OLD (archived en GitHub pero mantenido por comunidad)
- Alternativa moderna: `echasnovski/mini.align` o `jbyuki/nabla`
- Pero funciona correctamente, no se necesita cambio

---

### 4. sort.nvim (misc/sort.lua)

**Configuración actual:**
```lua
return {
  "sQVe/sort.nvim",
  cmd = { "Sort", "SortLines", "SortWords" },
  keys = {
    { "<leader>so", "<cmd>Sort<CR>", desc = "Sort selection" },
  },
  config = function()
    require("sort").setup()
  end,
}
```

Estado: ✅ **Bien configurado (lazy-load con `cmd = {}` y `keys = {}`)**

**Funcionalidad:**
- `:Sort` - Sort selección por líneas
- `:SortLines` - Sort líneas seleccionadas
- `:SortWords` - Sort palabras seleccionadas
- `<leader>so` - Sort selección visual

**Keymap:** `<leader>so` (sort)

---

### 5. vim-maximizer (misc/vim-maximizer.lua)

**Configuración actual:**
```lua
return {
  "szw/vim-maximizer",
  keys = {
    -- Changed from <leader>sm to <leader>wsm to group with Window operations
    { "<leader>wsm", "<cmd>MaximizerToggle<CR>", desc = "Toggle Maximize/Minimize a Split" },
  },
}
```

Estado: ✅ **Bien configurado (lazy-load con `keys = {}`)**

**Funcionalidad:**
- `<leader>wsm` - Toggle maximize/minimize un split window
- Útil cuando quieres focal en un buffer grande

**Grouping:** `w` prefix para Window operations (correcto según keymap registry)

---

## Preguntas para el Usuario

### 1. substitute.nvim (conflicto con builtin `s` key)

**Contexto:** substitute.nvim sobreescribe builtin `s` key en modo normal (que es `cl` - delete + insert mode). La mayoría de usuarios NO usa builtin `s`.

**Pregunta:** ¿Usas builtin `s` key (s motion) de Neovim?

- [ ] **No, no uso builtin `s`** → Mantener substitute.nvim (más potente que builtin, `s motion` sin abrir replace)
- [ ] **Sí, uso builtin `s`** → Cambiar keymaps de substitute (ej: `<leader>sub` en vez de `s`)

---

### 2. splitjoin.vim (configuración incorrecta)

**Contexto:** Configuration actual tiene solo `desc = "..."` en `keys = {}`, pero lazy.nvim no puede usar eso para lazy-loading. Plugin CARGA SIEMPRE.

**Pregunta:** ¿Cómo quieres reparar splitjoin?

- [ ] **Arreglar lazy-loading con `keys = { "gS", "gJ" }`** → Lazy-load on-demand (cuando uses gS/gJ)
- [ ] **Eliminar plugin completar** → No uso splitjoin (ganancia ~0-10ms, funcionalidad simple con nvim-surround)

---

### 3. tabular (alternativa moderna)

**Contexto:** tabular es un plugin archivado (old), pero funciona. Alternativas modernas son más mantenidas (mini.align, nabla).

**Dato:** Nota en baseline dice "tabular - align text (archivado?)", lo que indica usuario puede estar considering eliminarlo.

**Pregunta:** ¿Quieres mantener tabular o eliminarlo?

- [ ] **Mantener tabular** → Funciona correctamente (keymaps `<leader>a=`, `a:`, `a,` alinean texto)
- [ ] **Eliminar tabular** → Ganancia ~0-10ms (plugin archivado, usar align manual)

---

## Propuestas de Cambios

### Propuesta 1: substitute.nvim (Dependiente de Respuesta Pregunta 1)

**Opción A:** Mantener configuración actual ✅
- No cambios
- Beneficio: Functionalidad más potente que builtin (`s motion` sin abrir replace mode)
- Costo: Colisión con builtin `s`

**Opción B:** Cambiar keymaps para evitar colisión
- Cambiar `s`/`ss`/`S` a `<leader>sub`/`<leader>su`/`<leader>sus` (o similar)
- Beneficio: No conflict con builtin `s`
- Costo: Need aprender nuevos keymaps (menos mnemonic que `s motion`)

---

### Propuesta 2: splitjoin.vim (Dependiente de Respuesta Pregunta 2)

**Opción A:** Arreglar lazy-loading con `keys = { "gS", "gJ" }` ✅
- Cambiar `keys = { { "gS", desc = "..." }, { "gJ", desc = "..." } }` a `keys = { "gS", "gJ" }`
- Beneficio: Lazy-load on-demand (no carga siempre)
- Costo: Ninguno (mismo keymaps)

**Opción B:** Eliminar plugin
- Borrar archivo `lua/angel/plugins/editing/splitjoin.lua`
- Beneficio: Ganancia ~0-10ms (plugin raramente usado)
- Costo: Perder split/join functionality (puede hacer manual)

```lua
-- Archivo: lua/angel/plugins/editing/splitjoin.lua
return {
  "AndrewRadev/splitjoin.vim",
  keys = { "gS", "gJ" },  -- FIX: Cambiado de desc-only a key specification
}
```

---

### Propuesta 3: tabular (Dependiente de Respuesta Pregunta 3)

**Opción A:** Mantener tabular ✅
- No cambios
- Beneficio: Alignment funcionalidad (keymaps `<leader>a=`, `a:`, `a,`)
- Costo: Plugin archivado (pero funciona)

**Opción B:** Eliminar tabular
- Borrar archivo `lua/angel/plugins/misc/tabular.lua`
- Beneficio: ~0-10ms startup reducción
- Costo: Perder alignment functionality (podría alinear manual)

---

## Impacto en Performance

### Plugins con configuración correcta (sin cambios)
- **substitute:** ~0ms (keys trigger, ya lazy-loaded)
- **tabular:** ~0ms (cmd + keys trigger)
- **sort:** ~0ms (cmd + keys trigger)
- **vim-maximizer:** ~0ms (keys trigger)

### Plugins con configuración incorrecta
- **splitjoin:** Carga siempre (estimated ~0-10ms impact - plugin muy ligero)

**Total ganancia posible:**
- Si arreglar splitjoin (keys lazy-load): ~0-10ms
- Si eliminar tabular: ~0-10ms
- **Total máximo:** ~20ms ganancia (muy pequeña)

**Startup impact principal:** Estos plugins YA están bien lazy-loaded en su mayoría. El problema solo es splitjoin (carga siempre) pero impact es minúsculo.

---

## Keymaps de Editing Plugins

### substitute.nvim (dependiente de respuesta 1)
| Modo   | Keymap | Acción |
|--------|-------|--------|
| Normal | `s motion` | Substitute con motion (sin abrir replace) |
| Normal | `ss` | Substitute línea completa |
| Normal | `S` | Substitute hasta fin de línea |
| Visual | `s` | Substitute selección |

### splitjoin.vim (dependiente de respuesta 2)
| Modo   | Keymap | Acción |
|--------|-------|--------|
| Normal | `gS` | Split arguments/params multilínea |
| Normal | `gJ` | Join arguments/params a una línea |

### tabular (dependiente de respuesta 3)
| Modo   | Keymap | Acción |
|--------|-------|--------|
| Normal | `<leader>a=` | Align por `=` (ej: assignments) |
| Normal | `<leader>a:` | Align por `:` (ej: configs) |
| Normal | `<leader>a,` | Align por `,` (ej: arrays) |

### sort.nvim (sin cambios)
| Modo   | Keymap | Acción |
|--------|-------|--------|
| Normal | `<leader>so` | Sort selección |

### vim-maximizer (sin cambios)
| Modo   | Keymap | Acción |
|--------|-------|--------|
| Normal | `<leader>wsm` | Toggle maximize/minimize window |

---

## Estados de Configuración

| Plugin | Estado | Configuración | Necesita cambio? |
|--------|--------|---------------|------------------|
| substitute | ✅ Bien | `keys = {}` | Solo si builtin `s` collision |
| splitjoin | ⚠️ Mal | `desc =` solo | SÍ - necesita `keys = { "gS", "gJ" }` |
| tabular | ✅ Bien | `cmd = {}` + `keys = {}` | Solo si archivado |
| sort | ✅ Bien | `cmd = {}` + `keys = {}` | No |
| vim-maximizer | ✅ Bien | `keys = {}` | No |

---

## Estado Final de Slice 9

⏸️ **Esperando respuestas del usuario** a 3 preguntas antes de implementar cambios.

---

**Documentación pendiente:**
- `docs/audit/SLICE9-REPORT-FINAL.md` (una vez implementadas respuestas)

**Siguiente paso:** El usuario debe responder 3 preguntas y luego implementaré cambios con commits atómicos.