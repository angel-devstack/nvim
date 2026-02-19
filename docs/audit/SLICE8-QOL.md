# Slice 8 - Quality of Life (QoL plugins)

**Fecha:** 2026-02-19  
**Status:** 🟡 Diagnóstico completo, preguntas pendientes

---

## Plugins Auditados

| Plugin | Event/Trigger | Startup Impact | Función |
|---------|--------------|----------------|---------|
| **autopairs** | `event = "InsertEnter"` | ~0ms (lazy) | Auto cerrar pares ()[]"" |
| **comment** | `event = { "BufReadPre", "BufNewFile" }` | ~710ms (ts_context_commentstring) | Comentar/descomentar código |
| **nvim-surround** | `keys = { ys, yss, yS, S, gS, ds, cs }` | ~0ms | Rodear texto con chars |
| **vim-endwise** | `event = "InsertEnter"` | ~0ms | Auto completar end (Ruby) |
| **nvim-treesitter-textobjects** | `lazy = true` | ~0ms (carga con treesitter) | Text objects avanzados |
| **todo-comments** | `event = { "BufReadPre", "BufNewFile" }` | ~0ms o ligero | Highlight TODOs |
| **which-key** | `event = "VeryLazy"` | ~0ms | Mostrar posibles keymaps |

---

## Diagnóstico por Plugin

### 1. nvim-autopairs (autopairs.lua)

**Configuración actual:**
```lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",  -- Solo carga en modo insert
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },  -- No add pairs in lua strings
        javascript = { "template_string" },
        java = false,
      },
    })
    -- Integración con nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
```

Estado: ✅ **Bien configurado (lazy-load con `event = "InsertEnter"`)**

Razones:
- Solo carga en modo Insert (no afecta startup)
- Integración con nvim-cmp para completar pares automáticamente
- Configura exclusiones para evitar conflictos (lua strings, JS templates, java)
- No se necesita cambio

---

### 2. Comment.nvim (comment.lua) ⚠️

**Configuración actual:**
```lua
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },  -- Carga buffer por buffer
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",  -- 710ms startup OFFENDER
  },
  config = function()
    comment.setup({
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
```

**Estado:** ⚠️ **ts_context_commentstring es el 3er mayor offender de startup (710ms)**

Baseline muestra:
```
| ts_context_commentstring (internal+config+utils) | 710 | Syntax | Comment context para TS/JS |
```

**Función:** Context-aware comments (comentar correctamente en TS/JS/templating languages):
- Detecta si estás en JSX/HTML/JS template string dentro de TS/TSX
- Cambia comments de `//` (JS) a `<!-- -->` (HTML) automáticamente

**Análisis:**
- **Startup impact:** 710ms (muy alto, es 4.5x el baseline 156ms)
- **Última decisión usuario (Slice 3):** Mantener todos packages (útiles para productividad)
- **Alternativas:** Comentador simple sin ts_context_commentstring (perder contexto pero ganar ~700ms)

**Recomendación:** Revisar frecuencia de uso de TS/JS templating para decidir.

---

### 3. nvim-surround (nvim-surround.lua)

**Configuración actual:**
```lua
return {
  "kylechui/nvim-surround",
  keys = {
    { "ys", mode = "n", desc = "Surround" },
    { "yss", mode = "n", desc = "Surround line" },
    { "yS", mode = "n", desc = "Surround line (newline)" },
    { "S", mode = "v", desc = "Surround selection" },
    { "gS", mode = "v", desc = "Surround lines" },
    { "ds", mode = "n", desc = "Delete surround" },
    { "cs", mode = "n", desc = "Change surround" },
  },
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        normal = "ys", -- "you surround"
        normal_cur = "yss",
        normal_line = "yS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
      },
    })

    -- JS/TS ${...} syntax
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      callback = function()
        require("nvim-surround").buffer_setup({
          surrounds = {
            ["$"] = { add = function() return { "${", "}" } end, ... },
          },
        })
      end,
    })
  end,
}
```

Estado: ✅ **Bien configurado (lazy-load con `keys = {}` trigger)**

Razones:
- Solo carga cuando presionas `ys`, `yss`, `yS`, `S`, `gS`, `ds`, `cs`
- Configura especiales para JS/TS (`${}` syntax)
- No afecta startup
- Keymaps usan `:` para property, `=` para assignment, `i`/`a` prefixes (ver abajo)

**Keymaps definidos:**
| Modo   | Comando | Acción                               | Ejemplo                |
| ------ | ------- | ------------------------------------ | ---------------------- |
| Normal | `ysiw"` | Rodea palabra con comillas dobles    | `word` → `"word"`       |
| Normal | `yss(`  | Rodea línea completa con paréntesis  | `line` → `(line)`       |
| Normal | `yS{`   | Rodea línea completa con llaves      | `line` → `{line}`      |
| Visual | `S"`    | Rodea selección visual con comillas  | seleccionas → `"texto"` |
| Visual | `gS[`   | Rodea línguas seleccionadas con `[ ]` | linhas → `[ ... ]`     |
| Normal | `ds'`   | Elimina comillas simples             | `'texto'` → `texto`     |
| Normal | `cs'"`  | Cambia simples a dobles             | `'text'` → `"text"`     |

---

### 4. vim-endwise (vim-endwise.lua)

**Configuración actual:**
```lua
return {
  "tpope/vim-endwise",
  event = "InsertEnter",  -- Solo carga en modo insert
}
```

Estado: ✅ **Bien configurado (lazy-load con `event = "InsertEnter"`)**

Razones:
- Solo carga en modo InsertRuby (y otros langs) para completar `end`keywords (def, module, if, etc.)
- Simplifica flujo de programaciónRuby (no necesitas escribir `end` después de cada bloque)
- No afecta startup

---

### 5. nvim-treesitter-text-objects (nvim-treesitter-text-objects.lua)

**Configuración actual:**
```lua
return {
  "nvim-treesitter/nvim-treesitter-text-objects",
  lazy = true,  -- Carga con treesitter (treesitter es lazy)
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,  -- Jump forward to textobj (como targets.vim)
          keymaps = {
            ["a="] = "@assignment.outer",
            ["i="] = "@assignment.inner",
            ["l="] = "@assignment.lhs",
            ["r="] = "@assignment.rhs",

            ["a:"] = "@property.outer",
            ["i:"] = "@property.inner",
            ["l:"] = "@property.lhs",
            ["r:"] = "@property.rhs",

            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",

            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",

            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",

            ["af"] = "@call.outer",
            ["if"] = "@call.inner",

            ["am"] = "@function.outer",
            ["im"] = "@function.inner",

            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner",
            ["<leader>n:"] = "@property.outer",
            ["<leader>nm"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner",
            ["<leader>p:"] = "@property.outer",
            ["<leader>pm"] = "@function.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@call.outer", ... },
          goto_next_end = { ["]F"] = "@call.outer", ... },
          goto_previous_start = { ["[f"] = "@call.outer", ... },
          goto_previous_end = { ["[F"] = "@call.outer", ... },
        },
      },
    })
  end,
}
```

Estado: ✅ **Bien configurado (carga lazy con treesitter)**

Razones:
- `lazy = true` carga solo cuando treesitter lo necesita
- Configura text objects semánticos (assignment, property, parameter, conditional, loop, call, function, class)
- Configura move/swop commands: `]f/[f` (next/prev function), `]m/[m` (method), etc.
- Configura repeatable move con `;` y `,` (repita último movimiento)
- Builtin `fFtT` repeatable también

**Keymaps definidos:**
| Tipo | Keymap | Acción |
|-----|--------|-------|
| **Select** | `a=`/`i=` | Outer/inner assignment (`x = y`) |
| **Select** | `a:`/`i:` | Outer/inner property (`obj.prop = x`) |
| **Select** | `aa`/`ia` | Outer/inner parámetro `(param)` |
| **Select** | `ai`/`ii` | Outer/inner conditional (`if ... end`) |
| **Select** | `al`/`il` | Outer/inner loop (`for ... end`) |
| **Select** | `af`/`if` | Outer/inner function call |
| **Select** | `am`/`im` | Outer/inner function definition |
| **Select** | `ac`/`ic` | Outer/inner class |
| **Swap** | `<leader>na`/`<leader>pa` | Swap parameter con next/prev |
| **Swap** | `<leader>n:`/`<leader>p:` | Swap property con next/prev |
| **Swap** | `<leader>nm`/`<leader>pm` | Swap function con next/prev |
| **Move** | `]f`/[f]` | Jump next/prev function call |
| **Move** | `]m`/[m]` | Jump next/prev method definition |
| **Move** | `]c`/[c]` | Jump next/prev class |
| **Move** | `]i`/[i]` | Jump next/prev conditional |
| **Move** | `]l`/[l]` | Jump next/prev loop |
| **Move** | `;`/`,` | Repeat last move (vim-way) |

---

### 6. todo-comments (todo-comments.lua)

**Configuración actual:**
```lua
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },  -- Carga buffer por buffer
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  },
  config = function()
    require("todo-comments").setup()
  end,
}
```

Estado: ⚠️ **Carga buffer por buffer (`event = { "BufReadPre", "BufNewFile" }`)**

Razones:
- `BufReadPre`/`BufNewFile` carga el plugin cada vez que abres o creas un archivo
- Carga temprano puede afectar startup de cada buffer
- Alternativa: `event = "VeryLazy"` (carga solo después de todos plugins)
- Alternativa: `keys = { "[t", "]t" }` (carga solo cuando usas jump prev/next TODO)

**Funcionalidad:** Highlight TODO comments (TODO, FIXME, HACK, XXX, etc.) con colores distintivos y navegación rápida con `[t`/`]t`.

---

### 7. which-key (which-key.lua)

**Configuración actual:**
```lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",  -- Carga después de todos plugins
  config = function()
    local wk = require("which-key")
    wk.setup()
    -- Groups registrados
    wk.add({
      { "<leader>f", group = "🔍 Find" },
      { "<leader>w", group = "🪟 Window/Workspace" },
      { "<leader>wt", group = "📑 Tabs" },
      { "<leader>ws", group = "✂️  Splits" },
      { "<leader>e", group = "📁 Explorer" },
      { "<leader>g", group = "🎨 Git" },
      { "<leader>gh", group = "⛳ Hunk" },
      { "<leader>t", group = "🧪 Test" },
      { "<leader>c", group = "🧹 Code" },
      { "<leader>d", group = "🐛 Debug" },
      { "<leader>a", group = "🔀 Align" },
      { "<leader>r", group = "🌐 Rest/HTTP" },
    })
  end,
}
```

Estado: ✅ **Perfectamente configurado (`event = "VeryLazy"`)**

Razones:
- `VeryLazy` no afecta startup (carga solo después de todos plugins)
- No impacta en ninguna tecla que el usuario presiona
- Muestra possible keymaps cuando no has completado un `<leader>` + key
- Útil para discoverability en un setup complejo

---

## Preguntas para el Usuario

### 1. Comment.nvim + ts_context_commentstring (710ms offender)

**Contexto:** ts_context_commentstring es el 3er mayor offender de startup (710ms) porque carga por completo en BufferReadPre. Proporciona comments context-aware para TS/JS/templating languages (detecta si estás en JSX/HTML/JS template string).

**Pregunta:** ¿Con qué frecuencia programas en TypeScript/JavaScript con JSX/HTML?

- [ ] **Frecuentemente** → Mantener Comment.nvim con ts_context_commentstring (710ms impact, útil para TS/JS)
- [ ] **Raramente o nunca** → Simplificar Comment.nvim sin ts_context_commentstring (~700ms ganancia, perder contexto)

---

### 2. todo-comments (carga inmediata)

**Contexto:** `event = { "BufReadPre", "BufNewFile" }` carga plugin cada vez que abres/creas archivo. Todo-comments highlights TODO/comments con colores.

**Pregunta:** ¿Con qué frecuencia usas `[t`/`]t` para navegar TODO comments?

- [ ] **Frecuentemente** → Mantener `event = { "BufReadPre", "BufNewFile" }` (load inmediata, highlights siempre)
- [ ] **Raramente** → Cambiar a `keys = { "[t", "]t" }` (carga solo cuando lo usas, ~0-50ms ganancia)

---

### 3. which-key (ya VeryLazy, pero verify)

**Contexto:** ya configurado como `VeryLazy` (correcto). Pregunta es: ¿finds which-key útil?

**Pregunta:** ¿Te parece útil which-key (popup de posibles keymaps)?

- [ ] **Sí, útil** → Mantener como está (no cambio)
- [ ] **No, prefiero sin popup** → Eliminar plugin (ver keymaps manualmente/registrados en docs, ~10-20ms ganancia)

---

## Propuestas de Cambios

### Propuesta 1: Comment.nvim (Dependiente de Respuesta Pregunta 1)

**Opción A:** Mantener configuración actual ✅
- No cambios
- Beneficio: Comments context-aware en TS/JS
- Costo: 710ms startup impact

**Opción B:** Simplificar Comment.nvim sin ts_context_commentstring
- Quitar `ts_context_commentstring` dependency
- Remover `pre_hook = ts_context_commentstring.create_pre_hook()`
- Beneficio: Ganancia de ~700ms startup
- Costo: Comments sin contexto (siempre usa `//` en TS/JS incluso en JSX/HTML)

```lua
-- lua/angel/plugins/editing/comment.lua
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup()
    -- Sin pre_hook (sin ts_context_commentstring)
  end,
}
```

**Opción C:** Mover ts_context_commentstring a VeryLazy
- Solo carga cuando empiezas a comentar
- Requiere manual-trigger en el primer uso
- Complejidad añadida: Necesitar autocmd o keymap para cargar tardía

---

### Propuesta 2: todo-comments (Dependiente de Respuesta Pregunta 2)

**Opción A:** Mantener `event = { "BufReadPre", "BufNewFile" }` ✅
- No cambios
- Beneficio: Highlights disponibles inmediatamente
- Costo: Possible impacto de startup por buffer (unknown, ~0-50ms)

**Opción B:** Cambiar a `keys = { "[t", "]t" }`
- Solo carga cuando presionas `[t` o `]t`
- Beneficio: Carga demanda, ~0-50ms ganancia
- Costo: No highlights TODOs disponibles hasta primer uso

```lua
-- lua/angel/plugins/tools/todo-comments.lua
return {
  "folke/todo-comments.nvim",
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  },
  config = function()
    require("todo-comments").setup()
  end,
}
```

---

### Propuesta 3: which-key (Dependiente de Respuesta Pregunta 3)

**Opción A:** Mantener `event = "VeryLazy"` ✅
- No cambios (ya muy bien configurado)
- Beneficio: Discoverability de keymaps
- Costo: Ninguno (VeryLazy no añade startup time)

**Opción B:** Eliminar plugin
- Quitar `which-key.lua`
- Beneficio: ~10-20ms startup reducción (muy pequeña)
- Costo: Perder popup de possible keymaps (documentación en docs/user-guide/KEYMAP_REGISTRY.md sigue disponible)

---

## Impacto en Performance

### Baseline Startup
- **Total baseline:** ~156ms
- **ts_context_commentstring:** 710ms (3er mayor offender)
- **Todo-comments:** ~0-50ms (unknown exacta)
- **which-key:** ~0ms (VeryLazy)

### Posible Ganancia
- **Sin cambios:** 0ms ganancia (todo actual)
- **Con cambio B en Comment.nvim:** ~700ms ganancia
- **Con cambio B en todo-comments:** ~0-50ms ganancia
- **Sin which-key:** ~10-20ms ganancia
- **Max ganancia total:** ~730ms (710 + 20)

### Startup Actual Después de DAP+Gitsigns
- **Projected startup:** ~260ms (baseline 156ms - 900ms ganancias previas)
- **Con ganancias adicionales:** ~260ms - ~730ms = ~???ms (no puede ser negativo, significa ganancias max ya alcanzadas)

---

## Keymaps de QoL (Resumen)

### nvim-surround (sin cambios)
| Modo   | Keymap | Acción | Ejemplo |
|--------|-------|--------|---------|
| Normal | `ysiw"` | Rodear palabra con comillas dobles | `word` → `"word"` |
| Normal | `yss(`  | Rodear línea completa con paréntesis | `line` → `(line)` |
| Normal | `yS{`   | Rodea línea completa con llaves | `line` → `{line}` |
| Visual | `S"`    | Rodea selección visual con comillas | selección → `"texto"` |

### nvim-treesitter-text-objects (sin cambios)
| Tipo | Keymap | Acción |
|-----|--------|-------|
| Select | `a=`/`i=` | Outer/inner assignment |
| Select | `a:`/`i:` | Outer/inner property |
| Swap | `<leader>na`/`pa` | Swap parameter next/prev |
| Move | `]f`/`[f` | Jump next/prev function call |
| Repeat | `;`/`,` | Repeat last move |

### todo-comments (dependiente de respuesta 2)
- `[t`/`]t` - Jump prev/next TODO comment

### which-key (dependiente de respuesta 3)
- Popup de keymaps después de `<leader>` + key incomplete

---

## Estado Final de Slice 8

⏸️ **Esperando respuestas del usuario** a 3 preguntas antes de implementar cambios.

---

**Documentación pendiente:**
- `docs/audit/SLICE8-REPORT-FINAL.md` (una vez implementadas respuestas)

**Siguiente paso:** El usuario debe responder 3 preguntas y luego implementaré cambios con commits atómicos.