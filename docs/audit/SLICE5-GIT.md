# Slice 5: Git - Auditoría Neovim Config

**Fecha:** 2025-02-18
**Slice:** Git (LazyGit, Neogit, Gitsigns, Git conflict)

---

## Baseline Slice 5

### Plugins involucrados

| Plugin | Archivo | Purpose (1 línea) | Load strategy actual |
|--------|---------|-------------------|---------------------|
| LazyGit | `git/lazygit.lua` | Git TUI (terminal) | cmd + keys |
| Neogit | `git/neogit.lua` | Magit-like interface in Neovim | cmd + keys |
| Gitsigns | `git/gitsigns.lua` | Git signs in gutter + hunk management | event + opts |
| Git conflict | `git/git-conflict.lua` | Conflict resolution in files | config |

**Notas:**
- LazyGit y Neogit → ambos hacen git status. Overlap?
- Gitsigns → line-by-line signs + hunk keymaps (13+)
- Git conflict → default_mappings = true

---

## Diagnóstico por Plugin

### 1. LazyGit ✅ STATUS: Bien

**Estado:** ✅ Bien lazy-load (cmd)

**Configuración actual:**
```lua
cmd = "LazyGit"
keys = { { "<leader>lg", "<cmd>LazyGit<CR>", desc = " Open LazyGit" } }
```

**Keymaps:** 1 keymap (<leader>lg)

**Problemas detectados:**
- Ninguno relevante

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener LazyGit.
Pros: Git TUI excelente, rápido en terminal.
Cons: Ninguno.
```

#### Option B - Mejor UX
```
Si usas Neogit también, LazyGit es redundante.
Sugerencia: keep ambos si prefieres TUI para complejos, Neogit para rápido.
```

#### Option C - Simplificación
```
Quitar LazyGit, usar solo Neogit.
Depende: ¿usas LazyGit regularmente?
```

**Acción:** Keep (depende de respuesta usuario)

---

### 2. Neogit ✅ STATUS: Bien

**Estado:** ✅ Bien lazy-load (cmd)

**Configuración actual:**
```lua
cmd = "Neogit"
keys = {
  <leader>gs -- status
  <leader>gf -- fetch
  <leader>gl -- pull
  <leader>gp -- push
  <leader>gP -- push force
  <leader>gc -- commit
}
dependencies = { diffview, telescope }
disable_commit_confirmation = true
```

**Keymaps:** 6+ keymaps (gs/gf/gl/gp/gP/gc)

**Problemas detectados:**
- Overlap con LazyGit (ambos hacen git status)
- ¿Usas ambos o prefieres uno?

**Análisis de uso:**
| Función | LazyGit | Neogit |
|---------|---------|--------|
| Git status | ✅ | ✅ |
| Rebase/merge | ✅ | ✅ |
| Diff view | ✅ | ✅ (diffview) |
| Commit | ✅ | ✅ |
| Fetch/pull | ❌ | ✅ |
| Push force | ❌ | ✅ |

**Overlap:** LazyGit hace todo lo que Neogit hace (y más). Pero Neogit keymaps son más mnemónicos.

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener ambos LazyGit y Neogit.
Pros: Flexibilidad (TUI para complejos, Neogit para rápido).
Cons: Duplicación funcional, 2 keymaps para mismo purpose.
```

#### Option B - Mejor UX ⭐ PREFERIDA (if user uses neogit)
```
Si usas Neogit regularmente, LazyGit es redundante:
  - LazyGit usado raramente → quitar
  - Neogit usado regularmente → keep

Razonamiento: Less plugins = simpler config.
```

#### Option C - Simplificación
```
Keep solo LazyGit o solo Neogit (no ambos).

Pregunta para usuario: ¿cuál prefieres usar regularmente?
```

**Acción:** Depende de respuesta usuario

---

### 3. Gitsigns ✅ STATUS: Bien (pero pesado)

**Estado:** ⚠️ OK pero muchos keymaps (13+)

**Configuración actual:**
```lua
event = { "BufReadPre", "BufNewFile" }  -- CARGA en cada archivo
opts = {
  current_line_blame = true,
  numhl = true,  -- number highlighting
  linehl = true,  -- line highlighting
  max_file_length = 10000,
}
```

**Keymaps (13):**
```lua
]h            -- next hunk
[h            -- prev hunk
<leader>ghs   -- stage hunk
<leader>ghr   -- reset hunk
<leader>ghS   -- stage buffer
<leader>ghR   -- reset buffer
<leader>ghu   -- undo stage hunk
<leader>ghp   -- preview hunk
<leader>ghb   -- blame line
<leader>ghB   -- toggle blame
<leader>ghd   -- diff this
<leader>ghD   -- diff this ~
ih (text object) -- select hunk
```

**Problemas detectados:**
1. **event = BufReadPre/BufNewFile** - **Carga en cada archivo** (pesado en startup)
   - Gitsigns hace mucha configuración en startup
   - `numhl = true` + `linehl = true` = puede ser lento en archivos grandes

2. **13 keymaps de hunk management**
   - ¿Usas todos? 
   - `]h/[h` (navigate hunks) - ? Alta
   - `ghs (stage) / ghr (reset) / ghu (undo stage)` - ? Media
   - `ghp (preview) / ghb (blame) / ghB (toggle blame) / ghd (diff)` - ? Baja

3. **current_line_blame = true** - ¿útil regularmente?
   - Muestra commit info al final de cada línea
   - Puede ser lento

**Análisis performance:**
```
 startup.log showed (Slice 0 baseline):
   - gitsigns config execution = 422ms (cursor+h diagnostic)
   - Carga en cada archivo = puede impactar startup > 500ms
```

**Opciones (A/B/C):**

#### Option A - Conservadora
```
Mantener Gitsigns con config actual.
Pros: Funcional completa (signs, blame, hunks).
Cons: Event = BufReadPre = carga en cada archivo (pesado).
```

#### Option B - Mejor UX ⭐ PREFERIDA
```
Lazy-load Gitsigns más agresivo:
  
  Before: event = { "BufReadPre", "BufNewFile" }
  After:  event = "VeryLazy"  -- carga después de UI
  OR       cond = function() ...  -- cargar solo en git repos

Benefit: No carga en startup (100-500ms ahorro).

Simplificar keymaps (quitar baja utilidad):
  Keep alto valor:
    ]h/[h (navigate)
    ghs/ghr (stage/reset)
    ghs/ghS (stage hunk/buffer)
  
  Quitar baja utilidad:
    ghu (undo) - ¿usas regularmente?
    ghp (preview) - built-in diff view?
    ghb/ghB (blame) - prefieres manual?
    ghd/ghD (diff) - built-in?

Benefits: Menos keymaps = menos confusión.
```

#### Option C - Simplificación
```
¿Necesario? Gitsigns vs LazyGit/Neogit:
  - Gitsigns = line-by-line signs en gutter
  - LazyGit = TUI, hace lo mismo visualmente
  
  Si YA usas LazyGit/Neogit, Gitsigns puede ser redundante para sign visualization.
```

**Acción:** Depende de respuesta usuario (si prefiere keep Gitsigns)

---

### 4. Git conflict ✅ STATUS: Bien

**Estado:** ✅ default_mappings true

**Configuración actual:**
```lua
version = "*"
default_mappings = true
default_commands = true

autocmd GitConflictDetected:
  vim.notify + vim.cmd("LspStop")

autocmd GitConflictResolved:
  vim.cmd("LspRestart")
```

**Problemas detectados:**
- Ninguno relevante
- default_mappings = true - útil

**Opciones (A/B/C):**

#### Option A - Conservadora ⭐ PREFERIDA
```
Mantener git-conflict.
Pros: Conflict resolution integrado en Neovim.
Cons: Ninguno.
```

**Acción:** Keep

---

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Performance | Opción | Riesgo |
|--------|--------|-------------|-------------|-------|--------|
| LazyGit | ✅ Bien | Overlap con Neogit | Good (cmd) | A/B/C | Bajo |
| Neogit | ✅ Bien | Overlap con LazyGit | Good (cmd) | A/B/C | Bajo |
| Gitsigns | ⚠️ Pesado | BufReadPre (carga cada archivo) | Heavy (event) | B | Medio |
| Git conflict | ✅ Bien | default_mappings OK | Good | A | None |

---

## Cambios Propuestos

### Cambio 1: Git overlap (LazyGit vs Neogit)

**Propuesta:**
Si usas ambos → redundancy
Si usas solo uno → quitar el otro

**Pregunta usuario:**
- ¿Usas LazyGit y Neogit regularmente?
- Si **SÍ usa ambos** → mantén ambos
- Si **NO usa LazyGit** → quitar LazyGit
- Si **NO usa Neogit** → quitar Neogit

### Cambio 2: Gitsigns lazy-load (Opcional - Option B)

**Propuesta:**
```lua
# Antes
event = { "BufReadPre", "BufNewFile" }  -- carga en cada archivo

# Después
event = "VeryLazy"  -- carga después de UI

# Simplificar keymaps (quitar baja utilidad)
Keep: ]h/[h, ghs/ghr, ghs/ghS
Quitar: ghu/ghp/ghb/ghB/ghd/ghD
```

**Pregunta usuario:**
- ¿Usas todos 13 keymaps de hunk management?
- ¿Simplificar a alto valor (~6 keymaps)?

---

## Verificación para Usuario

**Preguntas para aprobación:**

1. **Git overlap:** ¿Usas LazyGit y Neogit regularmente?
   - **A. Usar ambos** → mantener ambos
   - **B. Solo Neogit** → quitar LazyGit  
   - **C. Solo LazyGit** → quitar Neogit

2. **Gitsigns:** ¿Usas todos 13 keymaps de hunks? (blame, preview, diff, etc.)
   - **A. Usar todos** → mantener config actual
   - **B. Simplificar a alto valor (~6 keymaps)** → quitar baja utilidad

3. **Gitsigns performance:** ¿Lazy-load con "event = VeryLazy"? (no carga en startup)

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Feedback sobre Git overlap (LazyGit vs Neogit)
- [ ] Feedback sobre Gitsigns keymaps + lazy-load

**Riesgos:**
- Git plugin removal → medio (cambiar workflow)
- Gitsigns lazy-load → bajo (performance gain)

---

**Estado Slice 5:**
- ✅ Diagnóstico completo
- ⏸️ Cambios propuestos esperando feedback (overlap + Gitsigns)
- ⏸️ Commits pendientes (después de aprobación)
- ⏸️ Doc actualizada (pending cambios)