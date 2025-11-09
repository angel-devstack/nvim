# 📚 Neovim Configuration Documentation

**Complete documentation for this Neovim configuration.**

---

## 📖 Quick Start

**New to this config?** Start here:
1. 📄 [WARP.md](user-guide/WARP.md) — Complete usage guide
2. 🗺️ [KEYMAP_REGISTRY.md](user-guide/KEYMAP_REGISTRY.md) — All keymaps reference
3. 🐛 [TROUBLESHOOTING.md](user-guide/TROUBLESHOOTING.md) — Common issues & fixes

---

## 📂 Documentation Structure

### 👤 User Guide
**For daily usage of the configuration**

- **[WARP.md](user-guide/WARP.md)**  
  Complete guide: commands, architecture, setup, testing, LLM integration, troubleshooting
  
- **[KEYMAP_REGISTRY.md](user-guide/KEYMAP_REGISTRY.md)**  
  Central registry of ALL keymaps organized by prefix (single source of truth)
  
- **[TROUBLESHOOTING.md](user-guide/TROUBLESHOOTING.md)**  
  Comprehensive debugging guide for common issues (LSP, Mason, DAP, etc)

---

### 🛠️ Development
**For contributors and maintainers**

- **[PHASE_TRACKING.md](development/PHASE_TRACKING.md)**  
  6-phase normalization project tracking with granular task details

- **[CONTRIBUTING.md](development/CONTRIBUTING.md)**  
  Complete contributor guide: workflow, standards, conventions, testing
  
- **[PHASE5_API_AUDIT.md](development/PHASE5_API_AUDIT.md)**  
  API compatibility audit report for Neovim 0.10 and 0.11+ support

---

### 🧪 Testing Guides
**Step-by-step testing procedures**

- **[DAP_TESTING_GUIDE.md](testing/DAP_TESTING_GUIDE.md)**  
  Comprehensive guide for testing Debug Adapter Protocol (DAP) functionality
  
- **[PHASE4_TESTING_GUIDE.md](testing/PHASE4_TESTING_GUIDE.md)**  
  Testing guide for Phase 4 directory restructure (12 detailed tests)

---

### 🔬 Investigations
**Low-priority issues documented for future work**

- **[DAP_REPL_INVESTIGATION.md](investigations/DAP_REPL_INVESTIGATION.md)**  
  Investigation notes for DAP REPL evaluation output visibility issue

---

## 🎯 Documentation by Topic

### Getting Started
- Installation & Setup → [WARP.md § Setup](user-guide/WARP.md#dependencies-by-language)
- First Steps → [WARP.md § Common Commands](user-guide/WARP.md#common-commands)
- Configuration Overview → [WARP.md § Architecture](user-guide/WARP.md#high-level-architecture)

### Features
- **LSP** → [WARP.md § LSP Operations](user-guide/WARP.md#lsp-operations)
- **Testing** → [WARP.md § Testing](user-guide/WARP.md#testing-with-neotest) | [DAP_TESTING_GUIDE.md](testing/DAP_TESTING_GUIDE.md)
- **Debugging** → [DAP_TESTING_GUIDE.md](testing/DAP_TESTING_GUIDE.md)
- **Git** → [WARP.md § Git Operations](user-guide/WARP.md#git-operations)
- **Keymaps** → [KEYMAP_REGISTRY.md](user-guide/KEYMAP_REGISTRY.md)

### Troubleshooting
- LSP Issues → [TROUBLESHOOTING.md § LSP](user-guide/TROUBLESHOOTING.md#lsp-not-starting)
- Mason Issues → [TROUBLESHOOTING.md § Mason](user-guide/TROUBLESHOOTING.md#mason-tools-not-working)
- DAP Issues → [TROUBLESHOOTING.md § DAP](user-guide/TROUBLESHOOTING.md#dap-not-working)
- General → [TROUBLESHOOTING.md](user-guide/TROUBLESHOOTING.md)

### Development
- Contributing Guide → [CONTRIBUTING.md](development/CONTRIBUTING.md)
- Project Status → [PHASE_TRACKING.md](development/PHASE_TRACKING.md)
- API Compatibility → [PHASE5_API_AUDIT.md](development/PHASE5_API_AUDIT.md)
- Phase Testing → [testing/](testing/)
- Known Issues → [investigations/](investigations/)

---

## 📁 Repository Structure

```
.
├── README.md                 # Project overview (root)
├── docs/                     # 📚 All documentation (this directory)
│   ├── README.md            # This file (documentation index)
│   ├── user-guide/          # User-facing guides
│   ├── development/         # Developer documentation
│   ├── testing/             # Testing guides
│   └── investigations/      # Issue investigations
├── lua/angel/
│   ├── core/                # Core options, keymaps, autocmds
│   └── plugins/             # Plugin configurations (organized by category)
│       ├── completion/
│       ├── dap/
│       ├── editing/
│       ├── formatting/
│       ├── git/
│       ├── lsp/
│       ├── misc/
│       ├── ruby/
│       ├── syntax/
│       ├── testing/
│       ├── tools/
│       └── ui/
└── init.lua                 # Entry point
```

---

## 🔗 External Resources

- **GitHub**: [angel-devstack/nvim](https://github.com/angel-devstack/nvim)
- **Neovim**: [neovim.io](https://neovim.io)
- **lazy.nvim**: [github.com/folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- **Mason**: [github.com/williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)

---

## 📝 Document Conventions

### Emoji Guide
- 📚 Documentation
- 🎯 Goals/Objectives
- ✅ Completed/Working
- ⚠️ Warning/Caution
- 🐛 Bug/Issue
- 🔧 Configuration
- 🚀 Actions/Commands
- 💡 Tips/Recommendations
- 📖 Reading/Learning

### Linking
- Internal links use relative paths: `[text](../path/to/file.md)`
- Section anchors use lowercase with hyphens: `[text](#section-name)`

---

## 🤝 Contributing to Documentation

When adding or modifying documentation:

1. **User-facing docs** → `user-guide/`
2. **Development docs** → `development/`
3. **Testing guides** → `testing/`
4. **Investigation notes** → `investigations/`

**Always update this index (docs/README.md) when adding new documents.**

---

**Last Updated:** 2025-11-09  
**Configuration Version:** Phase 6 (Final Documentation)
