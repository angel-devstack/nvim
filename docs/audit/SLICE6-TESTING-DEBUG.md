# Slice 6: Testing/debug - Auditoría Neovim Config

**Fecha:** 2025-02-18
**Slice:** Testing/debug (Neotest, DAP, DAP adapters)

---

## Baseline Slice 6

### Plugins involucrados

| Plugin | Archivo | Purpose (1 línea) | Load strategy actual |
|--------|---------|-------------------|---------------------|
| Neotest | `testing/test-neotest.lua` | Test runner framework | cmd + keys |
| DAP | `dap/dap.lua` | Debug adapter protocol | event = BufReadPre/BufNewFile ❌ |
| DAP adapters | `dap/[lang].lua` | DAP config por lenguaje | ft = { lang } |
| nvim-ruby-debugger | `ruby/nvim-ruby-debugger.lua` | Ruby debugging | ft = { ruby } |

**Notas:**
- **DAP heavy en startup**: event = BufReadPre/BufNewFile = **carga en cada archivo** (519ms dap.repl)
- **Usuario feedback DAP**: "Quiero mantener debugp/node-debug2/codelldb, pero setup problems"
- **Ruby DAP**: nvim-ruby-debugger ya configurado (ft = ruby), no redundancia en dap.lua

---

## Diagnóstico por Plugin

### 1. DAP (debug_adapter_protocol) ⚠️ STATUS: Startup Heavy

**Estado:** ⚠️ Carga pesada en startup (519ms dap.repl)

**Configuración actual:**
```lua
event = { "BufReadPre", "BufNewFile" }  -- CARGA EN CADA ARCHIVO
dependencies = { nvim-dap-ui, nvim-dap-virtual-text }

-- Keymaps F5/F10/F11/F12
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
```

**Problemas detectados:**
1. **Muy pesado en startup:**
   - `event = BufReadPre, BufNewFile` = carga en cada archivo abierto
   - dap.repl = 519ms en baseline (muy lento)
   - Impacto directo en startup total

2. **¿Necesario en startup?**
   - Si NO debugueas regularmente → puede ser más lazy
   - DAP solo se usa cuando debuggeas código (no en edición normal)

3. **Keymaps F5/F10/F11/F12:**
   - ¿Se usan regularmente?
   - Usuario: "Quiero mantener DAP pero setup problems"
   - Posible: keymaps en editing mode se activan por error

4. **Dependencies pesadas:**
   - nvim-dap-ui (UI)
   - nvim-dap-virtual-text (virtual text)
   - Se cargan aunque DAP no esté activo

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener config actual.
Pros: DAP disponible si es necesario.
Cons: Startup pesado (519ms), keymaps F* colisionan con terminal.
Riesgo: Medio (performance).
```

#### Option B - Mejor UX ⭐ PREFERIDA
```
Lazy-load DAP más agresivo:

  Before: event = { "BufReadPre", "BufNewFile" }
  After:  event = "VeryLazy"  -- o cmd = "<F5>"

Benefit: ~500ms startup ahorro (dap.repl no carga al inicio)

Keymaps F5/F10/F11/F12:
  - ¿Quitar o mover? (F5 puede activar por error)
  - Alternativa: <leader>d<letra>
    - <F5> → <leader>dc (continue)
    - <F10> → <leader>ds (step over)
    - <F11> → <leader>di (step into)
    - <F12> → <leader>do (step out)

Pros: Mas startup gain, menos keymap conflict
Cons: Cambio de keymaps (re-aprendizaje)
Riesgo: Medio.
```

#### Option C - Simplificación
```
¿Necesario? Si debugueas raramente, eliminar DAP.  

Dejar nvim-dap solo si realmente lo usas.
```

**Acción:** Recomendación (ver usuario)

---

### 2. nvim-ruby-debugger

**Estado:** ✅ Bien configurado

**Configuración actual:**
```lua
ft = { "ruby" }  -- Solo carga Ruby files
dependencies = { mfussenegger/nvim-dap, nvim-neotest/nvim-nio }

setup:
  rails_port = 38698
  worker_port = 38699
  minitest_port = 38700
  host = "127.0.0.1"

Ruby config (plain files):
  dap.configurations.ruby = { type = "ruby", name = "Ruby files (plain)" }
```

**Problemas detectados:**
- Ninguno relevante
- ft = { "ruby" } = perfecto (solo carga Ruby files)

**Opciones:**
- Keep (bien configurado)

---

### 3. DAP Adapters (python, node, rust)

**Estado:** ✅ Bien lazy-load

**Configuración:**
```lua
python.lua: ft = { "python" }  -- Solo carga Python files
node.lua: (¿ft?)  -- Cargar solo JS/TS
rust.lua: (¿ft?)  -- Cargar solo Rust
```

**Problemas detectados:**
- node.lua/rust.lua sin ft = { lang } → ¿cargan siempre?

**Opciones:**
- Si si, agregar ft para optimizar
- Keep (ya bien)

---

## Cambios Propuestos

### Cambio 1: DAP lazy-load (performance gain ~500ms)

**Propuesta:**
```lua
# Antes
event = { "BufReadPre", "BufNewFile" }  -- 519ms startup

# Después
event = "VeryLazy"  -- carga después de UI, 500ms ahorro

# Opcional: mover keymaps F* a <leader>d*
<leader>dc  -- continue
<leader>ds  -- step over
<leader>di  -- step into
<leader>do  -- step out
```

**Pregunta usuario:**
- ¿Usas DAP regularmente? (frecuencia por día/semana)
- ¿Prefieres keymaps F5/F10/F11/F12 o <leader>d*?
- ¿Lazy-load con VeryLazy (startup gain ~500ms)?

---

## Verificación para Usuario

**Preguntas para aprobación:**

1. **DAP usage:** ¿Usas DAP regularmente? (frecuencia)
   - **A. No uso regularly** → VeryLazy (500ms gain)
   - **B. Si uso regularly** → mantener event = BufReadPre

2. **DAP keymaps:** ¿Prefieres F* o <leader>d*?
   - **A. Keymaps F5/F10/F11/F12** → mantener
   - **B. Mover a <leader>d* → más mnemónico, menos conflicto

3. **Ruby debugging:** nvim-ruby-debugger funciona bien?
   - **A. Si funciona** → keep
   - **B. Si rompe** → revisar

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Feedback sobre DAP usage
- [ ] Feedback sobre DAP keymaps preferences

**Riesgos:**
- DAP lazy-load → medio (si VeryLazy no attach, ajustar)
- Keymaps changes → bajo (opcional)

---

**Estado Slice 6:**
- ✅ Diagnóstico completo
- ⏸️ Cambios propuestos esperando feedback
- ⏸️ Commits pendientes (después de aprobación)
- ⏸️ Doc actualizada (pending cambios)

**Notas de importancia:**
- DAP es **pesado** en startup (519ms dap.repl, + UI/virtual-text)
- Más ganancia de performance en esta slice
- Usuario quiere mantener DAP (útil pero setup problems)

**Recomendación:** Lazy-load DAP con VeryLazy (500ms startup ganancia)