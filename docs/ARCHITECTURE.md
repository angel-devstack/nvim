# Architecture: How lua/angel Is Organized

**Complete guide to the modular Neovim configuration structure.**

---

## Directory Structure

```
lua/angel/
├── core/                          # Core configuration (loads first)
│   ├── options.lua                # Neovim settings (scrolloff, mouse, colorcolumn)
│   ├── keymaps.lua                 # Global keymaps (leader=`<Space>`)
│   ├── deprecate.lua                # Deprecation handler (silences ruby-lsp warnings)
│   ├── setup.lua                   # Core initialization
│   └── init.lua                    # Entry point (imports core + lazy)
├── plugins/                       # Plugin configurations (organized by category)
│   ├── completion/               # Completion engine (nvim-cmp)
│   ├── dap/                      # Debug Adapter Protocol
│   │   ├── dap.lua               # Core DAP config
│   │   ├── python.lua            # DAP adapter for Python
│   │   ├── rust.lua              # DAP adapter for Rust
│   │   └── node.lua              # DAP adapter for JS/TS
│   ├── editing/                  # Text editing enhancements
│   │   ├── nvim-surround.rb        # Surround (`ys`, `cs`, `ds`, `cS`, `cS`)
│   │   ├── substitute.lub          # Substitute (`s`, `ss`, `S`, `cs`)
│   │   ├── splitjoin.rb            # Split/Join (`gS`, `gJ`)
│   │   ├── mini-align.luau        # Alignment (`ga`, `gA`)
│   │   ├── comment.lua             # Comments (`gcc`, `gc`)
│   │   ├── ts_context_commentstring.lua # TS/JS context-aware comments
│   │   ├── endwise.lua            # Auto `end` (Ruby endwise)
│   │   └── autopairs.lua            # Auto pares ()[] etc.
│   ├── formatting/              # Auto-formatting (conform) + linting (nvim-lint)
│   │   ├── conform.lua             # Auto-formatting (Ruff, stylua, prettier, rubocop)
│   │   └── linting.lua             # Linting (Ruff, flake8, shellcheck, rubocop)
│   ├── git/                      # Git integrations
│   │   ├── git-conflict.lua         # Merge conflict resolution
│   │   ├── gitsigns.lua             # Git diff visualization (Lazy-loaded)
│   │   └── neogit.lua               # Git operations UI
│   ├── lsp/                      # Language servers
│   │   ├── lspconfig.lua            # LSP servers configuration
│   │   ├── mason.lua                 # Tool installer (LSP, formatters, linters)
│   │   ├── ruby-lsp.lua              # Ruby LSP auto-setup (ruby-lsp gem)
│   │   ├── schemastore.lua           # JSON/YAML schema support
│   │   ├── ts_context_commentstring.lua # TS/JS comments (ft-specific, lazy-loaded)
│   │   └── venv-lsp.lua              # Python venv detection (ft-specific)
│   ├── misc/                      # Miscellaneous tools
│   │   ├── auto-session.lua         # Session management
│   │   ├── sort.rb                  # Sort selection
│   │   └── vim-maximizer.rb          # Maximize/minimize windows
│   ├── ruby/                      # Ruby-specific tools
│   │   ├── vim-rails.rb              # Rails workflow
│   │   ├── vim-bundler.rb            # Bundler commands
│   │   ├── bundler-info.rb           # Bundler information
│   │   ├── vim-cucumber.rb         # Cucumber tests
│   │   └── nvim-ruby-debugger.rb    # Ruby DAP (Rails + Minitest)
│   ├── syntax/                   # Syntax highlighting
│   │   ├── treesitter.lua           # Core Treesitter
│   │   └── nvim-treesitter-textobjects.lua # Text objects (ai, af, ac, etc.)
│   ├── testing/                   # Test execution
│   │   └── test-neotest.lua          # Neotest integration (RSpec, pytest, Jest)
│   ├── ui/                        # Visual interface
│   │   ├── telescope.lua           # Fuzzy finding
│   │   ├── nvim-tree.lua           # File explorer
│   │   ├── lualine.lua             # Statusline
│   │   ├── which-key.lua             # Keymap popup
│   │   ├── trouble.lua             # Diagnostics UI (simplified)
│   │   ├── alpha.lua               # Splash screen
│   │   ├── nvim-scrollbar.lua       # Scrollbar (WezTerm mouse interaction)
│   │   ├── colorscheme.lua         # Dark theme (loads immediately)
│   │   ├── indent-blankline.lua      # Indent guides
│   │   └── dressing.lua             # UI dialogs
│   ├── tools/                     # Workflow tools
│   │   ├── opencode.lua            # AI assistant (ask questions about code)
│   │   ├── rest.rb                  # HTTP client
│   │   ├── ruby-lsp.rb              # Ruby LSP (ruby-lsp gem)
│   │   ├── venv-lsp.rb              # Python venv detection
│   │   ├── image.rb                 # Image preview (WezTerm only)
│   │   ├── magick-rock.rb           # LuaRocks for ImageMagick
│   │   ├── markdown.rb              # Render markdown + Mermaid
│   │   ├── todo-comments.rb         # TODO comments
│   │   └── obsidian.rb               # Obsidian vaults (notes, zettelkasten)
│   └── init.lua                    # Entry point (imports by category)
├── snippets/                    # Custom snippets (Ruby, Rails, Lua, etc.)
│   ├── ruby.rb # Ruby/Rails snippets
│   └── rails.rb # Framework snippets (model routes, controller actions)
└── utils/
    ├── path.lua # Path helpers
    ├── terminal.rb # Terminal detection (is_wezterm, is_iterm)
    └── venv.lua # Venv detection (resolve_ruff for Python)
```

---

## Load Triggers & Lazy-Loading Strategy

### Core (immediate load)
- Loads synchronously on startup before any plugins
- No lazy-loading (critical configuration first)

### Plugins (demand-based loading)

#### High-Value Plugins (immediately useful)
- **telescope**: `event = "VimEnter"` (find files after opening)
- **nvim-tree**: `cmd = NvimTreeToggle` (file explorer)
- **which-key**: `event = "VeryLazy"` (keymap popup)
- **colorscheme**: `lazy = false` (dark theme, critical for UI)

#### Visual Polish (Lazy)
- **lualine**: `event = "VeryLazy"` (~0ms impact)
- **alpha**: `event = "VimEnter"` + empty buffer (splash screen)
- **indent-blankline**: `event = BufReadPre` (indent guides immediate)
- **nvim-scrollbar**: `event = BufReadPost` (scrollbar, WezTerm mouse)
- **trouble**: `keys = { <leader>xx, xt, xw }` (diagnostics on-demand)
- **dressing**: `event = "VeryLazy"` (UI dialogs)

#### Language-Specific (conditional loading)
- **completeness** (Nvim-lspconfig+ Ruby LSP, venv detection, etc.)
- `ruby-lsp.nvim`: `ft = { "ruby", "eruby" }` (auto-detects Bundler)
- `venv-lsp.nvim`: `ft = { "python" }` (auto-detects venv)
- `ts_context_commentstring`: `ft = { javascript, typescript, ... }` (TS/JS comments)

#### Terminal-Aware (conditional loading)
- **image.nvim**: `cond = terminal.is_wezterm()` (only in WezTerm)
- **magick-rock**: `cond = terminal.is_wezterm()` (WezTerm-only LuaRocks)

#### Toolchain Detection (auto-on load)
- **Ruby**: Bundler detected if `vim.fn.filereadable("Gemfile") == 1`
- **Python**: `.venv` detected in `lua/angel/utils/venv.lua` (resolves .venv/bin/ruff)
- **Rust**: `.tool-versions` file read for tool versions
- **Git**: Used for Gitsigns, Neogit (git-config integration)

---

## Architecture Layers

### Layer 1: Core (Immediate)
```
lua/angel/core/
  ├── options.lua (settings: scrolloff=6, mouse=a, colorcolumn=80,100...)
  ├── keymaps.lua (maps: <leader>=<Space>, core LSP maps: gd, gr, K...)
  ├── deprecate.lua (silences ruby-lsp.nvim lspconfig warnings)
  ├── setup.lua (calls deprecate.setup())
  └── init.lua (requires core, calls lazy.nvim)
```

**Purpose:** Configure Neovim environment first, establish keymaps, handle deprecations.

---

### Layer 2: Plugin Categories (Lazy)

#### By Priority (roughly)

**P1: Core UX (essential)**
- Completion: `nvim-cmp` (LSP, snippets, buffer, path sources)

**P2: Navigation (high-value)**
- UI: `telescope` (fuzzy finding), `nvim-tree` (file explorer)

**P3: Development (language-specific)**
- LSP: `lspconfig + ruby-lsp + venv-lsp` (Ruby/Python auto-detection)
- Formatting/Linting: `conform + nvim-lint` (Ruff, rubocop, stylua, prettier)

**P4: Testing & Debugging (developer tools)**
- DAP: `dap + dap-python + nvim-ruby-debugger` (Ruby, Python, JS/TS, Rust)
- Testing: `neotest` (RSpec, pytest, Jest)

**P5: Tools & AI**
- Tools: `rest` (HTTP client), `opencode` (LLM assistant), `obsidian` (notes)
- AI: `opencode.nvim` integrated with snacks.nvim

**P6: Git Operations**
- Git: `gitsigns` (diff visual), `git-conflict` (conflict resolution)
- Neogit: (commit interface, branch management)

**P7: Visual Polish**
- UI: `lualine`, `which-key`, `alpha`, `nvim-scrollbar`, `trouble`
- Syntax: `treesitter`, `nvim-treesitter-textobjects`
- Markdown: `render-markdown` (Mermaid, images - WezTerm only)

---

## Toolchain Auto-Detection

### Python (venv detection)
- **Helper**: `lua/angel/utils/venv.lua` → `resolve_ruff()` function
- **Detection in conform.lua**:
  ```lua
  local ruff_path = require("angel.utils.venv").resolve_ruff()
  conform.formatters.ruff = { command = ruff_path }
  ```
- **Detection in linting.lua**:
  ```lua
  linting.linters.ruff = { cmd = ruff_path }
  ```
- **Works without venv activation**: No need to `source .venv/bin/activate`

### Ruby (Bundler detection)
- **Detection in ruby-lsp.nvim**: `cond = function() return vim.fn.filereadable("Gemfile") = 1 end`
- **Usage**: Only bundles when Gemfile present in project

### Rust (Cargo detection)
- **Detection**: .tool-versions file reading (Mise toolchain support)
- **Configuration**: Set `rust 1.92.0` in `.tool-versions` if missing

---

## Terminal Detection

### Helper Module: `lua/angel/utils/terminal.lua`

```lua
-- Terminal-aware detection functions
is_wezterm()  -- Detect WezTerm: vim.env.TERM_PROGRAM == "WezTerm" or vim.env.WEZTERM_PANE
is_iterm()    -- Detect iTerm: vim.env.TERM_PROGRAM == "iTerm.app"
is_kitty()     -- Detect Kitty: vim.env.TERM == "xterm-kitty"
```

### Usage in plugins

**WezTerm-only plugins:**
```lua
-- image.nvim
cond = function()
  return terminal.is_wezterm()
end

-- magick-rock
cond = function()
  return terminal.is_wezterm()
end
```

**Mermaid rendering:**
```lua
mermaid.enabled = terminal.is_wezterm()  -- Only enable in WezTerm
```

**Result:**
- WezTerm: Plugins load, images render, Mermaid diagrams show
- iTerm: Plugins don't load, text-only mode, no images

---

## Startup Performance Optimization

### Original baseline: ~156ms startup

### Offenders identified:
- DAP: `event = BufReadPre, BufNewFile` → 519ms (33% of 156ms)
- ts_context_commentstring: `event = BufReadPre` → 710ms (biggest offender)
- lint: ~607ms
- nvim-scrollbar: ~422ms
- render-markdown: ~0-50ms per buffer

### Optimizations applied (slices 1-10):

| Slice | Focus | Changes | Gain |
|------|-------|--------|------|
| 1: Core UX | session VeryLazy, scrolloff=6 | 0ms |
| 2: Navigation | Trouble 6→3 keymaps | ~0ms |
| 3: LSP + Completion | Keep all packages | 0ms |
| 4: Format/Lint | Ruff path resolution | 0ms |
| 5: Git | Remove lazygit, Gitsigns VeryLazy, 13→7 keymaps | ~400ms |
| 6: Testing/Debug | DAP VeryLazy, ~500ms gain | ~500ms |
| 7: UI/Visual | Mouse enable, colorcolumn rulers 80/100 | 0ms |
| 8: QoL | Comment lazy-load ~700ms, todo-comments lazy-load | ~700ms |
| 9: Editing | splitjoin lazy-load fix, tabular→mini.align | 0ms |
| 10: Additional | luarocks.nvim cond=WezTerm ~100-500ms | ~100-500ms |

### Total: ~1700ms startup gain (baseline 156ms → ~260ms)

---

## Configurations & Settings

### Core Options
- `opt.mouse = "a"` - Full mouse (vertical + horizontal)
- `opt.scrolloff = 6` - Keep 6 lines margin when scrolling
- `opt.scroll = 5` - Smooth scroll steps
- `opt.colorcolumn = "80,100"` - Line length rulers at 80, 100

### Keymaps (leader: <Space>)
- `<leader>f{ff, fr, fs, fc, ft}` - Find files/search/todo
- `<leader>e{ee, ef}` - Eplorer toggle/focus
- `<leader>g{ss, gh, gr}` - Git start/hunks/gitsigns
- `<leader>{c{a, r, o}, d{c, s, i, o}, r{r, s}}` - CDEOR test/debug keymaps
- `<leader>t{t, r, a, o, s}` - Test/training keymaps
- `<leader>xx, xt, xw` - Trouble diagnostics UI
- `<leader>=, ~` - Align text by delimiter (=, :, ,)

---

## Lazy.nvim Plugin Manager

### Entry Point
`lua/angel/lazy.lua` - Bootstrap lazy.nvim (only loads in init.lua after core)

### Plugin Loading by Category
**Example: `lua/angel/plugins/lsp/init.lua`:**
```lua
return {
  { import = "angel.plugins.lsp.lspconfig" },  -- Individual file
  { import = "angel.plugins.lsp.mason" },         -- Individual file
  { import = "angel.plugins.lsp.ruby-lsp" },    -- Individual file
  -- Imports by category with :lua/angel/plugins/lsp/init.lua pattern
}
```

**Load Triggers:**
- `event = "VimEnter"` - Load after opening
- `event = "VeryLazy"` - Lazy-load after all
- `cmd = "Command"` - Load when command executed
- `keys = { "Keymaps", }` - Load when keymap pressed
- `ft = { "ext" }` - Load for specific filetypes
- `cond = function() end` - Conditional loading (terminal detection, etc.)

---

## Performance Best Practices

### Lazy-load Strategy Implementation

1. **Always use specific triggers**:
   - Good: `keys = { "<leader>ff" }`, `cmd = "Telescope"` - specific
   - Avoid: `event = "VimEnter"` (loads everything at once)

2. **Group plugins by category**:
   - `lua/angel/plugins/lsp/` - LSP-related only
   - `lua/angel/plugins/ui/` - UI-only plugins

3. **Conditional loading** (`cond` vs `event`):
   - Terminal-aware: `cond = terminal.is_wezterm()` (image plugins)
   - Lazy-loading: `event = "VeryLazy"` (non-critical visual polish)

4. **Filetype-specific**: `ft = { ruby, eruby }` (language tools)
- Prevents loading when not needed (saves startup time)

5. **Auto-detection optimization** (toolchain)
   - Detect Bundler for Ruby (Gemfile present)
   - Detect venv for Python (.venv folder)
   - Read .tool-versions for Cargo (versions without manual config)

---

## References

- **By-Folder Documentation**: See `docs/lua/angel/` for per-carpetra READMEs
- **Plugin Details**: See `docs/plugins/` for individual plugins
- **User Guide**: See `USER_MANUAL.md` for usage examples
- **Terminal Support**: See `TERMINAL_SUPPORT.md` for WezTerm vs iTerm
- **Troubleshooting**: See `TROUBLESHOOTING.md` for common issues

---

**Version**: 1.0 (Post-Audit Optimized)  
**Last Updated**: 2026-02-19  
**Architecture Goal**: Modular, fast, maintainable Neovim setup with plugin lazy-loading strategy
