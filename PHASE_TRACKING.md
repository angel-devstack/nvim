# 📊 Phase Tracking - Nvim Config Normalization

## 🎯 Overall Progress

| Phase | Status | Branch | Commits | Notes |
|-------|--------|--------|---------|-------|
| Phase 1: Immediate Cleanup | 🔄 In Progress | `phase-1/immediate-cleanup` | 0/5 | Starting |
| Phase 2: Keymap Registry | ⏳ Pending | `phase-2/keymap-registry` | 0/? | Waiting |
| Phase 3: DAP Consolidation | ⏳ Pending | `phase-3/dap-consolidation` | 0/? | Waiting |
| Phase 4: Directory Restructure | ⏳ Pending | `phase-4/directory-restructure` | 0/? | Waiting |
| Phase 5: API Updates | ⏳ Pending | `phase-5/api-updates` | 0/? | Waiting |
| Phase 6: Final Documentation | ⏳ Pending | `phase-6/final-documentation` | 0/? | Waiting |

**Legend:** ✅ Done | 🔄 In Progress | ⏳ Pending | ❌ Blocked

---

## 📝 PHASE 1: Immediate Cleanup

**Branch:** `phase-1/immediate-cleanup`  
**Goal:** Remove dead code, fix bugs, consolidate documentation without breaking anything

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 1.1 | Remove obsolete `lua/angel/lsp.lua` | ⏳ Pending | - | `lua/angel/lsp.lua` | ⬜ |
| 1.2 | Remove empty `lua/angel/plugins/nvim-dap.lua` | ⏳ Pending | - | `lua/angel/plugins/nvim-dap.lua` | ⬜ |
| 1.3 | Clean commented code in `plugins/init.lua` | ⏳ Pending | - | `lua/angel/plugins/init.lua` | ⬜ |
| 1.4 | Fix typo in `gen.lua` keymap | ⏳ Pending | - | `lua/angel/plugins/gen.lua` | ⬜ |
| 1.5 | Fix missing function in `nvim-cmp.lua` | ⏳ Pending | - | `lua/angel/plugins/nvim-cmp.lua` | ⬜ |
| 1.6 | Consolidate README files into WARP.md | ⏳ Pending | - | Multiple READMEs, WARP.md | ⬜ |
| 1.7 | Remove consolidated README files | ⏳ Pending | - | README-*.md | ⬜ |
| 1.8 | Update main README.md | ⏳ Pending | - | README.md | ⬜ |

### Validation Checklist
- [ ] `:Lazy sync` runs without errors
- [ ] `:checkhealth` passes
- [ ] `:checkhealth mason` confirms tools
- [ ] Open `.rb` file → LSP works
- [ ] `<leader>tt` in test → executes
- [ ] No error messages on startup
- [ ] All keymaps respond correctly

---

## 📝 PHASE 2: Keymap Registry

**Branch:** `phase-2/keymap-registry`  
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 2.1 | Create KEYMAP_REGISTRY.md | ⏳ Pending | - | KEYMAP_REGISTRY.md | ⬜ |
| 2.2 | Update core/keymaps.lua (tabs → wt*) | ⏳ Pending | - | lua/angel/core/keymaps.lua | ⬜ |
| 2.3 | Update tabular.lua (ta* → a*) | ⏳ Pending | - | lua/angel/plugins/tabular.lua | ⬜ |
| 2.4 | Update vim-maximizer.lua (sm → wsm) | ⏳ Pending | - | lua/angel/plugins/vim-maximizer.lua | ⬜ |
| 2.5 | Review opencode.lua keymaps | ⏳ Pending | - | lua/angel/plugins/opencode.lua | ⬜ |
| 2.6 | Update which-key.lua groups | ⏳ Pending | - | lua/angel/plugins/which-key.lua | ⬜ |

---

## 📝 PHASE 3: DAP Consolidation

**Branch:** `phase-3/dap-consolidation`  
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 3.1 | Remove nvim-dap-ui.lua | ⏳ Pending | - | lua/angel/plugins/nvim-dap-ui.lua | ⬜ |
| 3.2 | Remove nvim-dap-virtual-text.lua | ⏳ Pending | - | lua/angel/plugins/nvim-dap-virtual-text.lua | ⬜ |
| 3.3 | Simplify dap.lua (remove manual loading) | ⏳ Pending | - | lua/angel/plugins/dap.lua | ⬜ |
| 3.4 | Review nvim-ruby-debugger.lua | ⏳ Pending | - | lua/angel/plugins/nvim-ruby-debugger.lua | ⬜ |

---

## 📝 PHASE 4: Directory Restructure

**Branch:** `phase-4/directory-restructure`  
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 4.1 | Create new directory structure | ⏳ Pending | - | Multiple dirs | ⬜ |
| 4.2 | Move completion plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.3 | Move UI plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.4 | Move editing plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.5 | Move syntax plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.6 | Move formatting plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.7 | Move ruby plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.8 | Move tools plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.9 | Move misc plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.10 | Move testing plugins | ⏳ Pending | - | Multiple files | ⬜ |
| 4.11 | Create init.lua for each category | ⏳ Pending | - | Multiple init.lua | ⬜ |
| 4.12 | Update main plugins/init.lua | ⏳ Pending | - | lua/angel/plugins/init.lua | ⬜ |

---

## 📝 PHASE 5: API Updates

**Branch:** `phase-5/api-updates`  
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 5.1 | Migrate which-key.lua to v3 API | ⏳ Pending | - | lua/angel/plugins/which-key.lua | ⬜ |
| 5.2 | Review conform.nvim API | ⏳ Pending | - | lua/angel/plugins/conform.lua | ⬜ |
| 5.3 | Verify all APIs are current | ⏳ Pending | - | Various | ⬜ |

---

## 📝 PHASE 6: Final Documentation

**Branch:** `phase-6/final-documentation`  
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 6.1 | Update WARP.md with new structure | ⏳ Pending | - | WARP.md | ⬜ |
| 6.2 | Create CONTRIBUTING.md | ⏳ Pending | - | CONTRIBUTING.md | ⬜ |
| 6.3 | Create .warpindexingignore | ⏳ Pending | - | .warpindexingignore | ⬜ |
| 6.4 | Final README.md polish | ⏳ Pending | - | README.md | ⬜ |

---

## 📌 Notes & Decisions

### Phase 1 Decisions
- [To be filled as decisions are made]

### Phase 2 Decisions
- [To be filled as decisions are made]

### Phase 3 Decisions
- [To be filled as decisions are made]

### Phase 4 Decisions
- [To be filled as decisions are made]

### Phase 5 Decisions
- [To be filled as decisions are made]

### Phase 6 Decisions
- [To be filled as decisions are made]

---

## 🔍 Issues Found During Work

| Issue | Phase | Description | Resolution | Status |
|-------|-------|-------------|------------|--------|
| lua-language-server not executable | Phase 1 Testing | Mason shows lua-language-server installed but :LspInfo shows "not executable" warning. LSP config is correct, issue is pre-existing PATH problem. | Document in TROUBLESHOOTING.md. Server works but needs Mason bin path in shell PATH or symlink. | 📝 Documented |

---

## ✅ Merge Status

| Phase | Merged to main | Date | Merge Commit | Notes |
|-------|----------------|------|--------------|-------|
| Phase 1 | ⏳ Pending | - | - | - |
| Phase 2 | ⏳ Pending | - | - | - |
| Phase 3 | ⏳ Pending | - | - | - |
| Phase 4 | ⏳ Pending | - | - | - |
| Phase 5 | ⏳ Pending | - | - | - |
| Phase 6 | ⏳ Pending | - | - | - |

---

**Last Updated:** 2025-11-09  
**Current Phase:** Phase 1  
**Next Action:** Create `phase-1/immediate-cleanup` branch and start first commit
