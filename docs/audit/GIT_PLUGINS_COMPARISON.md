# Neogit vs Gitsigns - Comparación de Plugins Git

**Fecha:** 2025-02-18

---

## Neogit (Magit-like in Neovim)

**Purpose:** Interface completa de Git dentro de Neovim (similar a Magit en Emacs)

**Keymaps:**
- `<leader>gs` - Git status
- `<leader>gf` - Fetch
- `<leader>gl` - Pull
- `<leader>gp` - Push
- `<leader>gP` - Push force
- `<leader>gc` - Commit

**Ventajas:**
- Mnemónico keymaps (g* = git)
- Integración con Telescope (búsqueda en commits/files)
- Diffview integration (diff visualización)
- Solo en Neovim (sin cambiar ventana a terminal)

**Uso principal:**
- Commit, pull, push, fetch
- Rebase/merge desde interface Neovim
- Branch management

---

## Gitsigns (Line-by-line git signs)

**Purpose:** Git signs en gutter + hunk management (manejo de cambios línea por línea)

**Keymaps (alto valor - 7 mapeos):**
```lua
]h              - Next hunk (salta a siguiente cambio)
[h              - Prev hunk (salta a anterior cambio)
<leader>ghs    - Stage hunk (stage cambios en línea/hunk)
<leader>ghr    - Reset hunk (deshace cambios en línea/hunk)
<leader>ghp    - Preview hunk (previsualizar cambio)
<leader>ghb    - Blame line (blame del autor del código)
<leader>ghB    - Toggle blame (alternar blame por línea)
```

**Ventajas:**
- Signs en gutter (+/~/- para indicar cambios)
- Blame por línea (muestra commit + autor)
- Hunk management (stage/reset a nivel de línea)
- Número highlighting + línea highlighting visual

**Uso principal:**
- Ver cambios línea por línea (navegación ]h/[h)
- Stage/reset cambios específicos (ghs/ghr)
- Blame rápido por línea (ghb/ghB)
- Diff preview (ghp)

---

## Neogit vs Gitsigns - Diferencias

| Aspecto | Neogit | Gitsigns |
|---------|--------|-----------|
| Ús principal | Git completo (commit/pull/push/rebase) | Hunk management visual |
| UI | Magit-like interface | Signs en gutter |
| Navegación | Telescope integration (commits/files) | ]h/[h hunks navigation |
| Stage | Stage de commits completos | Stage de hunk específico |
| Performance | Good (cmd lazy) | heavy en startup (422ms) |
| Lazy-load | cmd = "Neogit" | event = VeryLazy (optimizado) |

---

## Cuándo usar cada uno

**Usa Neogit cuando:**
- Haces commit/pull/push/remerge
- Quieres ver historial completo de branches
- Prefieres interface Git en Neovim (sin terminal)

**Usa Gitsigns cuando:**
- Revisas cambios línea por línea
- Stage/reset específicos (no todo el archivo)
- Quieres ver blame rápido por línea
- Navegas hunks (]h/[h)

---

## Nota de integración:

**LazyGit removido** (usuario no usaba)
- Neogit hace lo mismo + mnemónico keymaps
- Gitsigns complementa Neogit (hunk level vs commit level)

---

## Dependencias:

**Neogit:**
- diffview (diff visual)
- telescope (búsqueda)
- plenary

**Gitsigns:**
- ninguna (dependencia principal)

---

## Referencia keymaps Git completos:

```lua
# Neogit (keymaps en core/keymaps.lua)
<leader>gs -- Neogit (status)
<leader>gf -- fetch
<leader>gl -- pull
<leader>gp -- push
<leader>gP -- push force
<leader>gc -- commit

# Gitsigns (hunk nivel)
]h           -- next hunk
[h           -- prev hunk
<leader>ghs  -- stage hunk
<leader>ghr  -- reset hunk
<leader>ghp  -- preview hunk
<leader>ghb  -- blame line
<leader>ghB  -- toggle blame

# Git conflict (merge conflicts)
[tx / [cx    -- next/prev conflict
<leader>co  -- choose ours (our)
<leader>ct  -- choose theirs (their)
<leader>cO  -- choose ours (our block)
<leader>cT  -- choose theirs (their block)
<leader>cb  -- choose both (both)
<leader>c0  -- choose none (base)
<leader>cX  -- move to conflict (cursor)
```

---

**Estado:**
- ✅ LazyGit removido (usuario no usaba)
- ✅ Gitsigns simplificado (7 keymaps alto valor)
- ✅ Gitsigns lazy-load VeryLazy (422ms startup ahorro)