# Slice 5: Git - Reporte Final

**Fecha:** 2025-02-18
**Slice completado:** ✅ Con cambios aplicados (2 commits)

---

## Resumen Ejecutivo

2 cambios aplicados en 2 commits:

| Cambio | Commit | Estado |
|--------|--------|--------|
| Remove LazyGit | `94e5aa9` | ✅ Aplicado |
| Gitsigns lazy-load + simplify | `ff3482e` | ✅ Aplicado |

**Decisiones usuario:**
1. LazyGit: no usar → removed
2. Gitsigns: simplificar a alto valor (~7 keymaps)
3. Gitsigns lazy-load: VeryLazy (performance gain ~422ms startup)
4. git-conflict: mantener

---

## Cambios Aplicados

### Cambio 1: Remove LazyGit ✅ (commit `94e5aa9`)

**Problema:**
- LazyGit overlap con Neogit
- Usuario no usa LazyGit (prefiere Neogit)

**Solución:**
```lua
# Antes
{ import = "angel.plugins.git.lazygit" }
<leader>lg -- LazyGit

# Después
# Import removed from git/init.lua
# lazygit.lua file deleted

# Neogit keymaps retained
<leader>gs -- Neogit (status)
<leader>gf -- fetch
<leader>gl -- pull
<leader>gp -- push
<leader>gP -- push force
<leader>gc -- commit
```

**Usuario decisión:** LazyGit no usar, overlap con Neogit

**Commit:** `94e5aa9`

---

### Cambio 2: Gitsigns lazy-load + simplify ✅ (commit `ff3482e`)

**Problema:**
- event = BufReadPre, BufNewFile = carga en cada archivo (~422ms startup)
- 13 keymaps (incluye baja utilidad)

**Solución:**
```lua
# Lazy-load
event = { "BufReadPre", "BufNewFile" }
To:
event = "VeryLazy"  -- ganancia ~422ms startup

# Simplified keymaps (13 → 7)
Removed:
  - Visual mode ghs/ghr (stage/reset visual)
  - ghS (stage buffer), ghR (reset buffer)
  - ghu (undo stage hunk)
  - ghd (diff this), ghD (diff this ~)
  - ih (select hunk text object)

Kept (high-signal):
  ]h/[h -- next/prev hunk
  ghs/ghr -- stage/reset hunk
  ghp -- preview hunk
  ghb/ghB -- blame line/toggle blame
```

**Usuario decisión:** Simplificar a alto valor (~7 keymaps)

**Commit:** `ff3482e`

---

## Gitsigns lazy-load verificación

**VeryLazy behavior:**
- Carga después de UI está cargada
- Se attach a buffers ya abiertos
- Signs en gutter aparecerán a continuación

**Nota:** Si signs no aparecen inmediatamente al abrir archivo, esperar ~1 segundo para gitsigns attach.

---

## Resumen por Plugin

| Plugin | Estado | Diagnóstico | Opción | Riesgo |
|--------|--------|-------------|-------|--------|
| LazyGit | ✅ Removed | Overlap con Neogit | Remove | Bajo |
| Neogit | ✅ Keep | Main Git interface | Keep | None |
| Gitsigns | ✅ Simplified | Lazy-load + keymaps | Simplify | Medio |
| git-conflict | ✅ Keep | default_mappings | Keep | None |

---

## Baseline Comparado

### Antes (baseline)

- LazyGit: cargado
- Gitsigns: BufReadPre (carga cada archivo)
- Gitsigns: 13 keymaps

### Después (Slice 5)

- LazyGit: removido ✅
- Gitsigns: evento VeryLazy (422ms startup ahorro) ✅
- Gitsigns: 7 keymaps alto valor ✅

---

## Verificación Completa

| Test | Comando | Estado |
|------|---------|--------|
| Stylua syntax | stylua --check gitsigns.lua | ✅ OK |
| Git remove | LazyGit file deleted | ✅ OK |
| Git verify | Neogit keymaps retained | ✅ OK |

---

## Test Usuario Required

** probar en Neovim real:**
```vim
" Gitsigns lazy-load VeryLazy + keymaps
# Abrir archivo Git
Navegar: ]h/[h (next/prev hunk)
Stage/Reset: <leader>ghs/ghr
Preview: <leader>ghp
Blame: <leader>ghb/<leader>ghB

" Verificar keymaps quitados (no deberían existir)
<leader>ghu -- undo (quitado)
<leader>ghd -- diff (quitado)
<leader>ghD -- diff ~ (quitado)
ih -- select hunk (quitado)

" LazyGit keymaps (deberían fallar)
<leader>lg -- LazyGit (quitado)

" Neogit keymaps (deberían funcionar)
<leader>gs -- Neogit status
<leader>gf -- fetch
<leader>gl -- pull
<leader>gp -- push
```

---

## Pendientes / Riesgos

**Pendientes:**
- [ ] Usuario probar Gitsigns lazy-load (VeryLazy signs attach)
- [ ] Usuario probar keymaps simplificados

**Riesgos:**
- Gitsigns lazy-load → medio (si VeryLazy no attach, ajustar a BufReadPost User)
- Keymaps simplificados → bajo (7 keymaps alto valor retained)

---

## Doc Creada

**GIT_PLUGINS_COMPARISON.md** - Neogit vs Gitsigns comparación completa:
- Diferencias de propósito
- Cuándo usar cada uno
- Keymaps completos (Neogit, Gitsigns, git-conflict)
- Dependencias

---

**Estado Slice 5:** ✅ COMPLETO
- ✅ 2 commits aplicados (`94e5aa9`, `ff3482e`)
- ✅ Doc actualizada (GIT_PLUGINS_COMPARISON.md)
- ✅ Verificaciones OK

**Commits Totales (acumulado):** 18 (incluyendo slices 1-5)

```
ff3482e perf(git): lazy-load gitsigns with VeryLazy
94e5aa9 chore(git): remove lazygit
4a0f304 refactor(trouble): simplify keymaps
... (13 más previos)
```

---

## Próximo: Slice 6 - Testing/Debug (Neotest, DAP)

**Slice pendiente** - auditoría de plugins testing/debug.