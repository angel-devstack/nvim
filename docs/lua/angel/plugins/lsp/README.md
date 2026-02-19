# LSP Plugins Module

## Purpose
LSP plugins provide language server configuration for autocomplete, diagnostics, hover, and refactoring. Auto-detects project environments (Bundler, venv, Cargo).

## Entry Point
`lua/angel/plugins/lsp/init.lua` imports:
- mason
- lspconfig
- ruby-lsp
- venv-lsp
- schemastore

## Load Triggers

### Critical LSP (language-specific)
- **lspconfig**: `event = "VimEnter"` + `ft = {}` for each language
- **mason**: `event = "VeryLazy"` (tool installer)

### Auto-detection plugins
- **ruby-lsp**: `ft = { "ruby", "eruby" }` (Ruby LSP setup)
- **venv-lsp**: `ft = { "python" }` (Python venv detection)
- **ts_context_commentstring**: `ft = { javascript, typescript, ... }` (TS/JS context-aware comments)

### Schema support
- **schemastore**: `event = "VeryLazy"` (JSON/YAML schemas)

## User Actions

### LSP Keymaps (configured by lspconfig)
- `gd` - Go to definition (via Telescope)
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>ds` - Document symbols
- `<leader>D` - Buffer diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>rs` - Restart LSP

### Mason (tool installer)
- `:Mason` - Open Mason UI (install LSP servers, formatters, linters)
- Auto-installs tools on first use

### Project Detection
- **Ruby**: Auto-installs ruby-lsp gem, detects Bundler (.tool-versions or .ruby-version)
- **Python**: Detects venv (.venv, poetry, etc.), sets pythonPath for LSP
- **Rust, JS/TS**: Uses Cargo, npm/Yarn detection

## Files

| Plugin | File | Load Trigger | Purpose |
|--------|------|--------------|---------|
| lspconfig | `lspconfig.lua` | `event = "VimEnter"` | LSP servers configuration |
| Mason | `mason.lua` | `event = "VeryLazy"` | Tool installer |
| Ruby LSP | `ruby-lsp.lua` | `ft = { ruby, eruby }` | Ruby LSP auto-setup |
| Venv LSP | `venv-lsp.lua` | `ft = { python }` | Python venv detection |
| Schemastore | `schemastore.lua` | `event = "VeryLazy"` | JSON/YAML schemas |
| TS Commentstring | `ts_context_commentstring.lua` | `ft = { javascript, typescript, ... }` | TS/JS context-aware comments |

## Troubleshooting

**Issue**: Ruby LSP not attaching
- Check ruby-lsp.gem installed: `gem list | grep ruby-lsp`
- Verify `$GEM_HOME` or `.tool-versions` detected
- Check LSP attached: `:lua print(vim.inspect(vim.lsp.buf_get_clients()))`

**Issue**: Python venv not detected
- Verify `.venv` or `poetry virtualenv` in project root
- Check venv-lsp loaded: `:Lazy status venv-lsp`
- Verify pyright/basedpyright uses correct pythonPath

**Issue**: Rust tool versions missing
- Check `.tool-versions` file exists in project
- Add `rust 1.92.0` (or current version)
- Verify cargo detected with `which cargo`

## Future Options

- [ ] Add language-specific docs (RUBY_LSP.md, PYTHON_LSP.md)
- [ ] Extract schemastore to separate folder
- [ ] Add LSP diagnostics documentation

---

## Links
- **Ruby environment**: See `lua/angel/utils/venv.lua` (for Ruff) and `lua/angel/plugins/ruby/` (for Bundler)
- **Python venv**: See `lua/angel/utils/venv.lua` (shared for Ruff + LSP)
- **Related**: `lua/angel/plugins/lsp/` (source code)