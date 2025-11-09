# 🚀 Neovim Configuration

**Modern, modular Neovim setup built on lazy.nvim with LSP, DAP, testing, and Git integrations.**

---

## 📚 Documentation

**Complete documentation available in [`docs/`](docs/)**

### Quick Links
- 📖 [Complete User Guide](docs/user-guide/WARP.md) — Setup, commands, architecture
- 🗺️ [Keymap Registry](docs/user-guide/KEYMAP_REGISTRY.md) — All keymaps reference
- 🐛 [Troubleshooting](docs/user-guide/TROUBLESHOOTING.md) — Common issues & fixes
- 🤝 [Contributing Guide](docs/development/CONTRIBUTING.md) — How to contribute
- 📂 [Documentation Index](docs/README.md) — Full docs catalog

---

## ⚡ Quick Start

```bash
# Install LazyGit (optional but recommended)
brew install jesseduffield/lazygit/lazygit

# Open Neovim
nvim

# Plugins will auto-install on first launch
```

---

## 🎯 Key Features

- **LSP** — Language servers via Mason (ruby_lsp, lua_ls, ts_server, etc)
- **DAP** — Debug adapters for Ruby, Python, JS/TS, Rust
- **Testing** — Neotest integration with multi-language support
- **Git** — LazyGit, Neogit, Gitsigns
- **Completion** — nvim-cmp with LSP, snippets, buffer sources
- **Fuzzy Finding** — Telescope with live grep
- **Treesitter** — Advanced syntax highlighting and text objects
- **Auto-formatting** — conform.nvim with language-specific formatters

---

## 📁 Structure

```
.
├── docs/                    # 📚 All documentation
│   ├── user-guide/         # Daily usage guides
│   ├── development/        # Development docs
│   ├── testing/            # Testing guides
│   └── investigations/     # Issue investigations
├── lua/angel/
│   ├── core/               # Core options, keymaps, autocmds
│   └── plugins/            # Organized by category
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
└── init.lua                # Entry point
```

---

## 🔗 Links

- **GitHub**: [angel-devstack/nvim](https://github.com/angel-devstack/nvim)
- **Documentation**: [docs/README.md](docs/README.md)
- **Changelog**: See commit history

---

**Version:** Phase 6 (Final Documentation)  
**Last Updated:** 2025-11-09

---

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](docs/development/CONTRIBUTING.md) for:
- Development workflow
- Coding standards
- Commit conventions
- Testing procedures
- Pull request process
