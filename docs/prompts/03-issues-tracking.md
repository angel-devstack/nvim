---
id: issues-tracking
aliases: []
tags: [audit, issues, backlog]
---

# Issues Tracking — Technical Audit

Documento completo de issues encontrados en la auditoría técnica del config de Neovim, ordenados por prioridad.

---

## 🚨 PRIMERA PRIORIDAD (CRITICAL)

- [x] **Issue #1: BUG BLOQUEANTE — Variable indefinida en bootstrap (lazy.lua:9)**
  - Archivo: `lua/angel/lazy.lua`
  - Estado: **DONE**
  - Problema: `repository` variable defined but used as `repo` (undefined variable)
  - Solución: Cambiar `repo` → `repository` en fn.system()
  - **Commit:** fix(lazy): fix undefined `repo` variable in bootstrap

- [x] **Issue #2: Imports duplicados en lazy.lua**
  - Archivo: `lua/angel/lazy.lua`
  - Estado: **DONE**
  - Problema: lazy.lua importa `angel.plugins` + también `angel.plugins.lsp/dap/git` individualmente
  - Solución: Dejar solo `{ import = "angel.plugins" }` que ya incluye todo
  - **Commit:** fix(lazy): remove duplicate imports

- [x] **Issue #3: shfmt en lista incorrecta (LSP vs tool)**
  - Archivo: `lua/angel/plugins/lsp/mason.lua`
  - Estado: **DONE**
  - Problema: shfmt es un formatter, no un LSP server. Está en `mason_lspconfig.ensure_installed`
  - Solución: Mover a `mason_tool_installer.ensure_installed` (sección de formatters)
  - **Commit:** fix(lsp): move shfmt to tool_installer

- [x] **Issue #4: obsidian.lua — config anidado dentro de opts**
  - Archivo: `lua/angel/plugins/tools/obsidian.lua`
  - Estado: **DONE**
  - Problema: `config` function está dentro de `opts` table, no como key top-level
  - Solución: Mover `config` a primer nivel del spec de lazy.nvim
  - **Commit:** fix(tools): fix obsidian.lua config nesting

- [x] **Issue #5: tsserver está deprecado — debe ser ts_ls**
  - Archivos: `lua/angel/plugins/lsp/mason.lua`, `lua/angel/plugins/lsp/lspconfig.lua`
  - Estado: **DONE**
  - Problema: tsserver fue renombrado a ts_ls en mason/lspconfig modernos (2025+)
  - Solución: Cambiar `tsserver` → `ts_ls` en ambos archivos
  - **Commit:** fix(lsp): rename tsserver to ts_ls

- [x] **Issue #6: LSP keymaps sin descripción**
  - Archivo: `lua/angel/plugins/lsp/lspconfig.lua`
  - Estado: **DONE**
  - Problema: `on_attach` define keymaps con `opts` pero sin `desc` field. Which-key no puede mostrar descripciones útiles
  - Solución: Agregar `desc` a todos los keymaps (gd, gD, gi, gr, K, <leader>ca, etc)
  - **Commit:** feat(lsp): add desc to all on_attach keymaps

---

## 🟡 PRIORIDAD MEDIA

- [ ] **Issue #7: Migrar neodev.nvim → lazydev.nvim**
  - Archivo: `lua/angel/plugins/lsp/lspconfig.lua`
  - Estado: **PENDING**
  - Problema: folke/neodev.nvim está deprecado, reemplazado por folke/lazydev.nvim
  - Solución: Reemplazar `neodev.nvim` dependency por `lazydev.nvim`
  - Referencia: https://github.com/folke/lazydev.nvim

- [ ] **Issue #8: Eliminar FixCursorHold.nvim**
  - Archivo: `lua/angel/plugins/testing/neotest.lua`
  - Estado: **PENDING**
  - Problema: FixCursorHold.nvim era un workaround para un bug en Neovim < 0.10. Ya no es necesario
  - Solución: Eliminar de neotest deps
  - Reemplazo: Nada (built-in fix)

- [ ] **Issue #9: Reemplazar vim-highlightedyank con autocmd built-in**
  - Archivos: `lua/angel/plugins/misc/`, `lua/angel/core/init.lua`
  - Estado: **PENDING**
  - Problema: Neovim 0.5+ tiene `vim.highlight.on_yank()` built-in. Plugin Vimscript es innecesario
  - Solución: Eliminar plugin, agregar autocmd a core/init.lua:
    ```lua
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
    })
    ```

- [ ] **Issue #10: Cambiar neotest de event a keys/cmd**
  - Archivo: `lua/angel/plugins/testing/neotest.lua`
  - Estado: **PENDING**
  - Problema: `event = { "BufReadPost", "BufNewFile" }` hace que neotest + 4 adaptadores carguen con cada archivo
  - Solución: Cambiar a `keys` o `cmd = { "Neotest" }` (lazy loading on demand)
  - Beneficio: Mejora startup time significativamente

- [ ] **Issue #11: Sacar lazy = false de avante.nvim**
  - Archivo: `lua/angel/plugins/tools/avante.lua`
  - Estado: **PENDING**
  - Problema: `lazy = false` hace que cargue en startup, ignorando `event = "VeryLazy"`
  - Solución: Eliminar `lazy = false`. Mantener `event = "VeryLazy"` o cambiar a `keys` on demand

- [ ] **Issue #12: Eliminar vim.deprecate hack y arreglar warnings reales**
  - Archivo: `lua/angel/core/options.lua`
  - Estado: **PENDING**
  - Problema: `vim.deprecate = function() end` oculta errores reales cuando plugins usan APIs deprecadas
  - Solución: Eliminar el override. Corregir los warnings que generen los plugins

- [ ] **Issue #13: Eliminar override de vim.notify**
  - Archivo: `lua/angel/core/init.lua`
  - Estado: **PENDING**
  - Problema: Override de `vim.notify` silencia warnings de which-key en vez de arreglar keymaps mal definidos
  - Solución: Eliminar el override. Corregir keymaps que generan warnings

- [ ] **Issue #14: Fix nvim-surround buffer_setup**
  - Archivo: `lua/angel/plugins/editing/nvim-surround.lua` (crear)
  - Estado: **PENDING**
  - Problema: `buffer_setup()` se llama en config global, no en autocmd per-buffer. Solo aplica al buffer activo cuando carga
  - Solución: Usar `FileType` autocmd para que funcione en todos los buffers JS/TS:
    ```lua
    require("nvim-surround").buffer_setup({
      surrounds = {
        ["$"] = { "$", "$" }, -- math mode in LaTeX, etc
      },
    })
    ```

- [ ] **Issue #15: Migrar Python de pylint+isort+black a ruff**
  - Archivos: `lua/angel/plugins/lsp/mason.lua`, `lua/angel/plugins/formatting/conform.lua`, `lua/angel/plugins/formatting/nlint.lua`
  - Estado: **PENDING**
  - Problema: pylint es pesado y lento. En 2026, ruff reemplaza pylint, flake8, isort Y black en una sola herramienta (10-100x más rápido)
  - Solución:
    - `mason.lua`: Agregar `"ruff"` a ensure_installed
    - `conform.lua`: Cambiar `python = { "black", "isort" }` → `python = { "ruff_format" }`
    - `nlint.lua`: Cambiar `python = { "pylint" }` → `python = { "ruff" }`

---

## 🔵 MEJORA OPCIONAL

- [ ] **Issue #16: Agregar lazy loading a nvim-scrollbar**
  - Archivo: `lua/angel/plugins/ui/` (verificar archivo)
  - Estado: **PENDING**
  - Problema: No tiene event, cmd, ni keys. Con `lazy = true` por default, probablemente nunca carga
  - Solución: Agregar `event = "BufReadPost"`

- [ ] **Issue #17: Agregar lazy loading a session-lens**
  - Archivo: `lua/angel/plugins/misc/session-lens.lua` (o similar)
  - Estado: **PENDING**
  - Problema: Sin trigger de lazy loading
  - Solución: Agregar `cmd` o `keys`, o evaluar si se usa (auto-session ya tiene integración con Telescope)

- [ ] **Issue #18: Evaluar vim-mkdir**
  - Archivo: `lua/angel/plugins/misc/` (verificar archivo)
  - Estado: **PENDING**
  - Problema: Sin trigger de lazy loading — probablemente nunca carga
  - Solución: Si no se usa, eliminarlo. Si se usa, agregar `event = "BufWritePre"`

- [ ] **Issue #19: Evaluar redundancia de gen.nvim + avante.nvim + opencode**
  - Archivos: Múltiples (tooling AI)
  - Estado: **PENDING**
  - Problema: 3 integraciones AI locales puede ser redundante
  - Solución: Elegir 1-2 principales para mantener
  - Nota: Requiere decisión del usuario

- [ ] **Issue #20: Agregar event = "InsertEnter" a vim-endwise**
  - Archivo: `lua/angel/plugins/editing/` (verificar archivo)
  - Estado: **PENDING**
  - Problema: Actual trigger es `BufReadPre`, menos eficiente
  - Solución: Cambiar a `event = "InsertEnter"` para lazy loading más eficiente

- [ ] **Issue #21: Eliminar event redundante de substitute.nvim**
  - Archivo: `lua/angel/plugins/editing/substitute.nvim.lua` (o similar)
  - Estado: **PENDING**
  - Problema: Tiene `event` y `keys`. Los keys son suficientes, el event es redundante
  - Solución: Eliminar `event` trigger

---

## 🧹 LIMPIEZA ESTÉTICA

- [ ] **Issue #22: Eliminar comentarios de Copilot en keymaps.lua**
  - Archivo: `lua/angel/core/keymaps.lua`
  - Estado: **PENDING**
  - Problema: ~16 líneas de keymaps de Copilot comentados (líneas 34-50)
  - Solución: Eliminar código muerto

- [ ] **Issue #23: Eliminar g:netrw_liststyle**
  - Archivo: `lua/angel/core/options.lua`
  - Estado: **PENDING**
  - Problema: netrw está deshabilitado pero g:netrw_liststyle está configurado (código muerto)
  - Solución: Eliminar `vim.g.netrw_liststyle = ...`

- [ ] **Issue #24: Archivar docs de fases completadas**
  - Archivos: `docs/development/PHASE_TRACKING.md`, `docs/testing/PHASE4_TESTING.md`, `docs/development/PHASE5_API_AUDIT.md`
  - Estado: **PENDING**
  - Problema: Docs de fases que ya cumplieron su propósito (no aportan valor activo)
  - Solución: Mover a `docs/archive/` o eliminar

- [ ] **Issue #25: Unificar default_format_opts y format_on_save en conform.lua**
  - Archivo: `lua/angel/plugins/formatting/conform.lua`
  - Estado: **PENDING**
  - Problema: `default_format_opts.timeout_ms = 500` y `format_on_save.timeout_ms = 2000`. El default nunca se usa
  - Solución: Unificar en uno solo (`format_on_save.timeout_ms = 2000` es el que se usa)

---

## 📊 Summary

| Categoría | Total | Done | Pending |
|-----------|-------|------|---------|
| 🚨 PRIMERA PRIORIDAD | 6 | 6 | 0 |
| 🟡 PRIORIDAD MEDIA | 9 | 0 | 9 |
| 🔵 MEJORA OPCIONAL | 6 | 0 | 6 |
| 🧹 LIMPIEZA ESTÉTICA | 4 | 0 | 4 |
| **TOTAL** | **25** | **6** | **19** |

**Progreso:** 6/25 (24%) ⚠️

---

## 🔗 Referencias

- **Auditoría completa:** `docs/prompts/02-technical-auditory-nvim-config.md`
- **User guide:** `docs/user-guide/WARP.md`
- **Troubleshooting:** `docs/user-guide/TROUBLESHOOTING.md`