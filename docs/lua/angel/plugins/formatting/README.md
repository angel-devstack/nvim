# Formatting Plugins Module

## Purpose
Formating plugins provide code formatting (on save or command) and linting (real-time diagnostics). Auto-detects project toolchain (Bundler, venv, Cargo).

## Entry Point
`lua/angel/plugins/formatting/init.lua` imports:
- conform
- linting

## Load Triggers

### Auto-formatting (conform)
- Loads in Insert mode + when file saved (auto-format-save enabled)
- Uses Ruff (Python), stylua (Lua), rubocop (Ruby), prettier (JS/TS)

### Linting (nvim-lint)
- Loads on file open (BufReadPost)
- Uses Ruff (Python), black/mypy optional, shellcheck (bash), rubocop (Ruby)

## User Actions

### Auto-formatting (conform)
- **Format on save**: Auto-formats when file saved
- **Format command**: `<leader>cf` to format file manually
- **Supported formatters**:
  - Ruby: rubocop/stylua/standard
  - Python: Ruff
  - Lua: stylua
  - JS/TS: prettier/dprint

### Linting (nvim-lint)
- **Real-time diagnostics**: Shows lint errors as you type
- **Supported linters**:
  - Python: Ruff/flake8/mypy
  - Bash: shellcheck
  - Ruby: rubocop
  - TypeScript: eslint

### Toolchain Detection
- **Ruby**: Auto-installs rubocop if missing (uses `bundle install rubocop`)
- **Python**: Uses Ruff from `.venv/bin/ruff` (auto-detects virtual environment)
- **Rust**: Uses `cargo` if `.tool-versions` configured

## Files

| Plugin | File | Load Trigger | Purpose |
|--------|------|--------------|---------|
| Conform | `conform.lua` | Insert + BufWrite | Auto-formatting |
| Linting | `linting.lua` | BufReadPost | Real-time linting |

## Toolchain Integration

### Python auto-detection
- Automatically detects `.venv` in project root
- Falls back to system-wide Ruff if `.venv` not found
- No need to activate venv before opening Neovim

### Ruby Bundler detection
- Uses `vim.fn.system("bundle which rubocop")` if Bundler available
- Falls back to system-wide `rubocop` tool

## Troubleshooting

**Issue**: Formatting not working on save
- Check `format_on_save` enabled in conform config
- Verify formatter available: `which rubocop`, `which ruff`, `which stylua`
- Check Ruff path in conform config: `require("angel.utils.venv").resolve_ruff()`

**Issue**: Linting not showing diagnostics
- Verify nvim-lint loaded: `:Lazy status lint-nvim`
- Check linter available: `which flake8`, `which shellcheck`
- Ensure `event = BufReadPost` configured

**Issue**: Ruff ENOENT (no such file) errors
- Verify `lua/angel/utils/venv.lua` works
- Check `.venv/bin/ruff` path detection in `conform.lua`
- Ensure venv detection works for your Python project

## Future Options

- [ ] Add formatting/linting language-specific docs
- [ ] Add toolchain detection utilities docs
- [ ] Extract formatter-specific docs (RUFF_FORMATTING.md, RUBOCOP_FORMATTING.md)

---

## Links
- **Ruff auto-detection**: See `lua/angel/utils/venv.lua` (resolves .venv/bin/ruff)
- **Toolchain**: See `lua/angel/plugins/ruby/` (Bundler detection) and `lua/angel/utils/venv.lua`
- **Related**: `lua/angel/plugins/formatting/` (source code)