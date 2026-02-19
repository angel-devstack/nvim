# Slice 6: Testing/debug - Diagnóstico Completo

**Fecha:** 2025-02-18
**Slice:** Testing/debug (Neotest, DAP, DAP adapters)

---

## Resumen Ejecutivo

| Plugin | Problema | Solución propuesta | Riesgo |
|--------|----------|-------------------|--------|
| DAP | Startup pesado (519ms dap.repl, carga en cada archivo) | VeryLazy + keymaps optional | Medio |
| node.lua (DAP) | No ft = { lang } (carga siempre) | Agregar ft = { javascript, typescript } | Bajo |
| rust.lua (DAP) | ✅ ft = { rust } (bien configurado) | Keep | None |
| Neotest | cmd = "Neotest" (OK, pero puede ser VeryLazy) | VeryLazy opcional | Bajo |
| nvim-ruby-debugger | ✅ ft = { ruby } | Keep | None |

**Prioridad:** DAP是最重的 startup issue (519ms - ~33% de startup)

---

## Diagnóstico por Plugin

### 1. DAP (debug_adapter_protocol) ⚠️ STARTUP HEAVY (prioridad alta)

**Estado:** ⚠️ Startup pesado (519ms dap.repl)

**Configuración actual:**
```lua
event = { "BufReadPre", "BufNewFile" }  -- CARGA en CADA ARCHIVO
dependencies = { nvim-dap-ui, nvim-dap-virtual-text }

keymaps:
  <F5>  -- dap.continue
  <F10> -- dap.step_over
  <F11> -- dap.step_into
  <F12> -- dap.step_out
  <leader>db -- toggle breakpoint
  <leader>dr -- repl open
  <leader>dl -- run last
```

**Problemas detectados:**

1. **Startup muy pesado:**
   - `event = BufReadPre, BufNewFile` = carga en cada archivo
   - dap.repl = 519ms (33% de startup total 156ms)
   - **Ganancia potencial**: ~500ms si lazy-load

2. **Keymaps F5/F10/F11/F11/F12:**
   - ¿Se usan regularmente?
   - Posible colisión con terminal (F5 puede activar por error)
   - Usuario: "Quiero mantener DAP pero setup problems"

3. **Dependencies pesadas:**
   - nvim-dap-ui + nvim-dap-virtual-text se cargan incluso si DAP inactivo

**Opciones (A/B/C):**

#### Option A - Conservadora (keep event = BufReadPre)
```
Mantener config actual.
Pros: DAP disponible si es necesario.
Cons: Startup pesado (519ms), keymaps F* colisionan.
Riesgo: Medio (performance).
```

#### Option B - Mejor UX ⭐ PREFERIDA
```
Lazy-load DAP con VeryLazy:

  Before: event = { "BufReadPre", "BufNewFile" }  -- 519ms startup
  After: event = "VeryLazy"  -- 500ms startup gain

Keymaps (opcional - ver si usuario cambio):
  - Keep F5/F10/F11/F12 OR
  - Mover a <leader>d* (más mnemónico, menos conflicto)
    <leader>dc -- continue
    <leader>ds -- step over
    <leader>di -- step into
    <leader>do -- step out

Pros: ~500ms startup gain, menos keymap conflict
Cons: Cambio de keymaps (si se decide)
Riesgo: Medio.
```

#### Option C - Simplificación
```
¿Necesario? Si debugueas raramente, eliminar DAP.

Dejar nvim-dap solo si realmente lo usas.
```

---

### 2. node.lua (DAP adapter) ⚠️ NO ft = { lang }

**Estado:** ⚠️ Carga siempre (sin ft)

**Configuración actual:**
```lua
"mxsdev/nvim-dap-vscode-js"
dependencies = { mfussenegger/nvim-dap }
# ❌ SIN ft = { "javascript", "typescript" } -- carga siempre
```

**Problemas detectados:**
- No tiene `ft = { lang }` → carga en startup (aunque solo se usa cuando debuggeas JS/TS)
- Debería tener `ft = { "javascript", "typescript" }` como python.lua tiene

**Solución propuesta:**
- Agregar `ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }`

---

### 3. rust.lua (DAP adapter)

**Estado:** ✅ Bien configurado

```lua
ft = { "rust" }  -- Solo carga Rust files ✅
configurations.rust = { codelldb debug }
```

**Opciones:** Keep

---

### 4. Neotest

**Estado:** ✅ CMD lazy (good)

```lua
cmd = { "Neotest" }  -- Solo carga con :Neotest command
keys = { <leader>tt/tr/ta/tS/to/ts }
```

**Opción de mejora:**
- Si se usa raramente: optional `event = "VeryLazy"`
- Actual: `cmd` es suficiente

---

### 5. nvim-ruby-debugger

**Estado:** ✅ Bien configurado

```lua
ft = { "ruby" }  -- Solo carga Ruby files ✅
```

**Opciones:** Keep

---

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Load strategy | Opción | Riesgo |
|--------|--------|-------------|---------------|-------|--------|
| DAP | ⚠️ Startup heavy | BufReadPre (519ms) | Change to VeryLazy | B | Medio |
| node.lua | ⚠️ No ft | Carga siempre | Agregar ft | Medium | Bajo |
| rust.lua | ✅ Bien | ft = { rust } | Keep | A | None |
| Neotest | ✅ CMD | Good | Keep/Folder | C | Bajo |
| nvim-ruby-debugger | ✅ Bien | ft = { ruby } | Keep | A | None |

---

## Cambios Propuestos

### Cambio 1: DAP lazy-load VeryLazy (500ms startup gain)

**Priority alta: Startup performance**

```lua
# Antes
event = { "BufReadPre", "BufNewFile" }
# After
event = "VeryLazy"
```

**Pregunta usuario:**
1. ¿Usas DAP regularmente? (frecuencia por día/semana)
   - **A. No uso regular** → VeryLazy (recomendado)
   - **B. Si uso regular** → mantener BufReadPre

2. ¿Prefieres keymaps F5/F10/F12/F12 o <leader>d*?
   - **A. Mantener F* ** → no cambio (pero puede colisionar)
   - **B. Cambiar a <leader>d*** → más mnemónico <leader>dc, <leader>ds, etc.)

---

### Cambio 2: Optimizar node.lua (opcional)

```lua
# Antes
return { "mxsdev/nvim-dap-vscode-js", ... }  # carga siempre

# Después
ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }
```

**Requiere:** Commit separado

---

## Verificación para Usuario

**Fase 6 preguntas:**

1. **DAP usage:** ¿Frecuencia de uso? (por dia/semana/mes)
   - [ ] Nunca/Muy raramente
   - [ ] Ocasional (1-2x/semana)
   - [ ] Regular (diario o casi)

2. **DAP keymaps:** ¿Prefieres F* o <leader>d*?
   - [ ] Mantener F5/F10/F11/F12
   - [ ] Cambiar a <leader>d* (<leader>dc/ds/di/do)

3. **DAP preferred:**
   - [A] Mantener event = BufReadPre (startup pesado)
   - [B] Change to VeryLazy (500ms gain)

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Feedback DAP usage
- [ ] Feedback DAP keymaps偏好
- [ ] Feedback node.lua si aplica

**Riesgos:**
- DAP VeryLazy → medio (si no attach bien, ajustar)
- node.lua ft agregación → bajo

---

**Estado Slice 6:**
- ✅ Diagnóstico completo

**Priority:**
1. DAP lazy-load (500ms startup gain highest priority)
2. node.lua optimizations (medium gain)

**Próximo:** Slice 7 - UI/Visual (lualine, theme, indent, notifications)  

**Notas:**
- Slice 6 puede traer la mayor ganancia de performance de toda auditoría (~500ms)
- Commits previos total: 20 (+2 adicionales si se aplican)


```
73c5378 refactor(git): simplify gitsigns keymaps
496fc9f perf(git): lazy-load gitsigns with VeryLazy
94e5aa9 chore(git): remove lazygit
4a0f304 refactor(trouble): simplify keymaps
```

Continuar Slice 7 después de respuestas usuario.