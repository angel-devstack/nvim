# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Common commands

### Plugin Management (lazy.nvim)
- `:Lazy` — open lazy.nvim UI to manage plugins
- `:Lazy sync` — install missing plugins, update installed plugins, and clean removed plugins
- `:Lazy update` — update all plugins to latest versions
- `:Lazy clean` — remove unused plugins
- `:Lazy check` — check for plugin updates

### LSP Management (Mason)
- `:Mason` — open Mason UI to manage LSP servers, formatters, and linters
- `:MasonUpdate` — update Mason registry
- `:checkhealth mason` — verify Mason installation and installed tools

### Testing
- `<leader>tt` — run test file (detects language: RSpec for Ruby, pytest for Python, Jest for JS/TS, cargo test for Rust)
- `<leader>tr` — run nearest test under cursor
- `<leader>ta` — run all tests in project
- `<leader>tS` — debug nearest test via DAP
- `<leader>to` — show test output
- `<leader>ts` — toggle test summary panel

### Debugging (DAP)
- `<F5>` — start/continue debugging
- `<F10>` — step over
- `<F11>` — step into
- `<S-F11>` — step out
- `<leader>bp` — toggle breakpoint
- `<leader>dr` — open DAP REPL
- `<leader>dl` — run last DAP configuration

### LSP Operations
- `gd` — go to definition (Telescope)
- `gD` — go to declaration
- `gi` — go to implementation (Telescope)
- `gr` — show references (Telescope)
- `K` — hover documentation
- `<leader>ca` — code action
- `<leader>rn` — rename symbol
- `<leader>ds` — document symbols (Telescope)
- `<leader>D` — show diagnostics (Telescope)
- `[d` / `]d` — previous/next diagnostic
- `<leader>rs` — restart LSP

### Window Management
- `<leader>sv` — split window vertically
- `<leader>sh` — split window horizontally
- `<leader>se` — make splits equal size
- `<leader>sx` — close current split
- `<leader>h/j/k/l` — navigate between splits
- `<leader>to` — open new tab
- `<leader>tx` — close current tab
- `<leader>tn` / `<leader>tp` — next/previous tab
- `<leader>tf` — open current buffer in new tab

### File Navigation
- `<leader>ff` — find files (Telescope)
- `<leader>fr` — recent files (Telescope)
- `<leader>fs` — live grep (Telescope)
- `<leader>fc` — find word under cursor (Telescope)
- `<leader>ft` — find TODOs (Telescope)
- `<leader>fg` — live grep (alternative)
- `<leader>ee` — toggle file explorer (nvim-tree)
- `<leader>ef` — focus current file in explorer
- `<leader>ec` — collapse explorer
- `<leader>er` — refresh explorer

### Formatting & Linting
- `<leader>cf` — format current file (conform.nvim)
- Format-on-save is enabled by default (500ms timeout)

### Git Operations
- `<leader>gs` — open Neogit status
- `:LazyGit` — open LazyGit interface (requires `brew install jesseduffield/lazygit/lazygit`)

### Health Checks
- `:checkhealth` — comprehensive health check for all plugins and dependencies
- Verify DAP adapters: `which rdbg`, `which debugpy`, `which node`

## High-level architecture

This is a modular Neovim configuration built on lazy.nvim with a focus on multi-language development (Ruby, Python, JavaScript/TypeScript, Rust).

### Entry Point & Initialization
- `init.lua` — requires three core modules: `angel.core`, `angel.lazy`, and `angel.lsp`
- `lua/angel/lazy.lua` — bootstraps lazy.nvim and imports plugin specs from multiple namespaces:
  - `angel.plugins` (core plugins)
  - `angel.plugins.git` (git integrations)
  - `angel.plugins.lsp` (language servers)
  - `angel.plugins.dap` (debuggers)

### Core Configuration (`lua/angel/core/`)
- `options.lua` — vim options (relative numbers, 2-space tabs, no swap files, system clipboard integration)
- `keymaps.lua` — base keymaps including window navigation, tab management, file operations
- Leader key is `<Space>`
- Additional keymaps:
  - `jk` in insert mode → Exit to normal mode
  - `<C-s>` → Save file (works in normal, insert, and visual modes)
  - `<C-q>` → Quit all windows
  - `<leader>nh` → Clear search highlights
  - `<leader>+` / `<leader>-` → Increment/decrement numbers

### Plugin System Architecture
Plugins are organized by category in `lua/angel/plugins/`:

**LSP Integration** (`lua/angel/plugins/lsp/`)
- `mason.lua` — installs and manages LSP servers, formatters, linters, and debuggers
  - Auto-installs: lua_ls, ruby_lsp, pyright, rust_analyzer, ts_ls, html, cssls, emmet_ls, svelte, tailwindcss, graphql, marksman, bashls, dockerls, jsonls, yamlls
  - Tools: stylua, prettier, black, isort, rubocop, eslint_d, pylint, debugpy, node-debug2-adapter, codelldb
- `lspconfig.lua` — configures each LSP server with custom settings
  - Ruby: auto-detects ruby-lsp vs solargraph based on `.solargraph.yml` presence
  - JSON/YAML: integrates with schemastore.nvim for schema validation
  - Common `on_attach` function provides unified keybindings across all servers

**DAP (Debug Adapter Protocol)** (`lua/angel/plugins/dap/`)
- Language-specific adapters in separate files: `ruby.lua`, `python.lua`, `node.lua`, `rust.lua`
- `nvim-dap.lua`, `nvim-dap-ui.lua`, `nvim-dap-virtual-text.lua` — debugging UI and visualization

**Testing** (`test-neotest.lua`)
- Multi-language test runner using neotest with adapters for:
  - Python: neotest-python (pytest)
  - Ruby: neotest-rspec (RSpec)
  - JS/TS: neotest-jest
  - Rust: neotest-rust
- Integrated with DAP for test debugging

**Formatting & Linting**
- `conform.lua` — auto-formatting on save with language-specific formatters
  - Lua → stylua, Ruby → rubocop, Python → isort + black, Rust → rustfmt
  - Web → prettier (JS/TS/React/Svelte/CSS/HTML/JSON/YAML/Markdown/GraphQL)
- `linting.lua` — auto-linting on save (rubocop, pylint, eslint_d)

**Syntax & Parsing** (`treesitter.lua`)
- Ensures parsers for: JSON, JavaScript, TypeScript, TSX, YAML, HTML, CSS, Svelte, GraphQL, Bash, Lua, Ruby, Elixir, Rust, Markdown, and more
- Features: syntax highlighting, smart indentation, autotagging, incremental selection

**Git Integration** (`lua/angel/plugins/git/`)
- Multiple git tools: lazygit (TUI), neogit (native UI), gitsigns (inline git status), git-conflict (merge conflict resolution)

**UI & Navigation**
- `telescope.lua` — fuzzy finder with FZF native integration, configured with smart path display and file ignores
- `nvim-tree.lua` — file explorer with git integration, custom folder labels showing last two path segments
- `lualine.lua` — status line
- `which-key.lua` — keybinding hints

### Language-Specific Features

**Ruby**
- Rails support via `vim-rails.lua` (Rails navigation commands)
- Bundler integration via `vim-bundler.lua` and `bundler-info.lua`
- Cucumber support via `vim-cucumber.lua`
- Debug: requires `gem install debug` or `bundle add debug --group=development`
- Attach to Rails server: `rdbg -n --open --port 1234 -- bundle exec rails s`

**Python**
- Debug: requires `pip install debugpy` with virtual environment activated

**JavaScript/TypeScript**
- Debug/Test: requires `npm install --save-dev jest` in project

**Rust**
- Debug: uses codelldb adapter (installable via Mason)

### Special Features
- `obsidian.lua` — Obsidian vault integration for note-taking
- `nvim-surround.lua` — manipulate surrounding characters (quotes, brackets, tags)
- `auto-session.lua` / `session-lens.lua` — session management
- `rest.lua` — HTTP client for API testing
- `markdown.lua` — enhanced Markdown support
- `todo-comments.lua` — highlight and search TODO/FIXME/NOTE comments
- `vim-maximizer.lua` — maximize current split temporarily

### Configuration Files
- `lazy-lock.json` — pins plugin versions for reproducibility
- `after/queries/` — custom Treesitter queries
- `.ruby-lsp/` — Ruby LSP workspace cache

## Dependencies by language

### Ruby
```bash
gem install debug              # for DAP debugging
bundle add debug --group=development
```

### Python
```bash
pip install debugpy           # for DAP debugging
```

### JavaScript/TypeScript
```bash
npm install --save-dev jest   # for testing
```

### LazyGit
```bash
brew install jesseduffield/lazygit/lazygit
```

## Configuration Details

### Bootstrap Process
- Lazy.nvim is bootstrapped automatically on first run (cloned from GitHub if not present)
- Plugin specs are loaded from four namespaces: `angel.plugins`, `angel.plugins.git`, `angel.plugins.lsp`, `angel.plugins.dap`
- All plugins are lazy-loaded by default for optimal startup performance
- `lazy-lock.json` pins plugin versions for reproducibility

### Performance Optimizations
- Disabled built-in plugins: gzip, matchit, matchparen, netrw, tar, tohtml, tutor, zip
- Auto-checker enabled for plugin updates (silent notifications)
- Change detection enabled for config file modifications

### Formatting Behavior
- Format-on-save is enabled with 500ms timeout (configurable in `conform.lua`)
- LSP formatting is used as fallback when conform formatters are unavailable
- Manual format via `<leader>cf`

### LSP Server Selection
- **Ruby**: Automatically detects ruby-lsp vs solargraph based on `.solargraph.yml` presence
- **TypeScript**: Uses `ts_ls` (formerly `tsserver`)
- **JSON/YAML**: Integrated with SchemaStore for automatic schema validation
- All servers use common `on_attach` function for unified keybindings

## Testing with Neotest

This configuration includes comprehensive testing support via neotest with DAP integration:

### Supported Languages

| Language | Adapter | Test Framework | DAP Debug |
|----------|---------|----------------|------------|
| Ruby | neotest-rspec | RSpec | ✅ |
| Python | neotest-python | pytest | ✅ |
| JS/TS | neotest-jest | Jest | ✅ |
| Rust | neotest-rust | cargo test | ✅ |

### Test Commands

- `<leader>tt` — run current test file
- `<leader>tr` — run nearest test under cursor  
- `<leader>ta` — run all tests in project
- `<leader>tS` — debug nearest test with DAP
- `<leader>to` — show test output
- `<leader>ts` — toggle test summary panel

### Requirements by Language

**Ruby:**
```bash
# RSpec should be in Gemfile
bundle exec rspec --version
```

**Python:**
```bash
pip install pytest
```

**JavaScript/TypeScript:**
```bash
npm install --save-dev jest
```

**Rust:**
```bash
cargo test  # built-in
```

## Local LLM Setup (gen.nvim)

The configuration includes `gen.nvim` for local LLM integration via Ollama.

### Recommended Models

- **General purpose**: `llama3:8b`
- **Code generation**: `deepseek-coder-v2:16b-lite`

### Environment Variables

Add to your shell config (`~/.zshrc`, `~/.bashrc`):

```bash
export OLLAMA_SERVER="127.0.0.1"
export OLLAMA_PORT="11434"
export OLLAMA_HOST="${OLLAMA_SERVER}:${OLLAMA_PORT}"
export LLM_MODEL="llama3:8b"
```

### Usage

- `<leader>g1` — generate via LLM
- `<leader>g2` — open Gen chat session

### Setup Ollama

```bash
# Install Ollama
brew install ollama

# Start server
ollama serve

# Pull model
ollama pull llama3:8b
```

## Troubleshooting

**For detailed troubleshooting, see [`TROUBLESHOOTING.md`](./TROUBLESHOOTING.md)**

Quick diagnostics:

```vim
:checkhealth          " comprehensive check
:checkhealth mason    " verify Mason tools
:checkhealth lsp      " LSP configuration  
:LspInfo              " active LSP servers
:Lazy                 " plugin status
```

### Common Quick Fixes

- **LSP not starting**: `:Mason` → verify server installed, check `:LspInfo`
- **LSP "not executable" warning**: Add Mason bin to PATH (see TROUBLESHOOTING.md)
- **Formatter not working**: `:Mason` → check tool installed
- **DAP not working**: Verify adapters with `which rdbg`, `which debugpy`, `which node`
- **Slow startup**: `:Lazy profile` to identify slow plugins
- **Tests not running**: Ensure test framework installed (jest, pytest, RSpec)

### Important Paths

- Neovim config: `~/.config/nvim` (or `$XDG_CONFIG_HOME/nvim`)
- Lazy.nvim data: `~/.local/share/nvim/lazy`
- Mason installs: `~/.local/share/nvim/mason`
- Mason bin (add to PATH): `~/.local/share/nvim/mason/bin`
- Ruby LSP cache: `.ruby-lsp/` in project root

## Notes for Warp

- This config uses Neovim 0.11+ API (`vim.lsp.config()` and `vim.lsp.enable()`)
- Mason handles all tool installation - use `:Mason` if something is missing
- Treesitter parsers are auto-installed on first use
- File tree shows last two directory segments as root label for better context
- Session management is automatic via auto-session.nvim
