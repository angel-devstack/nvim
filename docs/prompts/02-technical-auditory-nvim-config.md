---
id: technical-auditory-nvim-config
aliases: []
tags: []
---


Auditoría Técnica — Neovim Config angel

  ---
  Resumen Ejecutivo

  Tu setup es maduro, bien organizado por categorías, y cubre un stack full-stack serio (Ruby/Rails, Python, JS/TS, Rust, Lua). La arquitectura modular con lazy.nvim es sólida en
  diseño, pero tiene varios problemas técnicos concretos que van desde un bug bloqueante en bootstrap, hasta plugins deprecados, imports duplicados, y configuraciones que no hacen lo
   que pensás que hacen.

  Diagnóstico general: El setup funciona porque ya fue bootstrapped, pero tiene deuda técnica acumulada que necesita limpieza. La orientación hacia AI tooling (gen.nvim, avante,
  opencode) es excesiva para lo que aporta. La documentación está sobredimensionada respecto al código.

  ---
  Problemas Críticos Detectados

  1. BUG BLOQUEANTE: Variable indefinida en bootstrap (lazy.lua:9)

  local repository = "https://github.com/folke/lazy.nvim.git"
  fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
  --                                                  ^^^^ UNDEFINED — debería ser `repository`

  La variable se llama repository pero se usa repo. En una instalación nueva (fresh), lazy.nvim no se instala. Funciona hoy solo porque ya existe en tu sistema.

  2. Imports duplicados en lazy.lua

  spec = {
      { import = "angel.plugins" },      -- carga plugins/init.lua
      { import = "angel.plugins.git" },  -- YA importado por plugins/init.lua
      { import = "angel.plugins.lsp" },  -- YA importado por plugins/init.lua
      { import = "angel.plugins.dap" },  -- YA importado por plugins/init.lua
  },

  plugins/init.lua ya importa lsp, dap y git. Estás cargando esos módulos dos veces. Lazy.nvim probablemente deduplica, pero es confusión innecesaria y fuente de bugs sutiles.

  3. shfmt en lista incorrecta (mason.lua:55)

  shfmt es un formatter, no un LSP server. Está en mason_lspconfig.ensure_installed (para servidores LSP) en vez de mason_tool_installer.ensure_installed (para tools).
  Mason-lspconfig va a intentar tratarlo como servidor y puede fallar silenciosamente.

  4. tsserver está deprecado — debería ser ts_ls

  En nvim-lspconfig y mason-lspconfig modernos (2025+), tsserver fue renombrado a ts_ls. El comentario -- ← este es el nombre correcto es incorrecto. Tanto en mason.lua como en
  lspconfig.lua debería usarse ts_ls.

  5. obsidian.lua: config anidado dentro de opts

  opts = {
      -- ... opciones ...
      config = function(_, opts)  -- ← ESTO ESTÁ MAL
        require("obsidian").setup(opts)
      end,
  },

  config está dentro de opts, no como key de primer nivel del spec de lazy.nvim. Lazy.nvim no ejecuta eso como hook de configuración — lo pasa como opción regular a setup(). El
  autocmd de conceallevel nunca se ejecuta.

  6. neodev.nvim está deprecado

  folke/neodev.nvim fue reemplazado por folke/lazydev.nvim en 2024. Ya no se mantiene.

  ---
  Análisis Arquitectónico

  Estructura general: Buena, con fricciones
  ┌───────────────────────────┬──────────────────────────────────────────────┐
  │          Aspecto          │                  Evaluación                  │
  ├───────────────────────────┼──────────────────────────────────────────────┤
  │ Separación por categorías │ Excelente — cada dominio tiene su directorio │
  ├───────────────────────────┼──────────────────────────────────────────────┤
  │ Cohesión interna          │ Buena — plugins agrupados lógicamente        │
  ├───────────────────────────┼──────────────────────────────────────────────┤
  │ Acoplamiento              │ Bajo entre módulos, correcto                 │
  ├───────────────────────────┼──────────────────────────────────────────────┤
  │ Escalabilidad             │ Sí, agregar plugins es trivial               │
  ├───────────────────────────┼──────────────────────────────────────────────┤
  │ Duplicación conceptual    │ Sí — imports duplicados en lazy.lua          │
  └───────────────────────────┴──────────────────────────────────────────────┘
  Problemas estructurales

  1. Flujo de carga tiene redundancia:
  init.lua → core (ok) → lazy.lua → spec imports plugins/ + plugins/git + plugins/lsp + plugins/dap (duplicados)
  Solución: lazy.lua solo debería importar { import = "angel.plugins" }.

  2. core/init.lua hijackea vim.notify globalmente:
  vim.notify = function(msg, level, opts)
      if type(msg) == "string" and msg:match("which%-key") and level == vim.log.levels.WARN then
        return
      end
      return orig_notify(msg, level, opts)
  end
  Esto envuelve todas las notificaciones del sistema. Si which-key emite warnings, es porque hay keymaps mal definidos — deberían arreglarse, no silenciarse.

  3. options.lua silencia deprecation warnings:
  vim.deprecate = function() end
  Esto oculta errores reales. Si un plugin usa APIs deprecadas, nunca te enterás.

  4. g:netrw_liststyle configurado pero netrw está deshabilitado (options.lua:52 + lazy.lua:48). Código muerto.

  ---
  Auditoría Plugin por Plugin

  CORE / LSP
  ┌──────────────────┬──────────┬──────────────────────────────────────────────────┬────────────────────────────────┐
  │      Plugin      │  Estado  │                     Problema                     │             Acción             │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ mason.nvim       │ Ok       │ shfmt mal ubicado                                │ Mover a tool_installer         │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ mason-lspconfig  │ Atención │ tsserver deprecado                               │ Cambiar a ts_ls                │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ nvim-lspconfig   │ Atención │ Keymaps sin desc, neodev deprecado               │ Agregar desc, migrar a lazydev │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ schemastore.nvim │ Ok       │ Correcto                                         │ —                              │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ conform.nvim     │ Ok       │ Timeout inconsistente (500 default vs 2000 save) │ Unificar                       │
  ├──────────────────┼──────────┼──────────────────────────────────────────────────┼────────────────────────────────┤
  │ nvim-lint        │ Ok       │ Funcional                                        │ Considerar ruff para Python    │
  └──────────────────┴──────────┴──────────────────────────────────────────────────┴────────────────────────────────┘
  LSP keymaps sin desc — En lspconfig.lua, el on_attach define keymaps con opts = { buffer = bufnr, silent = true } pero sin desc. Which-key no puede mostrar descripciones útiles
  para gd, gD, gi, gr, K, <leader>ca, etc.

  COMPLETION
  ┌──────────┬────────┬──────────────────────┐
  │  Plugin  │ Estado │       Problema       │
  ├──────────┼────────┼──────────────────────┤
  │ nvim-cmp │ Ok     │ Configuración sólida │
  ├──────────┼────────┼──────────────────────┤
  │ LuaSnip  │ Ok     │ —                    │
  ├──────────┼────────┼──────────────────────┤
  │ lspkind  │ Ok     │ —                    │
  └──────────┴────────┴──────────────────────┘
  nvim-cmp está bien configurado. El has_words_before helper es correcto. La integración con autopairs vía cmp.event:on funciona.

  TESTING
  ┌────────────────────┬──────────┬────────────────────────────────────────────────┐
  │       Plugin       │  Estado  │                    Problema                    │
  ├────────────────────┼──────────┼────────────────────────────────────────────────┤
  │ neotest            │ Atención │ Carga en cada apertura de buffer (BufReadPost) │
  ├────────────────────┼──────────┼────────────────────────────────────────────────┤
  │ FixCursorHold.nvim │ Eliminar │ Ya no necesario en Neovim 0.10+                │
  └────────────────────┴──────────┴────────────────────────────────────────────────┘
  Neotest carga muy pronto. event = { "BufReadPost", "BufNewFile" } hace que neotest + 4 adaptadores se carguen al abrir cualquier archivo. Un framework de testing debería cargar
  bajo demanda con keys o cmd:
  keys = {
      { "<leader>tt", ... },
      { "<leader>tr", ... },
      -- etc
  },
  cmd = { "Neotest" },

  UI
  ┌──────────────────┬──────────┬───────────────────────────────────────────┐
  │      Plugin      │  Estado  │                 Problema                  │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ telescope        │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ nvim-tree        │ Ok       │ Width 40 es personal pero ok              │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ lualine          │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ which-key        │ Ok       │ Warnings silenciados en vez de arreglados │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ alpha            │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ dressing         │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ indent-blankline │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ trouble          │ Ok       │ —                                         │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ NeoSolarized     │ Ok       │ lazy = false, priority = 1000 correcto    │
  ├──────────────────┼──────────┼───────────────────────────────────────────┤
  │ nvim-scrollbar   │ Atención │ Sin lazy loading trigger, sin opts        │
  └──────────────────┴──────────┴───────────────────────────────────────────┘
  nvim-scrollbar — no tiene event, cmd, ni keys. Con lazy = true por default, podría no cargar nunca o cargar de forma impredecible.

  EDITING
  ┌─────────────────┬────────┬─────────────────────────────────────┐
  │     Plugin      │ Estado │              Problema               │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ autopairs       │ Ok     │ Buen uso de pcall                   │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ nvim-surround   │ Bug    │ buffer_setup en contexto equivocado │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ Comment.nvim    │ Ok     │ —                                   │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ substitute.nvim │ Ok     │ Bien lazy-loaded con keys           │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ splitjoin.vim   │ Ok     │ Bien lazy-loaded con keys           │
  ├─────────────────┼────────┼─────────────────────────────────────┤
  │ vim-endwise     │ Ok     │ —                                   │
  └─────────────────┴────────┴─────────────────────────────────────┘
  nvim-surround bug: buffer_setup() se llama en el config global, no en un autocmd per-buffer. Eso aplica el surround custom $ solo al buffer activo cuando el plugin carga. Para que
  funcione en todos los buffers JS/TS, necesitás un autocmd FileType.

  TOOLS
  ┌─────────────────┬──────────┬────────────────────────────────────────────┐
  │     Plugin      │  Estado  │                  Problema                  │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ gen.nvim        │ Ok       │ Mejorado recientemente                     │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ avante.nvim     │ Atención │ lazy = false contradice event = "VeryLazy" │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ obsidian.nvim   │ Bug      │ config anidado en opts (detallado arriba)  │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ render-markdown │ Ok       │ Mermaid habilitado                         │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ rest.nvim       │ Ok       │ —                                          │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ todo-comments   │ Ok       │ —                                          │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ image.nvim      │ Ok       │ —                                          │
  ├─────────────────┼──────────┼────────────────────────────────────────────┤
  │ opencode        │ —        │ No leído, verificar                        │
  └─────────────────┴──────────┴────────────────────────────────────────────┘
  avante.nvim: lazy = false hace que cargue en startup, ignorando el event = "VeryLazy". Si querés lazy loading, sacá lazy = false. Si necesitás carga inmediata, sacá event.

  GIT
  ┌──────────────┬────────┐
  │    Plugin    │ Estado │
  ├──────────────┼────────┤
  │ gitsigns     │ Ok     │
  ├──────────────┼────────┤
  │ lazygit      │ Ok     │
  ├──────────────┼────────┤
  │ neogit       │ Ok     │
  ├──────────────┼────────┤
  │ git-conflict │ Ok     │
  └──────────────┴────────┘
  Sin problemas detectados.

  RUBY
  ┌────────────────────┬─────────────────────────────┐
  │       Plugin       │           Estado            │
  ├────────────────────┼─────────────────────────────┤
  │ vim-rails          │ Ok — cond con Gemfile check │
  ├────────────────────┼─────────────────────────────┤
  │ vim-bundler        │ Ok                          │
  ├────────────────────┼─────────────────────────────┤
  │ vim-cucumber       │ Ok                          │
  ├────────────────────┼─────────────────────────────┤
  │ nvim-ruby-debugger │ Ok                          │
  └────────────────────┴─────────────────────────────┘
  Bien configurado con carga condicional.

  DAP

  Sin problemas mayores. Los 3 adaptadores (Node, Python, Rust) están correctos.

  MISC
  ┌─────────────────────┬──────────┬─────────────────────────────────────────┐
  │       Plugin        │  Estado  │                Problema                 │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ auto-session        │ Ok       │ —                                       │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ session-lens        │ Atención │ Sin trigger de lazy loading             │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ vim-maximizer       │ Ok       │ keys trigger                            │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ sort.nvim           │ Ok       │ keys + cmd trigger                      │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ tabular             │ Ok       │ cmd + keys trigger                      │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ vim-highlightedyank │ Eliminar │ Neovim 0.5+ tiene esto built-in         │
  ├─────────────────────┼──────────┼─────────────────────────────────────────┤
  │ vim-mkdir           │ Atención │ Sin trigger — probablemente nunca carga │
  └─────────────────────┴──────────┴─────────────────────────────────────────┘
  vim-highlightedyank — Neovim tiene vim.highlight.on_yank() built-in desde la versión 0.5. Este plugin Vimscript es innecesario. Reemplazalo con un autocmd de 2 líneas:
  vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
  })

  vim-mkdir — sin ningún trigger de lazy loading, con lazy = true por default, este plugin nunca se carga. Si lo necesitás, agregale event = "BufWritePre". Si no lo usás, eliminalo.

  ---
  LSP, Linters y Formateo (CRITICO)

  Python: posible conflicto

  Tu stack Python actual:
  - LSP: pyright (tipos + diagnósticos)
  - Formatter: isort + black (via conform)
  - Linter: pylint (via nvim-lint)

  Problemas detectados:

  1. pylint es pesado y lento. En 2026, ruff reemplaza pylint, flake8, isort Y black en una sola herramienta. Es 10-100x más rápido. Tu setup actual ejecuta isort → black → pylint
  secuencialmente, lo cual es lento.
  2. No hay conflicto LSP/formatter — pyright no tiene formatting y conform tiene lsp_format = "fallback". Correcto.
  3. No hay doble formateo — conform y nvim-lint están bien separados (format on save vs lint on save).

  Propuesta ideal para Python:
  -- conform: ruff format (reemplaza isort + black)
  python = { "ruff_format" },
  -- nvim-lint: ruff (reemplaza pylint)
  python = { "ruff" },
  -- Mason: agregar "ruff" a ensure_installed

  TypeScript: nombre de servidor incorrecto

  tsserver → ts_ls en todos lados (mason.lua + lspconfig.lua).

  Shell: correcto

  shfmt via conform. Solo mover de la lista de LSP servers a tool_installer.

  Markdown: correcto

  marksman LSP + prettier formatter. Funcional.

  Arquitectura ideal de formateo (todas las lang):

  LSP (diagnostics only) → conform (formatting) → nvim-lint (linting post-save)
  Tu setup ya sigue este patrón, que es correcto. Solo necesita las correcciones puntuales mencionadas.

  ---
  Performance y Lazy Loading

  Plugins que cargan demasiado pronto
  ┌─────────────────────────┬────────────────────────────────────┬──────────────────────────────────────────────────┐
  │         Plugin          │           Trigger actual           │                  Recomendación                   │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ neotest + 4 adaptadores │ BufReadPost                        │ keys o cmd = "Neotest"                           │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ avante.nvim + deps      │ lazy = false (startup)             │ event = "VeryLazy" o keys                        │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ nvim-scrollbar          │ ninguno (posiblemente nunca carga) │ event = "BufReadPost"                            │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ session-lens            │ ninguno                            │ cmd o keys                                       │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ vim-mkdir               │ ninguno                            │ event = "BufWritePre" o eliminar                 │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ vim-endwise             │ BufReadPre                         │ event = "InsertEnter" sería más eficiente        │
  ├─────────────────────────┼────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ substitute.nvim         │ BufReadPre + keys                  │ Solo keys (ya los tiene, el event es redundante) │
  └─────────────────────────┴────────────────────────────────────┴──────────────────────────────────────────────────┘
  Plugins con lazy loading correcto

  - telescope (cmd/keys)
  - nvim-tree (cmd/keys)
  - splitjoin (keys only)
  - tabular (cmd/keys)
  - sort (cmd/keys)
  - vim-maximizer (keys)
  - gen.nvim (event + cmd + keys)
  - gitsigns (event)
  - conform (event — ok porque formatting es frecuente)

  Startup impact estimado

  Los plugins con mayor impacto en startup:
  1. NeoSolarized — necesario, lazy = false correcto
  2. avante.nvim — innecesario en startup, lazy = false debería eliminarse
  3. neotest + adaptadores — carga pesada innecesaria en cada archivo

  ---
  Limpieza y Simplificación

  Código muerto

  1. keymaps.lua:34-50 — ~16 líneas de Copilot keymaps comentados
  2. options.lua:52 — g:netrw_liststyle con netrw deshabilitado
  3. options.lua:4 — vim.deprecate = function() end (hack peligroso)
  4. core/init.lua:5-11 — Override de vim.notify (debería arreglar which-key, no silenciarlo)

  Config redundante

  1. conform.lua — default_format_opts.timeout_ms = 500 y format_on_save.timeout_ms = 2000. El default_format_opts timeout nunca se usa si format_on_save lo overridea.
  2. substitute.nvim — tiene tanto event como keys. Los keys son suficientes; el event es redundante.

  Plugins que podrían eliminarse
  ┌─────────────────────┬──────────────────────────────────────────────────────┬─────────────────────────┐
  │       Plugin        │                        Razón                         │        Reemplazo        │
  ├─────────────────────┼──────────────────────────────────────────────────────┼─────────────────────────┤
  │ vim-highlightedyank │ Built-in en Neovim 0.5+                              │ vim.highlight.on_yank() │
  ├─────────────────────┼──────────────────────────────────────────────────────┼─────────────────────────┤
  │ neodev.nvim         │ Deprecado                                            │ folke/lazydev.nvim      │
  ├─────────────────────┼──────────────────────────────────────────────────────┼─────────────────────────┤
  │ FixCursorHold.nvim  │ Bug corregido en Neovim 0.10+                        │ Nada                    │
  ├─────────────────────┼──────────────────────────────────────────────────────┼─────────────────────────┤
  │ vim-mkdir           │ Probablemente nunca carga                            │ Evaluar si lo usás      │
  ├─────────────────────┼──────────────────────────────────────────────────────┼─────────────────────────┤
  │ dressing.nvim       │ Neovim 0.10+ mejoró vim.ui.select significativamente │ Evaluar                 │
  └─────────────────────┴──────────────────────────────────────────────────────┴─────────────────────────┘
  Si tuviera que reducir 20% sin perder potencia

  Eliminaría:
  1. vim-highlightedyank → autocmd built-in
  2. FixCursorHold.nvim → innecesario
  3. neodev.nvim → migrar a lazydev
  4. vim-mkdir → probablemente muerto
  5. session-lens → si no lo usás, auto-session ya tiene integración con Telescope
  6. pylint + isort + black → reemplazar los 3 por ruff
  7. Uno de gen.nvim/avante.nvim — tener 2 AI assistants locales es redundante

  ---
  Documentación

  Evaluación
  ┌─────────────────────────┬─────────────────────┬──────────────────────────────────────────────────────────────┐
  │        Documento        │ Alineado con código │                           Problema                           │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ KEYMAP_REGISTRY.md      │ Parcialmente        │ LSP keymaps sin desc no aparecen registrados con descripción │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ WARP.md                 │ Sí                  │ Actualizado recientemente                                    │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ AI_KEYBINDINGS.md       │ Sí                  │ Nuevo, correcto                                              │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ CLAUDE.md               │ Sí                  │ Recién creado                                                │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ CONTRIBUTING.md         │ Sí                  │ Completo                                                     │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ TROUBLESHOOTING.md      │ Parcialmente        │ Algunos tips pueden estar desactualizados                    │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ PHASE_TRACKING.md       │ Obsoleto            │ Las 6 fases completadas, este doc ya no aporta valor activo  │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ PHASE5_API_AUDIT.md     │ Histórico           │ Útil como referencia pero no activo                          │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ DAP_TESTING_GUIDE.md    │ Ok                  │ —                                                            │
  ├─────────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────────┤
  │ PHASE4_TESTING_GUIDE.md │ Obsoleto            │ Phase 4 ya se completó y testeó                              │
  └─────────────────────────┴─────────────────────┴──────────────────────────────────────────────────────────────┘
  Sobredocumentado

  La carpeta docs/ tiene 10+ documentos para un setup de ~1500 líneas de Lua. Los docs de fases (PHASE_TRACKING, PHASE4_TESTING, PHASE5_API_AUDIT) ya cumplieron su propósito. Podrían
   archivarse o eliminarse.

  Faltante

  - No hay documentación sobre cómo testear cambios al config (más allá de :checkhealth)
  - No hay stylua en CI o pre-commit hook

  ---
  Diseño Técnico y Filosofía

  Filosofía: Config pragmática full-stack con bias hacia Ruby/Rails y tooling AI.

  Diagnóstico honesto:

  1. Es coherente — el patrón lazy.nvim + categorías se sigue consistentemente
  2. Está orientado a AI de más — 3 integraciones AI (gen.nvim, avante, opencode) + 4 directorios de prompts (_bmad, .claude, .codex, .cursor, .opencode) para un config de Neovim es
  excesivo. Elegí uno y eliminá el resto
  3. Tiene sobreingeniería en documentación — más líneas de docs que de código Lua
  4. Tiene under-engineering en validación — silenciar warnings (vim.deprecate, vim.notify) en vez de arreglarlos
  5. No es minimalista — ~40 plugins es razonable para el scope, pero hay margen para recortar

  ---
  Roadmap Priorizado

  1. PRIORIDAD ALTA (arreglar ya)

  - [done] Fix lazy.lua:9 — repo → repository (bug bloqueante en fresh install)
  - [done] Eliminar imports duplicados en lazy.lua — dejar solo { import = "angel.plugins" }
  - Mover shfmt de mason_lspconfig a mason_tool_installer
  - Fix obsidian.lua — sacar config de dentro de opts
  - Renombrar tsserver → ts_ls en mason.lua y lspconfig.lua
  - Agregar desc a todos los keymaps de on_attach en lspconfig.lua

  2. PRIORIDAD MEDIA

  - Migrar neodev.nvim → lazydev.nvim
  - Eliminar FixCursorHold.nvim de neotest deps
  - Reemplazar vim-highlightedyank con autocmd built-in
  - Cambiar neotest de event a keys/cmd (mejora startup)
  - Sacar lazy = false de avante.nvim
  - Eliminar vim.deprecate = function() end y arreglar warnings reales
  - Eliminar override de vim.notify y arreglar which-key warnings
  - Fix nvim-surround buffer_setup — usar autocmd FileType
  - Migrar Python de pylint+isort+black a ruff

  3. MEJORA OPCIONAL

  - Agregar lazy loading a nvim-scrollbar (event = "BufReadPost")
  - Agregar lazy loading a session-lens o eliminarlo
  - Evaluar si vim-mkdir se usa, eliminarlo si no
  - Evaluar si necesitás gen.nvim + avante + opencode (elegir 1-2)
  - Agregar event = "InsertEnter" a vim-endwise (más eficiente)
  - Eliminar event redundante de substitute.nvim (ya tiene keys)

  4. LIMPIEZA ESTÉTICA

  - Eliminar comentarios de Copilot en keymaps.lua
  - Eliminar g:netrw_liststyle de options.lua
  - Archivar o eliminar docs de fases completadas (PHASE_TRACKING, PHASE4_TESTING, PHASE5_API_AUDIT)
  - Unificar default_format_opts y format_on_save en conform.lua

  ---
