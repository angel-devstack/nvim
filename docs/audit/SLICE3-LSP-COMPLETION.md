# Slice 3: LSP + Completion - Auditoría Neovim Config

**Fecha:** 2025-02-18
**Slice:** LSP + Completion (Mason, lspconfig, nvim-cmp, Luasnip)

---

## Baseline Slice 3

### Plugins involucrados

| Plugin | Archivo | Purpose (1 línea) | Load strategy actual |
|--------|---------|-------------------|---------------------|
| Mason | `plugins/lsp/mason.lua` | LSP/tools package manager | cmd = "Mason" |
| lspconfig | `plugins/lsp/lspconfig.lua` | LSP servers configuration | event = "BufReadPre" |
| nvim-cmp | `plugins/completion/nvim-cmp.lua` | Completion engine | event = "InsertEnter" |
| LuaSnip | `plugins/completion/nvim-cmp.lua` (dependency) | Snippets engine |
| friendly-snippets | `plugins/completion/nvim-cmp.lua` (dependency) | VSCode snippets |

**Notas:**
- Mason lazy-load con `cmd = "Mason"` ✅
- nvim-cmp lazy-load con `event = "InsertEnter"` ✅
- LSP servers cargados por lspconfig (ensure_installed auto)

---

## Diagnóstico por Plugin

### 1. Mason ✅ STATUS: Bien configurado

**Estado:** ✅ Bien lazy-load (cmd)

**Configuración actual:**
```lua
cmd = "Mason"  -- lazy-load
build = ":MasonUpdate"
dependencies = { mason-lspconfig, mason-tool-installer }
```

**ensure_installed:**
```
LSP servers (18):
  lua_ls, ruby_lsp, pyright, rust_analyzer,
  html, cssls, emmet_ls, svelte, tailwindcss, ts_ls,
  graphql, marksman, bashls, dockerls, jsonls, yamlls

Tools (8):
  stylua, prettier, shfmt, rubocop,
  ruff, eslint_d,
  debugpy, node-debug2-adapter, codelldb
```

**Problemas detectados:**
1. **¿Too many ensure_installed?**
   - 18 LSP servers + 7 tools = 26 packages
   - Puede ser pesado en primera instalación

2. **¿No usadas?**
   - graphql, marksman, bashls, dockerls → ¿usas regularmente?
   - debugpy, node-debug2-adapter, codelldb → ¿usas DAP regularmente?

3. **Load strategy OK:**
   - `cmd = "Mason"` = lazy (no carga en startup) ✅

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener todos los ensure_installed.
Pros: Todo disponible instantáneamente cuando es necesario.
Cons: Primera instalación lenta (uno-off).
Riesgo: Bajo (solo primera instalación).

Razonamiento: Solo afecta primera instalación. Después, cacheado.
```

#### Option B - Mejor UX
```
Separar ensure_installed en 2 categorías:
  - essentials: lua_ls, ruby_lsp, pyright, ts_ls, ruff, rubocop
  - opcionals: graphql, marksman, bashls, dockerls, jsonls, yamlls
  - debuggers: debugpy, node-debug2-adapter, codelldb

En first-run, install solo essentials.
  Opcional: usuario puede instalar opcionales con :Mason

Pros: Primera instalación más rápida.
Cons: Herramientas opcionales no autoinstaladas.
Riesgo: Medio.
```

#### Option C - Simplificación
```
Reduce LSP servers al mínimo:
  - lua_ls (Lua)
  - ruby_lsp (Ruby)
  - pyright (Python)
  - ts_ls (TypeScript)
  - rust_analyzer (si usas Rust)

Quitar: graphql, marksman, bashls, dockerls, jsonls, yamlls (si no usas)

Pros: Menos paquetes, primera instalación más rápida.
Cons: Pierde soporte para lenguajes ocasionales.
Riesgo: Alto (puede romper soporte para lenguajes).
```

**Acción:** Keep (Option A preferido - lazy-load ya optimizado)

---

### 2. nvim-cmp ✅ STATUS: Bien configurado

**Estado:** ✅ Bien lazy-load (InsertEnter)

**Configuración actual:**
```lua
event = "InsertEnter"
dependencies = {
  cmp-buffer, cmp-path, cmp-nvim-lsp, cmp_luasnip,
  lspkind, LuaSnip, friendly-snippets
}
```

**Sources:**
```lua
{ name = "nvim_lsp" }  -- LSP suggestions
{ name = "luasnip" }   -- snippets
{ name = "buffer" }    -- buffer text
{ name = "path" }      -- file paths
```

**Keymaps:**
```lua
<C-k>           -- previous suggestion
<C-j>           -- next suggestion
<Tab>           -- next item OR expand snippet
<S-Tab>         -- previous item OR jump snippet
<C-Space>       -- show completion
<C-e>           -- close completion
<CR>            -- confirm selection
```

**Problemas detectados:**
1. **friendly-snippets** - ¿pesado?
   - Contiene muchos snippets (Ruby, Python, JS, etc.)
   - Lazy-load con `luasnip.loaders.from_vscode.lazy_load()` ✅
   - ¿Carga demasiado en insert mode?

2. **Snippet sources** - ¿necesario?
   - luasnip (custom snippets) + friendly-snippets (VSCode) = ¿duplicación?
   - friendly-snippets = ~1000+ snippets para lenguajes populares

3. **has_words_before funcion** - ¿complejo?
   - Función inline 4 líneas - aceptable
   - Necesario para Tab autocomplete

**Análisis friendly-snippets:**
```
lazy_load() = carga solo en insert mode ✅
Contenido: snippets para Ruby, Python, JS, TS, etc.
Impacto: carga solo cuando escribe en insert mode
```

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener friendly-snippets.
Pros: Snippets útiles listos cuando escribes.
Cons: Carga extra en insert mode.
Razonamiento: lazy_load() ya optimiza (solo en insert mode).
```

#### Option B - Mejor UX
```
Quitar friendly-snippets, mantener solo snippets custom:
  - luasnip.loaders.from_lua (tu snippets personalizados)
  - friendly-snippets quitado

Pros: Menos overhead en insert mode, tus snippets son suficientes.
Cons: Pierdes snippets pre-hechos para lenguajes.
Riesgo: Bajo.
```

#### Option C - Simplificación
```
¿Necesario? Si NO usas snippets extensivamente, quitar.

Keep snippets básicos solo (2-3).
```

**Acción:** Keep (Option A preferido - lazy-load optimizado)

---

### 3. LuaSnip + Snippets ✅ STATUS: Bien

**Estado:** ✅ Usando friendly-snippets + custom

**Configuración actual:**
```lua
luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

luasnip.filetype_extend("ruby", { "rails" })  -- Ruby extend Rails snippets

# Load snippets
require("luasnip.loaders.from_vscode").lazy_load()  -- friendly-snippets
require("luasnip.loaders.from_lua").lazy_load({
  paths = "~/.config/nvim/lua/angel/snippets/"
})
```

**Problemas detectados:**
1. **¿Usas custom snippets?**
   - Verificar si `lua/angel/snippets/` tiene snippets
   - Si no hay mucho contenido, friendly-snippets suficiente

2. **history = true** - ¿necesario?
   - Guarda historial de snippets usados
   - ¿Usas snippet tracking?

3. **enable_autosnippets = true** - OK
   - Expande snippets automáticamente si coincide con trigger

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener ambas loaders (VSCode + Lua).
Pros: Flexibilidad (snippets pre-hechos + custom).
Cons: Dos loaders (minor overhead).
```

#### Option B - Mejor UX
```
Si custom snippets > 20, quitar friendly-snippets.
Pros: Menos overhead, snippets enfocados.
Cons: Pierdes snippets pre-hechos.
```

**Acción:** Keep (both loaders)

---

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Performance | Opción preferida | Riesgo |
|--------|--------|-------------|-------------|-----------------|--------|
| Mason | ✅ cmd lazy | ensure_installed 25+ | Good (cmd) | A (keep) | Bajo |
| nvim-cmp | ✅ InsertEnter | friendly-snippets? | Good (event) | A (keep) | Bajo |
| LuaSnip | ✅ Bien | friendly-snippets + custom | Good | A (keep) | Bajo |

---

## Cambios Propuestos

**Ningún cambio propuesto** - todos los plugins bien optimizados con lazy-loading.

### Opcional: Mason ensure_installed categorización

Solicitar usuario si quiere:

**A. Mantener todos 26 packages (recomendado)**
**B. Simplificar a essentials (~15 packages)**
   - Mantener: LSP principales (lua_ls, ruby_lsp, pyright, ts_ls)
   - Quitar: opcionales (graphql, marksman, bashls, dockerls, jsonls, yamlls)
   - Quitar: debuggers si no usas DAP regularmente

---

## Verificación para Usuario

**Preguntas para aprobación:**

1. **Mason packages:** ¿Usas todos 26 LSP servers + tools?
   - Si **SÍ usa todos** → mantener todos (recomendado)
   - Si **NO usa graphql/marksman/bashls/dockerls/jsonls/yamlls** → simplificar

2. **DAP usage:** ¿Usas debugpy/node-debug2/codelldb regularmente?
   - Si **NO** → quitar de ensure_installed (ahorrar espacio)

3. **friendly-snippets:** ¿Util o prefieres solo custom snippets?

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Feedback sobre Mason ensure_installed (¿todos necesarios?)
- [ ] Feedback sobre DAP usage

**Riesgos:**
- Mason changes → bajo riesgo (solo primera instalación afectada)
- friendly-snippets → bajo riesgo (lazy-load optimizado)

---

**Estado Slice 3:**
- ✅ Diagnóstico completo
- ⏸️ Cambios opcionales esperando feedback
- ⏸️ Commits pendientes (si cambios aplicados)
- ⏸️ Doc actualizada (pending cambios)

**Notas de interés:**
- Mason lazy-load en `cmd = "Mason"` (no startup impact) ✅
- nvim-cmp load en `event = "InsertEnter"` (no startup impact) ✅
- friendly-snippets lazy_load() = solo carga en insert mode ✅