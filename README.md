# 🚀 Neovim Configuration

**Modern, modular Neovim setup built on lazy.nvim with LSP, DAP, testing, and Git integrations.**

---

## 📚 Complete Documentation

**Comprehensive documentation available in [`docs/`](docs/)**

### Documentation Index
- 📖 [USER_MANUAL.md](docs/USER_MANUAL.md) — Complete user guide (keymaps, workflows, tasks)
- 🏗️ [ARCHITECTURE.md](docs/ARCHITECTURE.md) — How lua/angel is organized, lazy-loading, triggers
- 💻 [TERMINAL_SUPPORT.md](docs/TERMINAL_SUPPORT.md) — WezTerm vs iTerm support (images, Mermaid)
- 🐛 [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — Common issues & fixes (Ruff, conform, LSP, etc.)
- 📂 [Documentation Index](docs/README.md) — All documentation categories

### Legacy Guides (Archived)
- 📖 [WARP.md](docs/user-guide/WARP.md) — Legacy user guide
- 🗺️ [KEYMAP_REGISTRY.md](docs/user-guide/KEYMAP_REGISTRY.md) — Legacy keymap registry
- 🤝 [CONTRIBUTING.md](docs/development/CONTRIBUTING.md) — Legacy contributing guide

---

## ⚡ Quick Start

```bash
# Install dependencies
brew install lazygit  # Optional but recommended

# Open Neovim
nvim

# Plugins auto-install on first launch
```

---

## ✨ Highlights

**Unique Features:**
- 🪟 **Terminal-aware lazy-loading** — Conditionals loads based on WezTerm vs iTerm (images, Mermaid)
- 🐍 **Ruby-first configuration** — Optimized for Ruby development (vim-rails, vim-bundler, etc.)
- ⚡ **Performance optimized** — ~1700ms startup gain (baseline: 156ms, post-audit: ~260ms)
- 🔧 **Toolchain detection** — Auto-detects Bundler, venv, Cargo (.tool-versions)
- 🤖 **AI assistant (opencode.nvim)** — Integrated LLM for code questions
- 🖼️ **Rich Markdown support** — Mermaid diagrams, images in WezTerm

---

## 🎯 Key Features

- **Language Servers** — Ruby LSP, Lua LSP, TypeScript, Python (auto-detected venv/Bundler)
- **Debug Adapter** — Ruby, Python, JS/TS, Rust breakpoints
- **Testing** — Neotest for RSpec, pytest, jest (multi-language)
- **Git** — Neogit interface, Gitsigns diff view, conflict resolution
- **Completion** — nvim-cmp with LSP, snippets, buffer/path sources
- **Fuzzy Finding** — Telescope (live grep, files, buffers, diagnostics)
- **Treesitter** — Advanced syntax highlighting + text objects
- **Auto-formatting** — conform.nvim (Ruff, stylua, prettier, rubocop)
- **Linting** — nvim-lint (flake8, shellcheck, rubocop)
- **Lazily-loaded** — All plugins loaded on-demand (startup ~260ms)

---

## 💻 Terminal Support

### WezTerm (Recommended)
- ✅ Image preview in Neovim (markdown images, diagrams)
- ✅ Mermaid diagrams rendered directly in terminal
- ✅ Full Unicode/sixel support

### iTerm
- ❌ No image preview (not supported)
- ✅ All other features work normally

**Detection:** Automatic via `vim.env.TERM_PROGRAM` and `vim.env.WEZTERM_PANE`

No configuration needed — works transparently.

---

## 📖 Documentation

### Local Documentation (docs/lua/angel/)
Each folder in `lua/angel/` has corresponding documentation in `docs/lua/angel/`:

- `docs/lua/angel/core/README.md` — Core configuration (options, keymaps)
- `docs/lua/angel/plugins/ui/README.md` — UI plugins (Telescope, Nvim-tree, etc.)
- `docs/lua/angel/plugins/lsp/README.md` — Language servers
- `docs/lua/angel/plugins/tools/README.md` — Tools (opencode, obsidian, etc.)

See [docs/README.md](docs/README.md) for complete documentation index.

---

## 🔗 External Resources
.
├── README.md                    # This file (repository root)
├── docs/                       # 📚 All documentation
│   ├── USER_MANUAL.md          # Complete user guide
│   ├── ARCHITECTURE.md          # System architecture
│   ├── TERMINAL_SUPPORT.md     # Terminal support (WezTerm vs iTerm)
│   ├── TROUBLESHOOTING.md      # Common issues & fixes
│   └── lua/angel/              # 🗂 Local docs mirroring lua/angel structure
│       ├── core/
│       │   ├── README.md
│       │   ├── options.md
│       │   └── keymaps.md
│       ├── plugins/
│       │   ├── README.md
│       │   ├── lsp/README.md
│       │   ├── ui/README.md
│       │   └── ...
│       └── snippets/
├── lua/angel/                  # Main configuration
│   ├── core/                   # Core options, keymaps, autocmds
│   ├── plugins/                # Plugin configs (organized by category)
│   │   ├── completion/         # Completion sources
│   │   ├── dap/                # Debug adapter protocol
│   │   ├── editing/            # Text editing enhancements
│   │   ├── formatting/         # Auto-formatting (conform, linting)
│   │   ├── git/                # Git integrations
│   │   ├── lsp/                # Language servers
│   │   ├── misc/                # Miscellaneous tools
│   │   ├── ruby/                # Ruby/Rails specific tools
│   │   ├── syntax/             # Syntax highlighting
│   │   ├── testing/            # Test execution
│   │   ├── ui/                 # User interface
│   │   └── tools/               # Workflows & assistants
│   ├── snippets/                # Custom snippets
│   └── utils/                  # Utility functions
└── init.lua                    # Entry point
```

---

## 🔗 Links

- **GitHub**: [angel-devstack/nvim](https://github.com/angel-devstack/nvim)
- **Documentation**: [docs/README.md](docs/README.md) (full index)
- **Architecture**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (system organization)
- **Terminal Support**: [docs/TERMINAL_SUPPORT.md](docs/TERMINAL_SUPPORT.md) (WezTerm vs iTerm)

---

## 🚀 Getting Started

1. **Install Neovim 0.11+**
   ```bash
   brew install neovim
   ```

2. **Install optional tools**
   ```bash
   brew install lazygit ripgrep fd
   ```

3. **Open Neovim**
   ```bash
   nvim
   ```

4. **First launch**:
   - Plugins auto-install via lazy.nvim
   - LSP servers auto-install via Mason
   - Language tools (Ruff, rubocop, stylua) auto-detected

5. **Configuration**:
   - Edit `lua/angel/core/options.lua` for core settings
   - Edit `lua/angel/core/keymaps.lua` for keymaps
   - Plugins configured in `lua/angel/plugins/` (by category)

---

## 🤝 Contributing

**See local documentation:**
- [docs/CONTRIBUTING.md](docs/development/CONTRIBUTING.md) — Development workflow
- [docs/AUDIT_REPORT.md](docs/audit/SLICE10-REPORT-FINAL.md) — System optimization

---

**Version:** 1.0 (Post-Audit Optimized)  
**Last Updated:** 2026-02-19  
**Optimization:** ~1700ms startup gain (baseline 156ms → ~260ms)

---

## 📸 Features Demo

- **Terminal detection**: Conditional loads based on WezTerm vs iTerm
- **Performance**: All plugins lazy-loaded on-demand
- **Toolchain**: Auto-detects Bundler, venv, Cargo from project `.tool-versions`
- **Images**: Mermaid + images only in WezTerm (transparent in iTerm)
- **AI**: opencode.nvim assistant integrated (`<C-a>`)
- **LSP**: Ruby LSP with ruby-lsp.nvim, Python with venv detection

**Examples**:
- `docs/examples/markdown/mermaid-example.md` — Mermaid diagram
- `docs/examples/markdown/images-example.md` — Image preview (WezTerm only)

---

## 📦 Dependencies

- Neovim 0.11 or higher
- **Optional but recommended**:
  - LazyGit (git UI)
  - ripgrep (live grep)
  - fd (fuzzy find)
  - Language tools (installed automatically via Mason)
