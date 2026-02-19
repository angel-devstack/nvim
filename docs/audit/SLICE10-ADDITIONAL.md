# Slice 10 - Additional Plugins

**Fecha:** 2026-02-19  
**Status:** 🟡 Diagnóstico completo

---

## Plugins Auditados

| Plugin | Event/Trigger | Startup Impact | Función |
|---------|--------------|----------------|---------|
| **opencode** | `cmd = { "OpenCode" }` or `keys = {}`? | ~0ms | AI asistente |
| **rest.nvim** | `ft = "http"` + `keys = {}` | ~0ms | HTTP client |
| **obsidian.nvim** | `ft = "markdown"` + `keys = {}` | ~0ms | Obsidian vaults |
| **render-markdown** | `event = "BufReadPre"`, `ft = { markdown, vimwiki }` | ~0-50ms per buffer | Markdown rendering |
| **image.nvim** | `cond = WezTerm only` | ~0ms (no carga en otros terminales) | Image preview |
| **luarocks.nvim (magick)** | `lazy = false`, `priority = 1001` | ??? (carga al inicio) | LuaRocks manager |
| **bundler-info** | `ft = { ruby, eruby }` | ~0ms | Ruby bundler info |
| **git-conflict** | dependencies { nvim-pqf } | ~0ms | Merge conflict resolution |
| **ruby-lsp** | `config = true` | ~0ms | Ruby LSP automático |
| **dap-python** | `ft = { "python" }` | ~0ms | DAP Python adapter |
| **dap-rust** | `ft = { "rust" }` | ~0ms | DAP Rust adapter |
| **venv-lsp** | Version "*" | ~0ms | Python venv LSP |
| **vim-rails** | `ft = { ruby, eruby ... }`, `cond = Gemfile` | ~0ms | Rails workflow |
| **vim-bundler** | No trigger specified | ??? (carga siempre?) | Bundler commands |
| **vim-cucumber** | `ft = { cucumber, gherkin }` | ~0ms | Cucumber tests |
| **nvim-ruby-debugger** | `ft = { "ruby" }` | ~0ms | Ruby DAP debugger |
| **dressing** | `event = "VeryLazy"` | ~0ms | UI dialogs |
| **alpha** | `event = "VimEnter"` | ~0ms (solo si no files) | Splash screen |

---

## Diagnóstico por Plugin

### 1. opencode.nvim (opencode.lua)

**Configuración actual:**
```lua
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Config vacía
    }
    vim.o.autoread = true
    -- Keymap
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
  end,
}
```

Estado: ⚠️ **No lazy-load spec (sin `event`, `cmd`, `keys`)**

**Problemas:**
1. Carga siempre (sin trigger especificado)
2. **COLISIÓN con builtin `<C-a>`** (increment number by count)
3. La mayoría de users NO usan builtin `<C-a>` (prefiere `<C-x>` decrement y manual manip)

**Funcionalidad:** AI assistant para ask questions sobre código.

**Recomendación:**
- Si usuario no usa builtin `<C-a>`, mantener
- Si usuario usa builtin `<C-a>`, cambiar keymap (ej: `<C-s>A`)

---

### 2. rest.nvim (rest.lua)

**Configuración actual:**
```lua
return {
  "rest-nvim/rest.nvim",
  ft = "http",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http" })
    end, },
  },
  keys = {
    { "<leader>rr", "<Plug>RestNvim", desc = "Run request", ft = "http" },
    { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview curl", ft = "http" },
    { "<leader>rl", "<Plug>RestNvimLast", desc = "Re-run last", ft = "http" },
  },
  config = function()
    require("rest-nvim").setup({ result_split_horizontal = false, ... })
  end,
}
```

Estado: ✅ **Bien lazy-load** (`ft = "http"` + `keys = {}`)

**Funcionalidad:** HTTP client para testing APIs.

---

### 3. obsidian.nvim (obsidian.lua)

**Configuración actual:**
```lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,  -- ⚠️ REDUNDANTE con ft = "markdown"?
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    ui = { enable = true },
    workspaces = {
      { name = "work", path = "~/Vaults/Harvis" },
    },
    wiki_link_func = "use_alias_only",
    follow_url_func = function(url) ... end,
  },
}
```

Estado: ⚠️ **`lazy = true` es REDUNDANTE con `ft = "markdown"`**

**Funcionalidad:** Obsidian vault integration (notes, zettelkasten).

---

### 4. render-markdown (markdown.lua)

**Configuración actual:**
```lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "BufReadPre",
  ft = { "markdown", "vimwiki" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.nvim",
  },
  opts = {
    file_types = { "markdown", "vimwiki" },
    render_modes = true,
    mermaid = { enabled = true, render_options = { theme = "default" } },
  },
}
```

Estado: ⚠️ **`event = "BufReadPre"` + `ft = {}` puede causar carga por buffer**

**Funcionalidad:** Renderiza markdown con syntax highlighting y Mermaid diagrams.

**Impacto:** ~0-50ms per buffer (lightweight pero cargas por cada markdown file).

---

### 5. image.nvim (image.lua)

**Configuración actual:**
```lua
return {
  "3rd/image.nvim",
  cond = function()
    return vim.env.TERM_PROGRAM == "WezTerm"
  end,
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        filetypes = { "markdown", "vimwiki" },
      },
    },
  },
}
```

Estado: ✅ **Bien lazy-load** (`cond = function() return vim.env.TERM_PROGRAM == "WezTerm" end`)

**Funcionalidad:** Image preview en terminal. Solo si usa WezTerm.

---

### 6. luarocks.nvim (magick-rock.lua) ⚠️

**Configuración actual:**
```lua
return {
  "vhyrro/luarocks.nvim",
  priority = 1001,  -- 🧱 Se carga primero
  lazy = false,  -- ⚠️ IMPORTANTE: carga al inicio (NO lazy-load)
  opts = {
    rocks = {
      "magick",  -- Paquete necesario para image.nvim
    },
  },
}
```

Estado: ⚠️ **`lazy = false` CAUSA STARTUP IMPACT** (carga al inicio sin necesidad)

**Problema:**
- `lazy = false` significa que el plugin siempre carga en startup
- `priority = 1001` significa que carga antes de casi todos otros plugins
- Es MUY pesado (LuaRocks es un manager de packages de Lua, necesita inicializar LuaRock environment)

**Razón:** Necesario para image.nvim (ImageMagick integration). Pero image.nvim solo es útil en WezTerm.

**Recomendación:**
- Si usuario NO usa WezTerm, puede eliminar both image.nvim + luarocks.nvim (~100-500ms ganancia)
- Si usuario usa WezTerm, mantener pero evaluar si lazy = false es realmente necesario

---

### 7. bundler-info.nvim (bundler-info.lua)

**Configuración actual:**
```lua
return {
  "jeffrydegrande/bundler-info.nvim",
  ft = { "ruby", "eruby" },
  config = function()
    local ok, bundler = pcall(require, "bundler-info")
    if not ok then
      return
    end
    bundler.setup()
  end,
}
```

Estado: ✅ **Bien lazy-load** (`ft = { "ruby", "eruby" }`)

**Funcionalidad:** Muestra bundler info en Ruby projects.

---

### 8. git-conflict.nvim (git-conflict.lua)

**Configuración actual:**
```lua
return {
  "akinsho/git-conflict.nvim",
  dependencies = { "yorickpeterse/nvim-pqf" },
  version = "*",
  config = function()
    require("pqf").setup()
    require("git-conflict").setup({
      default_mappings = true,
      disable_diagnostics = true,
      list_opener = "copen",
    })
  end,
}
```

Estado: ⚠️ **No lazy-load spec (sin `event`, `cmd`, `keys`)**

**Problema:** Carga siempre.

**Funcionalidad:** Resolución de merge conflicts.

---

### 9. ruby-lsp.nvim (ruby-lsp.lua)

**Configuración actual:**
```lua
return {
  "adam12/ruby-lsp.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = true,  -- Auto-configs lspconfig with ruby-lsp
}
```

Estado: ⚠️ **No lazy-load spec (sin `event`, `cmd`, `keys`)**

**Problema:** Carga siempre. Pero `config = true` indica que es auto-setup, no hay mucho que hacer.

**Funcionalidad:** Auto-install/configs Ruby LSP.

---

### 10. dap-python (python.lua)

**Configuración actual:**
```lua
return {
  "mfussenegger/nvim-dap-python",
  ft = { "python" },
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local ok, dap_python = pcall(require, "dap-python")
    if not ok then
      return
    end
    dap_python.setup("python", { console = "integratedTerminal" })
  end,
}
```

Estado: ✅ **Bien lazy-load** (`ft = { "python" }`)

**Funcionalidad:** DAP adapter for Python debugging.

---

### 11. dap-rust (rust.lua)

**Configuración actual:**
```lua
return {
  "mfussenegger/nvim-dap",
  ft = { "rust" },
  config = function()
    local dap = require("dap")
    dap.adapters.codelldb = { ... }
    dap.configurations.rust = { ... }
  end,
}
```

Estado: ✅ **Bien lazy-load** (`ft = { "rust" }`)

**Funcionalidad:** DAP adapter for Rust debugging.

---

### 12. venv-lsp.nvim (venv-lsp.lua)

**Configuración actual:**
```lua
return {
  "jglasovic/venv-lsp.nvim",
  version = "*",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- No manual setup - Plugin automatically handles venv detection when loaded
  end,
}
```

Estado: ⚠️ **No lazy-load spec (sin `event`, `cmd`, `keys`)**

**Problema:** Carga siempre.

**Funcionalidad:** Python venv detection for LSP.

---

### 13. vim-rails (vim-rails.lua)

**Configuración actual:**
```lua
return {
  "tpope/vim-rails",
  ft = { "ruby", "eruby", "haml", "slim" },
  cond = function()
    return vim.fn.filereadable("Gemfile") == 1
  end,
  cmd = { "Rails", "Rmodel", "Rview", "Rcontroller", "Rake", "Generate" },
}
```

Estado: ✅ **Bien lazy-load** (`ft = {}` + `cond = Gemfile` + `cmd = {}`)

**Funcionalidad:** Rails workflow (generate files, Rake commands, etc.).

---

### 14. vim-bundler (vim-bundler.lua)

**Configuración actual:**
```lua
return {
  "tpope/vim-bundler",
}
```

Estado: ⚠️ **No lazy-load spec**

**Problema:** Carga siempre.

**Funcionalidad:** Bundler commands.

---

### 15. vim-cucumber (vim-cucumber.lua)

**Configuración actual:**
```lua
return {
  "tpope/vim-cucumber",
  ft = { "cucumber", "gherkin" },
}
```

Estado: ✅ **Bien lazy-load** (`ft = { "cucumber", "gherkin" }`)

**Funcionalidad:** Cucumber test syntax.

---

### 16. nvim-ruby-debugger (nvim-ruby-debugger.lua)

**Configuración actual:**
```lua
return {
  "kaka-ruto/nvim-ruby-debugger",
  ft = { "ruby" },
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local ok, nvim_ruby_debugger = pcall(require, "nvim-ruby-debugger")
    if not ok then
      vim.notify("nvim-ruby-debugger not loaded", vim.log.levels.ERROR)
      return
    end
    nvim_ruby-debugger.setup({
      rails_port = 38698,
      worker_port = 38699,
      minitest_port = 38700,
      host = "127.0.0.1",
    })
  end,
}
```

Estado: ✅ **Bien lazy-load** (`ft = { "ruby" }`)

**Funcionalidad:** Ruby DAP adapter (rails/minitest debugging).

---

### 17. dressing.nvim (dressing.lua)

**Configuración actual:**
```lua
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = { win_options = { winblend = 0 } },
    select = { backend = { "telescope", "builtin" } },
  },
}
```

Estado: ✅ **Bien lazy-load** (`event = "VeryLazy"`)

**Funcionalidad:** UI dialogs (input, select).

---

### 18. alpha-nvim (alpha.lua)

**Configuración actual:**
```lua
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Dashboard setup with logo Nvim
    alpha.setup(dashboard.config)
  end,
}
```

Estado: ✅ **Bien lazy-load** (`event = "VimEnter"`)

**Funcionalidad:** Splash screen/dashboard (solo mostra si no files abiertos).

---

### 19. lualine.nvim (lualine.lua)

**Configuración actual:**
```lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    -- Statusline setup
    lualine.setup({
      options = { theme = "onedark", ... } ...
    })
  end,
}
```

Estado: ✅ **Bien lazy-load** (`event = "VeryLazy"`)

**Funcionalidad:** Statusline.

---

## Resumen de Estados

| Plugin | Estado | Configuración | Necesita cambio? |
|--------|--------|---------------|------------------|
| opencode | ⚠️ Mal | No trigger | SÍ - keys o cmd |
| rest | ✅ Bien | `ft = "http"` + `keys = {}` | No |
| obsidian | ⚠️ Mal | `lazy = true` REDUNDANTE | SÍ - remover `lazy = true` |
| render-markdown | ⚠️ Mal | `event = BufReadPre` | SÍ - cambiar a `VeryLazy` |
| image | ✅ Bien | `cond = WezTerm` | No |
| luarocks.nvim | ⚠️ Mal | `lazy = false` | SÍ - evaluar si necesita |
| bundler-info | ✅ Bien | `ft = { "ruby", "eruby" }` | No |
| git-conflict | ⚠️ Mal | No trigger | SÍ - `event = "BufReadPost"` o similar |
| ruby-lsp | ⚠️ Mal | No trigger | SÍ - `ft = { "ruby" }` |
| dap-python | ✅ Bien | `ft = { "python" }` | No |
| dap-rust | ✅ Bien | `ft = { "rust" }` | No |
| venv-lsp | ⚠️ Mal | No trigger | SÍ - `ft = { "python" }` |
| vim-rails | ✅ Bien | `ft = {}` + `cond = Gemfile` + `cmd = {}` | No |
| vim-bundler | ⚠️ Mal | No trigger | SÍ - `ft = { "ruby" }` |
| vim-cucumber | ✅ Bien | `ft = { "cucumber" }` | No |
| nvim-ruby-debugger | ✅ Bien | `ft = { "ruby" }` | No |
| dressing | ✅ Bien | `event = "VeryLazy"` | No |
| alpha | ✅ Bien | `event = "VimEnter"` | No |
| lualine | ✅ Bien | `event = "VeryLazy"` | No |

---

## Preguntas para el Usuario

### 1. opencode.nvim (colisión con `<C-a>` builtin)

**Contexto:** opencode.nvim usa `<C-a>` keymap que colisiona conbuiltin increment (increment number by count).

**Pregunta:** ¿Usas builtin `<C-a>` key de Neovim (increment number)?

- [ ] **No, no uso builtin `<C-a>`** → Mantener opencode.nvim
- [ ] **Sí, uso builtin `<C-a>`** → Cambiar keymap (<C-s>A o similar)

---

### 2. render-markdown + image.nvim + luarocks.nvim (¿usas WezTerm y Markdown?)

**Contexto:** Triángulo de plugins:
- luarocks.nvim con `lazy = false` (~100-500ms startup impact)
- image.nvim (solo WezTerm, requiere luarocks.nvim)
- render-markdown (markdown rendering, posible ~0-50ms per buffer)

**Pregunta A:** ¿Usas WezTerminal regularly?

- [ ] **Sí, uso WezTerm** → Mantener image.nvim + luarocks.nvim
- [ ] **No, no uso WezTerm** → Eliminar image.nvim + luarocks.nvim (~100-500ms ganancia)

**Pregunta B:** ¿Usas Markdown con Mermaid diagrams regularly?

- [ ] **Frecuentemente** → Mantener render-markdown con `event = "BufReadPre"`
- [ ] **Raramente** → Cambiar a `event = "VeryLazy"` (~0-50ms per buffer gain)

---

### 3. git-conflict, ruby-lsp, venv-lsp, vim-bundler (plugins sin lazy-load spec)

**Contexto:** 4 plugins cargados siempre sin lazy-load spec.

**Pregunta:** ¿Quieres arreglar lazy-load para estos 4 plugins?

- [ ] **Sí, optimizar** → Agregar `ft = {}` o `event = {}` specs
- [ ] **No, mantener** → Son ligeros, impacto minúsculo

---

## Estado Final de Slice 10

⏸️ **Esperando respuestas del usuario** a preguntas antes de implementar cambios.

---

**Documentación pendiente:**
- `docs/audit/SLICE10-REPORT-FINAL.md` (una vez implementadas respuestas)

**Siguiente paso:** El usuario debe responder 3 preguntas (A/B) y luego implementaré cambios con commits atómicos.