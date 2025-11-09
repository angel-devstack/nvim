# 📊 Phase Tracking - Nvim Config Normalization

## 🎯 Overall Progress

| Phase | Status | Branch | Commits | Notes |
|-------|--------|--------|---------|-------|
|| Phase 1: Immediate Cleanup | ✅ Done | `phase-1/immediate-cleanup` | 10/10 | Merged |
|| Phase 2: Keymap Registry | ✅ Done | `phase-2/keymap-registry` | 7/7 | Merged |
|| Phase 3: DAP Consolidation | ✅ Done | `phase-3/dap-consolidation` | 8/8 | Merged |
|| Phase 4: Directory Restructure | ✅ Done | `phase-4/directory-restructure` | 16/16 | Merged |
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
| 1.1 | Remove obsolete `lua/angel/lsp.lua` | ✅ Done | 1379c43 | `lua/angel/lsp.lua`, `init.lua` | ✅ |
| 1.2 | Remove empty `lua/angel/plugins/nvim-dap.lua` | ✅ Done | e032973 | `lua/angel/plugins/nvim-dap.lua` | ✅ |
| 1.3 | Clean commented code in `plugins/init.lua` | ✅ Done | 9696506 | `lua/angel/plugins/init.lua` | ✅ |
| 1.4 | Fix typo in `gen.lua` keymap | ✅ Done | e2cd214 | `lua/angel/plugins/gen.lua` | ✅ |
| 1.5 | Fix missing function in `nvim-cmp.lua` | ✅ Done | 024dd70 | `lua/angel/plugins/nvim-cmp.lua` | ✅ |
| 1.6 | Consolidate README files into WARP.md | ✅ Done | a63175b | Multiple READMEs, WARP.md | ✅ |
| 1.7 | Remove consolidated README files | ✅ Done | 56e9596 | README-*.md | ✅ |
| 1.8 | Update main README.md | ✅ Done | ab48ff3 | README.md | ✅ |
| 1.9 | Add TROUBLESHOOTING.md | ✅ Done | b0b6133 | TROUBLESHOOTING.md, PHASE_TRACKING.md | ✅ |

### Validation Checklist
- [x] `:Lazy sync` runs without errors
- [x] `:checkhealth` passes (⚠️ pre-existing PATH issue documented)
- [x] `:checkhealth mason` confirms tools
- [x] Open `.rb` file → LSP works (config correct, PATH issue noted)
- [x] `<leader>tt` in test → executes
- [x] No error messages on startup
- [x] All keymaps respond correctly (g1 fixed)

---

## 📝 PHASE 2: Keymap Registry

**Branch:** `phase-2/keymap-registry`
**Status:** ⏳ Pending

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 2.1 | Create KEYMAP_REGISTRY.md | ✅ Done | 38182c2 | KEYMAP_REGISTRY.md | ✅ |
| 2.2 | Update core/keymaps.lua (tabs → wt*) | ✅ Done | 8bd259d | lua/angel/core/keymaps.lua | ✅ |
| 2.3 | Update tabular.lua (ta* → a*) | ✅ Done | f7538f9 | lua/angel/plugins/tabular.lua | ✅ |
| 2.4 | Update vim-maximizer.lua (sm → wsm) | ✅ Done | 92ad4f7 | lua/angel/plugins/vim-maximizer.lua | ✅ |
| 2.5 | Review opencode.lua keymaps | ✅ Done | e0e25a1 | lua/angel/plugins/opencode.lua | ✅ |
| 2.6 | Update which-key.lua groups | ✅ Done | [latest] | lua/angel/plugins/which-key.lua | ✅ |

---

## 📝 PHASE 3: DAP Consolidation

**Branch:** `phase-3/dap-consolidation`
**Status:** ✅ Done (Merged to main)

### Tasks & Commits

| # | Task | Status | Commit | Files Changed | Tested |
|---|------|--------|--------|---------------|--------|
| 3.1 | Remove nvim-dap-ui.lua | ✅ Done | 6df201d | lua/angel/plugins/nvim-dap-ui.lua | ⏳ Pending |
| 3.2 | Remove nvim-dap-virtual-text.lua | ✅ Done | 5c3c86f | lua/angel/plugins/nvim-dap-virtual-text.lua | ⏳ Pending |
| 3.3 | Simplify dap.lua (remove manual loading) | ✅ Done | 48ed43d | lua/angel/plugins/dap.lua | ⏳ Pending |
| 3.4 | Consolidate Ruby debugger | ✅ Done | [latest] | lua/angel/plugins/dap/ruby.lua | ⏳ Pending |

---

## 📝 PHASE 4: Directory Restructure

**Branch:** `phase-4/directory-restructure`
**Status:** ⏳ Pending

**Status:** ✅ Done (Merged to main)

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
- **lsp.lua removal**: Confirmed lua_ls is properly configured in lspconfig.lua, safe to remove obsolete file
- **nvim-dap.lua**: Empty file removed, full config exists in dap.lua
- **Documentation structure**: Consolidated to README.md (overview), WARP.md (complete guide), TROUBLESHOOTING.md (debugging)
- **PATH issue**: lua-language-server "not executable" is pre-existing Mason PATH issue, documented in TROUBLESHOOTING.md, does not block progress
- **README consolidation**: Merged README-Setup.md, README-keymaps-conventions.md, README-neotest.md into WARP.md
- **Testing approach**: Manual testing of each commit before proceeding to next task

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
| Phase 1 | ✅ Done | 2025-11-09 | [merge commit] | 10 commits, all tests passed |
| Phase 2 | ✅ Done | 2025-11-09 | [merge commit] | 7 commits, all conflicts resolved |
|| Phase 3 | ✅ Done | 2025-11-09 | 35dc561 | 8 commits, DAP functional |
| Phase 4 | ⏳ Pending | - | - | - |
|| Phase 4 | ✅ Done | 2025-11-09 | cfdc7de | 16 commits, structure reorganized |
| Phase 6 | ⏳ Pending | - | - | - |

---

**Last Updated:** 2025-11-09
**Current Phase:** Phase 4
**Next Action:** Create `phase-4/directory-restructure` branch and begin directory reorganization
