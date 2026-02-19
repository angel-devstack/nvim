# DAP (Debug Adapter Protocol) Plugins

## Purpose
DAP provides debugging interface for Ruby, Python, JS/TS, and Rust. Set breakpoints, step through code, view variables, and debug interactively within Neovim.

## DAP keymaps

| Keymap | Command | Purpose |
|--------|---------|---------|
| `<leader>dc` | Configure debugger | Start DAP session |
| `<leader>ds` | Set breakpoint | Toggle breakpoint on line |
| `<leader>di` | Step into | Step into function call |
| `<leader>do` | Step over | Step over statement |

## Support adapters

### Ruby Debugging
- nvim-ruby-debugger: `lua/angel/plugins/ruby/nvim-ruby-debugger.lua`
- Rails/minitest ports configured (38698, 38699, 38700)

### Python Debugging
- nvim-dap-python: `lua/angel/plugins/dap/python.lua`
- Python debug adapter from Mason

### JS/TS Debugging
- nvim-dap-vscode-js: `lua/angel/plugins/dap/node.lua`
- Loaded only for JS/TS/JSX/TSX files

### Rust Debugging
- nvim-dap: `lua/angel/plugins/dap/rust.lua`
- codelldb adapter from Mason

## Usage Examples

### Ruby debugging
```
<leader>dc  # Start DAP debugger for Ruby
<leader>ds  # Set breakpoint on current line
...         # Navigate to code
<leader>di  # Step into function
```

### Python debugging
```
<leader>dc  # Start DAP debugger for Python
<leader>ds  # Set breakpoint
...         # Run Python script
<leader>do  # Step over statements
```

### JS/TS debugging
```
<leader>dc  # Start DAP debugger for JS/TS
<leader>ds  # Set breakpoint
...         # Run in browser/node
<leader>di  # Step into
```

## Configuration

### DAP core
- **DAP plugin**: `lua/angel/plugins/dap/dap.lua` (main config)
- Loads with `event = "VeryLazy"` (~500ms startup gain)

### Lazy-load per-language
- **Ruby**: `ft = { "ruby" }`
- **Python**: `ft = { "python" }`
- **JS/TS**: `ft = { javascript, typescript, javascriptreact, typescriptreact, vue }`

## Notes

**Optimization from Slice 6 (TESTING/DEBUG)**:
- Changed from `event = { "BufReadPre", "BufNewFile" }` to `event = "VeryLazy"`
- ~500ms startup gain (DAP was heaviest offender from baseline)
- Debugging is rare occurrence, lazy-load safe

**Alternative keymaps avoided:**
- Avoided F5/F10/F11/F12 keys (collision with nvim default keymaps)
- Selected `<leader>d*` prefix for all debugging keymaps (grouped with other workflows)

## Troubleshooting

**Issue**: DAP not starting
- Verify adapter installed: Check Mason packages (debugpy, codelldb, nvim-ruby-debugger)
- Check ft-specific lazy-load: `:Lazy status dap-python`, `:Lazy status nvim-ruby-debugger`
- Ensure `:Lazy profile` shows "VeryLazy" not "start"

**Issue**: Breakpoints not working
- Check `dap.lua` configured correctly
- Verify DAP loaded: `:lua print(vim.inspect(require('dap').configurations))`
- Run with code to test (empty files may not trigger DAP)

**Issue**: Python/Ruby debuggers not available
- Check Mason: `:Mason`
- Install missing adapters: debugpy (Python), codelldb (Rust), nvim-ruby-debugger (Ruby)
- See `docs/plugins/dap.md` for adapter names

---

## Links
- **Configuration**: See `lua/angel/plugins/dap/` (dap, python, rust adapters)
- **Related**: `docs/audit/SLICE6-TESTING-DEBUG-FULL.md` (DAP audit notes)