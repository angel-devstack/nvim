# 🗺️ Keymap Registry

**Central registry of ALL keymaps in this Neovim configuration.**

This document serves as the single source of truth for keymap assignments to prevent conflicts and maintain consistency.

**Leader Key:** `<Space>`

---

## 📋 Quick Reference

| Prefix | Category | Examples |
|--------|----------|----------|
| `<leader>f*` | Find/Files | ff, fr, fs, fc, ft |
| `<leader>w*` | Window/Workspace | wh, wj, wk, wl, wsv, wsh, wto, wtx |
| `<leader>e*` | Explorer | ee, ef, ec, er |
| `<leader>g*` | Git | gs, gf, gl, gp, gc, g1, g2 |
| `<leader>gh*` | Git Hunks | ghs, ghr, ghS, ghp, ghb |
| `<leader>t*` | Testing | tt, tr, ta, tS, to, ts |
| `<leader>c*` | Code/Format | ca, cf, rn |
| `<leader>d*` | Debug (DAP) | db, dr, dl |
| `<leader>a*` | Align (Tabular) | a=, a:, a, |
| `<leader>r*` | Rest/HTTP | rr, rp, rl |
| `<leader>s*` | Special/Misc | s, ss, S, so, sm |

---

## 🌐 GLOBAL KEYMAPS

### Insert Mode
| Keymap | Action | File | Plugin |
|--------|--------|------|--------|
| `jk` | Exit insert mode | core/keymaps.lua | - |
| `<C-k>` | Select previous completion | nvim-cmp.lua | nvim-cmp |
| `<C-j>` | Select next completion | nvim-cmp.lua | nvim-cmp |
| `<Tab>` | Next item / expand snippet | nvim-cmp.lua | nvim-cmp |
| `<S-Tab>` | Previous item / jump back | nvim-cmp.lua | nvim-cmp |
| `<C-Space>` | Show completion | nvim-cmp.lua | nvim-cmp |
| `<C-e>` | Abort completion | nvim-cmp.lua | nvim-cmp |
| `<CR>` | Confirm completion | nvim-cmp.lua | nvim-cmp |

### Normal Mode (No Leader)
| Keymap | Action | File | Plugin |
|--------|--------|------|--------|
| `<C-s>` | Save file | core/keymaps.lua | - |
| `<C-q>` | Quit all | core/keymaps.lua | - |
| `K` | Hover documentation (LSP) | lsp/lspconfig.lua | nvim-lspconfig |
| `gd` | Go to definition | lsp/lspconfig.lua | telescope + LSP |
| `gD` | Go to declaration | lsp/lspconfig.lua | nvim-lspconfig |
| `gi` | Go to implementation | lsp/lspconfig.lua | telescope + LSP |
| `gr` | Show references | lsp/lspconfig.lua | telescope + LSP |
| `[d` | Previous diagnostic | lsp/lspconfig.lua | nvim-lspconfig |
| `]d` | Next diagnostic | lsp/lspconfig.lua | nvim-lspconfig |
| `[h` | Previous git hunk | git/gitsigns.lua | gitsigns |
| `]h` | Next git hunk | git/gitsigns.lua | gitsigns |
| `gS` | Split arguments | splitjoin.lua | splitjoin.vim |
| `gJ` | Join arguments | splitjoin.lua | splitjoin.vim |
| `s` | Substitute with motion | substitute.lua | substitute.nvim |
| `ss` | Substitute line | substitute.lua | substitute.nvim |
| `S` | Substitute to EOL | substitute.lua | substitute.nvim |
| `cu` | Copy absolute file URL to clipboard | core/utils/path | custom util |


### Function Keys (DAP)
| Keymap | Action | File | Plugin |
|--------|--------|------|--------|
| `<F5>` | DAP continue | dap.lua | nvim-dap |
| `<F10>` | DAP step over | dap.lua | nvim-dap |
| `<F11>` | DAP step into | dap.lua | nvim-dap |
| `<F12>` | DAP step out | dap.lua | nvim-dap |

---

## 📁 LEADER PREFIX: `<leader>f*` - FIND/FILES

**Managed by:** Telescope

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>ff` | Find files | Fuzzy find files in project | telescope.lua |
| `<leader>fr` | Recent files | Show recent files | telescope.lua |
| `<leader>fs` | Find string (live grep) | Live grep in project | telescope.lua |
| `<leader>fc` | Find word under cursor | Grep word under cursor | telescope.lua |
| `<leader>ft` | Find TODOs | Search TODO/FIXME/NOTE comments | telescope.lua |
| `<leader>fg` | Find grep (alternative) | Live grep alternative | core/keymaps.lua |

---

## 🪟 LEADER PREFIX: `<leader>w*` - WINDOW/WORKSPACE

**Category:** Window management, splits, tabs, sessions

### Window Navigation
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>h` | Move to left split | Navigate left | core/keymaps.lua |
| `<leader>j` | Move to bottom split | Navigate down | core/keymaps.lua |
| `<leader>k` | Move to top split | Navigate up | core/keymaps.lua |
| `<leader>l` | Move to right split | Navigate right | core/keymaps.lua |

### Window Splits
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>wsv` | Split vertical | Split window vertically | core/keymaps.lua |
| `<leader>wsh` | Split horizontal | Split window horizontally | core/keymaps.lua |
| `<leader>wse` | Equal splits | Make splits equal size | core/keymaps.lua |
| `<leader>wsx` | Close split | Close current split | core/keymaps.lua |
| `<leader>wsm` | Maximize split | Toggle maximize current split | vim-maximizer.lua |

### Tabs (Changed from `<leader>t*` to avoid conflict with Testing)
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>wto` | Open new tab | Create new tab | core/keymaps.lua |
| `<leader>wtx` | Close current tab | Close tab | core/keymaps.lua |
| `<leader>wtn` | Next tab | Go to next tab | core/keymaps.lua |
| `<leader>wtp` | Previous tab | Go to previous tab | core/keymaps.lua |
| `<leader>wtf` | Buffer to new tab | Open current buffer in new tab | core/keymaps.lua |

### Sessions
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>wr` | Restore session | Restore session for current dir | auto-session.lua |
| `<leader>ws` | Save session | Save current session | auto-session.lua |
| `<leader>wd` | Delete session | Delete session | auto-session.lua |
| `<leader>wl` | List sessions | Telescope session list | auto-session.lua |

---

## 📂 LEADER PREFIX: `<leader>e*` - EXPLORER

**Managed by:** nvim-tree

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>ee` | Toggle explorer | Open/close file tree | nvim-tree.lua |
| `<leader>ef` | Focus current file | Reveal file in tree | nvim-tree.lua |
| `<leader>ec` | Collapse tree | Collapse all folders | nvim-tree.lua |
| `<leader>er` | Refresh explorer | Refresh file tree | nvim-tree.lua |

---

## 🌿 LEADER PREFIX: `<leader>g*` - GIT

**Category:** Git operations, integrations

### Git Tools
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>gs` | Git status | Open Neogit status | neogit.lua |
| `<leader>gf` | Git fetch | Fetch from remote | neogit.lua |
| `<leader>gl` | Git pull | Pull from remote | neogit.lua |
| `<leader>gp` | Git push | Push to remote | neogit.lua |
| `<leader>gP` | Git push force | Force push to remote | neogit.lua |
| `<leader>gc` | Git commit | Open commit dialog | neogit.lua |
| `<leader>lg` | LazyGit | Open LazyGit TUI | lazygit.lua |

### Git Hunks (`<leader>gh*`)
**Managed by:** Gitsigns

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>ghs` | Stage hunk | Stage hunk under cursor | gitsigns.lua |
| `<leader>ghr` | Reset hunk | Reset hunk under cursor | gitsigns.lua |
| `<leader>ghS` | Stage buffer | Stage entire buffer | gitsigns.lua |
| `<leader>ghR` | Reset buffer | Reset entire buffer | gitsigns.lua |
| `<leader>ghu` | Undo stage hunk | Undo last stage | gitsigns.lua |
| `<leader>ghp` | Preview hunk | Preview hunk diff | gitsigns.lua |
| `<leader>ghb` | Blame line | Show blame for line | gitsigns.lua |
| `<leader>ghB` | Toggle line blame | Toggle inline blame | gitsigns.lua |
| `<leader>ghd` | Diff this | Show diff | gitsigns.lua |
| `<leader>ghD` | Diff this ~ | Show diff against ~ | gitsigns.lua |

### Gen.nvim (LLM)
| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>g1` | Generate | Generate via LLM | gen.lua |
| `<leader>g2` | Gen chat | Open Gen chat session | gen.lua |

---

## 🧪 LEADER PREFIX: `<leader>t*` - TESTING

**Managed by:** Neotest

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>tt` | Run test file | Execute current test file | test-neotest.lua |
| `<leader>tr` | Run nearest test | Execute test under cursor | test-neotest.lua |
| `<leader>ta` | Run all tests | Execute all tests in project | test-neotest.lua |
| `<leader>tS` | Debug test | Debug nearest test with DAP | test-neotest.lua |
| `<leader>to` | Test output | Show test output | test-neotest.lua |
| `<leader>ts` | Test summary | Toggle test summary panel | test-neotest.lua |

---

## 💻 LEADER PREFIX: `<leader>c*` - CODE/FORMAT

**Category:** Code actions, formatting, LSP operations

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>ca` | Code action | Show available code actions | lsp/lspconfig.lua |
| `<leader>cf` | Format | Format current file | conform.lua |
| `<leader>rn` | Rename symbol | Rename symbol under cursor | lsp/lspconfig.lua |
| `<leader>ds` | Document symbols | Show document symbols | lsp/lspconfig.lua |
| `<leader>D` | Diagnostics | Show buffer diagnostics | lsp/lspconfig.lua |
| `<leader>rs` | Restart LSP | Restart LSP server | lsp/lspconfig.lua |

---

## 🐛 LEADER PREFIX: `<leader>d*` - DEBUG (DAP)

**Managed by:** nvim-dap

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>db` | Toggle breakpoint | Add/remove breakpoint | dap.lua |
| `<leader>dr` | Open REPL | Open debug REPL | dap.lua |
| `<leader>dl` | Run last | Run last DAP configuration | dap.lua |

**Note:** Also see Function Keys (F5, F10, F11, F12) for DAP control

---

## 📐 LEADER PREFIX: `<leader>a*` - ALIGN

**Managed by:** Tabular
**Changed from:** `<leader>ta*` to avoid conflict with test-all

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>a=` | Align by = | Align selection by = | tabular.lua |
| `<leader>a:` | Align by : | Align selection by : | tabular.lua |
| `<leader>a,` | Align by , | Align selection by , | tabular.lua |

---

## 🌐 LEADER PREFIX: `<leader>r*` - REST/HTTP

**Managed by:** rest.nvim

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>rr` | Run request | Execute HTTP request under cursor | rest.lua |
| `<leader>rp` | Preview request | Preview curl command | rest.lua |
| `<leader>rl` | Re-run last | Re-run last HTTP request | rest.lua |

---

## ✨ LEADER PREFIX: `<leader>s*` - SPECIAL/MISC

**Category:** Substitute, sort, and other utilities

| Keymap | Action | Description | File |
|--------|--------|-------------|------|
| `<leader>so` | Sort selection | Sort selected lines | sort.lua |
| `<leader>nh` | No highlight | Clear search highlights | core/keymaps.lua |
| `<leader>+` | Increment number | Increment number under cursor | core/keymaps.lua |
| `<leader>-` | Decrement number | Decrement number under cursor | core/keymaps.lua |

**Note:** `s`, `ss`, `S` (substitute) don't use leader and are documented in Global section

---

## 🚫 CONFLICTS RESOLVED

### Historical Conflicts (Fixed in Phase 2)

| Keymap | Old Usage | New Usage | Resolution |
|--------|-----------|-----------|------------|
| `<leader>to` | Tabs: open tab | Testing: test output | Tabs moved to `<leader>wto` |
| `<leader>tx` | Tabs: close tab | - | Tabs moved to `<leader>wtx` |
| `<leader>tn` | Tabs: next tab | - | Tabs moved to `<leader>wtn` |
| `<leader>tp` | Tabs: prev tab | - | Tabs moved to `<leader>wtp` |
| `<leader>tf` | Tabs: buffer to tab | - | Tabs moved to `<leader>wtf` |
| `<leader>ta*` | Tabular: align | Testing: all tests | Tabular moved to `<leader>a*` |
| `<leader>sm` | Special: maximize | - | Moved to `<leader>wsm` (window maximize) |

---

## 📌 GUIDELINES FOR ADDING NEW KEYMAPS

### 1. Check This Registry First
Always consult this document before adding a new keymap to ensure no conflicts.

### 2. Use Appropriate Prefix
Choose the prefix that matches the functionality:
- Files/Search → `<leader>f*`
- Windows/Workspace → `<leader>w*`
- Explorer → `<leader>e*`
- Git → `<leader>g*` or `<leader>gh*` for hunks
- Testing → `<leader>t*`
- Code/Format → `<leader>c*`
- Debug → `<leader>d*`
- Align → `<leader>a*`
- HTTP → `<leader>r*`
- Misc → `<leader>s*` or other available prefix

### 3. Document Immediately
Update this registry when adding a new keymap with:
- The keymap itself
- Clear description
- Source file
- Plugin name (if applicable)

### 4. Avoid Ambiguous Prefixes
Don't create new prefixes that could conflict with existing ones.
Example: Don't use `<leader>ta` for "tabs" when `<leader>t*` is already testing.

### 5. Test for Conflicts
After adding a keymap, test in Neovim:
```vim
:verbose map <leader>XX
```
Should show only ONE mapping.

---

## 🔍 HOW TO SEARCH FOR CONFLICTS

### Find all leader keymaps in config:
```bash
grep -r "keymap.set.*<leader>" lua/angel/
```

### Check if keymap is already used:
```vim
:verbose map <leader>ta
```

### See all which-key registered groups:
```vim
:WhichKey <leader>
```

---

**Last Updated:** 2025-11-09
**Maintained by:** Phase 2 - Keymap Registry
**Related:** See `WARP.md` for usage guide, `PHASE_TRACKING.md` for project progress
