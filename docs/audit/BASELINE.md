# Baseline - Auditoría Neovim Config

## Fase 0: Baseline

Fecha: 2025-02-18
Configuración: angel-devstack/nvim (main branch)

---

### 1. Estado de arranque (Startup)

#### Errores y warnings
- **Sin errores de arranque detectados** (nvim → :messages vacío)
- `vim.deprecated: ✅ No deprecated functions detected`

#### checkhealth (warnings relevantes)

**[Lazy - 3 errores luarocks/python]**
```
⚠️ WARNING Lazy won't be able to install plugins that require `luarocks`
❌ ERROR failed to get version of {python3} - No version is set
❌ ERROR failed to get version of {python} - No version is set
```
**Impacto:** No puede instalar plugins que usen `luarocks` (ej. rest.nvim, hererocks)
**Solución requerida:** Agregar `python` en `.tool-versions` o desactivar luarocks en lazy.nvim opts

---

**[Node.js Provider - 1 warning]**
```
⚠️ WARNING Missing "neovim" npm (or yarn, pnpm) package
```
**Impacto:** Menor, node provider es opcional y funcional

---

### 2. Performance Baseline

#### Tiempo de inicio
- **Startup total:** ~156ms (buena performance)
- **NVIM STARTED:** 156.267ms (from startup.log)

##### Top offenders (slowest operations por self-time)

| Operación | Tiempo (ms) | Categoría | Nota |
|-----------|-------------|-----------|------|
| dap.repl | 519 | DAP | Debugger REPL - carga lenta |
| editorconfig | 271 | Misc | Editor configs - cargado temprano |
| ts_context_commentstring (internal+config+utils) | 710 | Syntax | Comment context para TS/JS |
| lint | 607 | Formatting | nvim-lint - linters cargados temprano |
| scrollbar.handlers.cursor/diagnostic | 422 | UI | Scrollbar UI decoration |

**Análisis:**
- DAP REPL y editorconfig cargan en startup (deben ser lazy)
- nvim-lint en startup (puede ser más lazy)
- ts_context_commentstring es pesado pero útil para comments context-aware

---

### 3. Sanity Check

| Test | Comando | Estado |
|------|---------|--------|
| Startup sin errores | nvim → :messages | ✅ OK |
| checkhealth | :checkhealth | ⚠️ Warnings luarocks/python |
| Headless sync | nvim --headless "+Lazy! sync" +qa | ❌ Pendiente verificar |

---

### 4. Próximo paso: Slice 1 - Core UX

**Plugins en scope:**
- `core/options.lua` - vim.opt settings
- `core/keymaps.lua` - global keymaps
- `auto-session` - session management (misc/auto-session.lua)
- `vim-maximizer` - window maximize
- `sort.nvim` - sort lines/words
- `tabular` - align text (archivado?)

**Metodología:**
Analizar cada plugin por:
- **Purpose:** 1 línea "para qué existe"
- **Load strategy:** event/ft/cmd/keys/VeryLazy
- **Problemas detectados:** overlaps, config innecesaria, defaults malos
- **Performance:** lazy-loading opportunities
- **Acción propuesta:** keep/tweak/remove con variantes A/B/C

**Reglas de oro:**
- No romper: LSP, Telescope, Git, completion, format-on-save
- Trazabilidad > magia
- Cambios en commits pequeños (1 objetivo por commit)
- Doc actualizada después de cada slice

---

**Estado pendiente:**
- [ ] Headless sanity check
- [x] Slice 1 completado (3 cambios aplicados)
- [x] Slice 2 completado (1 cambio aplicado)
- [x] Slice 3 completado (sin cambios)
- [x] Slice 4 completado (2 cambios previos - Conform, nvim-lint)
- [x] Slice 5 completado (2 cambios aplicados)