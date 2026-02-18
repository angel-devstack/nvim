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

- [x] **Issue #7: Migrar neodev.nvim → lazydev.nvim**
  - Archivo: `lua/angel/plugins/lsp/lspconfig.lua`
  - Estado: **DONE**
  - Problema: folke/neodev.nvim está deprecado, reemplazado por folke/lazydev.nvim
  - Solución: Reemplazar `neodev.nvim` dependency por `lazydev.nvim`
  - **Commit:** migrate(lsp): replace neodev.nvim with lazydev.nvim

- [x] **Issue #8: Eliminar FixCursorHold.nvim**
  - Archivo: `lua/angel/plugins/testing/test-neotest.lua`
  - Estado: **DONE**
  - Problema: FixCursorHold.nvim era un workaround para un bug en Neovim < 0.10. Ya no es necesario
  - Solución: Eliminar de neotest deps
  - Reemplazo: Nada (built-in fix)
  - **Commit:** refactor(testing): remove FixCursorHold.nvim and lazy-load neotest

- [x] **Issue #9: Reemplazar vim-highlightedyank con autocmd built-in**
  - Archivos: `lua/angel/plugins/misc/`, `lua/angel/core/init.lua`
  - Estado: **DONE**
  - Problema: Neovim 0.5+ tiene `vim.highlight.on_yank()` built-in. Plugin Vimscript es innecesario
  - Solución: Eliminar plugin, agregar autocmd a core/init.lua
  - **Commit:** refactor(misc): replace vim-highlightedyank with built-in

- [x] **Issue #10: Cambiar neotest de event a keys/cmd**
  - Archivo: `lua/angel/plugins/testing/test-neotest.lua`
  - Estado: **DONE**
  - Problema: `event = { "BufReadPost", "BufNewFile" }` hace que neotest + 4 adaptadores carguen con cada archivo
  - Solución: Cambiar a `cmd = { "Neotest" }` y `keys` para lazy loading on demand
  - Beneficio: Mejora startup time significativamente
  - **Commit:** refactor(testing): remove FixCursorHold.nvim and lazy-load neotest

- [x] **Issue #11: Eliminar avante.nvim**
  - Archivo: `lua/angel/plugins/tools/avante.lua`
  - Estado: **DONE**
  - Problema: AI asistente redundante (solo se usa opencode)
  - Solución: Eliminar plugin completamente
  - **Commit:** refactor(tools): remove redundant AI assistants (gen.nvim, avante.nvim)

- [x] **Issue #12: Eliminar vim.deprecate hack y arreglar warnings reales**
  - Archivo: `lua/angel/core/options.lua`
  - Estado: **DONE**
  - Problema: `vim.deprecate = function() end` oculta errores reales cuando plugins usan APIs deprecadas
  - Solución: Eliminar el override. Corregir los warnings que generen los plugins
  - **Commit:** refactor(core): remove vim.deprecate override

- [x] **Issue #13: Eliminar override de vim.notify**
  - Archivo: `lua/angel/core/init.lua`
  - Estado: **DONE**
  - Problema: Override de `vim.notify` silencia warnings de which-key en vez de arreglar keymaps mal definidos
  - Solución: Eliminar el override. Corregir keymaps que generan warnings
  - **Commit:** refactor(core): remove vim.notify override

- [x] **Issue #14: Fix nvim-surround buffer_setup**
  - Archivo: `lua/angel/plugins/editing/nvim-surround.lua`
  - Estado: **DONE**
  - Problema: `buffer_setup()` se llama en config global, no en autocmd per-buffer. Solo aplica al buffer activo cuando carga
  - Solución: Usar `FileType` autocmd para que funcione en todos los buffers JS/TS
  - **Commit:** fix(editing): move nvim-surround buffer_setup to FileType autocmd

- [x] **Issue #15: Migrar Python de pylint+isort+black a ruff**
  - Archivos: `lua/angel/plugins/lsp/mason.lua`, `lua/angel/plugins/formatting/conform.lua`, `lua/angel/plugins/formatting/linting.lua`
  - Estado: **DONE**
  - Problema: pylint es pesado y lento. En 2026, ruff reemplaza pylint, flake8, isort Y black en una sola herramienta (10-100x más rápido)
  - Solución: Agregar "ruff" a mason_tool_installer, cambiar python formatter y linter a ruff
  - **Commit:** migrate(python): replace pylint+isort+black with ruff

---

## 🔵 MEJORA OPCIONAL

- [x] **Issue #16: Agregar lazy loading a nvim-scrollbar**
  - Archivo: `lua/angel/plugins/ui/nvim-scrollbar.lua`
  - Estado: **DONE**
  - Problema: No tenía event, cmd, ni keys. Con `lazy = true` por default, probablemente nunca cargaba
  - Solución: Agregar `event = "BufReadPost"`
  - **Commit:** feat(ui): add lazy loading to nvim-scrollbar

- [x] **Issue #17: Evaluar session-lens (decisión: eliminar)**
  - Archivo: `lua/angel/plugins/misc/session-lens.lua` (ELIMINADO)
  - Estado: **DONE**
  - Problema: Sin trigger de lazy loading. Evaluar si se usa (auto-session ya tiene integración con Telescope)
  - Solución: Eliminar plugin. Auto-session ya tiene integración para Telescope (`:Telescope session-lens search_session`)
  - **Commit:** fix(bootstrap): remove broken imports, fix obsidian structure

- [x] **Issue #18: Evaluar vim-mkdir (decisión: eliminar)**
  - Archivo: `lua/angel/plugins/misc/vim-mkdir.lua` (ELIMINADO)
  - Estado: **DONE**
  - Problema: Sin trigger de lazy loading — probablemente nunca carga
  - Solución: Eliminar plugin (no se usa, mkdir builtin de Neovim es suficiente)
  - **Commit:** fix(bootstrap): remove broken imports, fix obsidian structure

 - [x] **Issue #19: Eliminar redundancia de asistentes AI**
  - Archivos: Múltiples (tooling AI)
  - Estado: **DONE**
  - Problema: 3 integraciones AI redundantes (gen.nvim, avante.nvim, opencode)
  - Solución: Mantener solo opencode, eliminar gen.nvim y avante.nvim
  - **Commit:** refactor(tools): remove redundant AI assistants (gen.nvim, avante.nvim)

- [x] **Issue #20: Agregar event = "InsertEnter" a vim-endwise**
  - Archivo: `lua/angel/plugins/editing/vim-endwise.lua`
  - Estado: **DONE**
  - Problema: Actual trigger es `BufReadPre`, menos eficiente
  - Solución: Cambiar a `event = "InsertEnter"` para lazy loading más eficiente
  - **Commit:** refactor(cleanup): complete issues #20-24, archive phase docs, remove dead code

 - [x] **Issue #21: Eliminar event redundante de substitute.nvim**
  - Archivo: `lua/angel/plugins/editing/substitute.lua`
  - Estado: **DONE**
  - Problema: Tiene `event` y `keys`. Los keys son suficientes, el event es redundante
  - Solución: Eliminar `event` trigger
  - **Commit:** refactor(cleanup): complete issues #20-24, archive phase docs, remove dead code

---

## 🧹 LIMPIEZA ESTÉTICA

- [x] **Issue #22: Eliminar comentarios de Copilot en keymaps.lua**
  - Archivo: `lua/angel/core/keymaps.lua`
  - Estado: **DONE**
  - Problema: ~16 líneas de keymaps de Copilot comentados (líneas 34-50), código muerto
  - Solución: Eliminar código muerto, limpiar comentarios redundantes
  - **Commit:** refactor(cleanup): complete issues #20-24, archive phase docs, remove dead code

- [x] **Issue #23: Eliminar g:netrw_liststyle**
  - Archivo: `lua/angel/core/options.lua`
  - Estado: **DONE**
  - Problema: netrw está deshabilitado pero g:netrw_liststyle está configurado (código muerto)
  - Solución: Eliminar `vim.g.netrw_liststyle = ...`
  - **Commit:** refactor(cleanup): complete issues #20-24, archive phase docs, remove dead code

- [x] **Issue #24: Archivar docs de fases completadas**
  - Archivos: `docs/development/PHASE_TRACKING.md`, `docs/testing/PHASE4_TESTING_GUIDE.md`, `docs/development/PHASE5_API_AUDIT.md`
  - Estado: **DONE**
  - Problema: Docs de fases que ya cumplieron su propósito (no aportan valor activo)
  - Solución: Mover a `docs/archive/`
  - **Commit:** refactor(cleanup): complete issues #20-24, archive phase docs, remove dead code

- [x] **Issue #25: Unificar default_format_opts y format_on_save en conform.lua**
  - Archivo: `lua/angel/plugins/formatting/conform.lua`
  - Estado: **DONE**
  - Problema: Solo existe format_on_save.timeout_ms, no hay default_format_opts redundante
  - **Commit:** (No se requiere cambio - ya unificado correctamente)

---

## 📊 Summary

| Categoría | Total | Done | Pending |
|-----------|-------|------|---------|
| 🚨 PRIMERA PRIORIDAD | 6 | 6 | 0 |
| 🟡 PRIORIDAD MEDIA | 9 | 9 | 0 |
| 🔵 MEJORA OPCIONAL | 6 | 6 | 0 |
| 🧹 LIMPIEZA ESTÉTICA | 4 | 4 | 0 |
| **TOTAL** | **25** | **25** | **0** |

**Progreso:** 25/25 (100%) ✅ **TODOS LOS ISSUES COMPLETADOS**

---

## 🔗 Referencias

- **Auditoría completa:** `docs/prompts/02-technical-auditory-nvim-config.md`
- **User guide:** `docs/user-guide/WARP.md`
- **Troubleshooting:** `docs/user-guide/TROUBLESHOOTING.md`