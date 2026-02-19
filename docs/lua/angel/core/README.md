# Core Module

## Purpose
Core configuration provides Neovim's fundamental settings and keymap definitions. Configured immediately on startup before any plugins load.

## Entry Point
`lua/angel/core/init.lua` is required by `init.lua`:
```lua
require("angel.core")
require("angel.lazy")
```

## Load Triggers
All core files load synchronously on startup (no lazy-loading).

## User Actions

### Keymaps (leader key: `<Space>`)
- `<leader>` - Show which-key menu
- `<leader>h` LSP - Hover, code action, rename, etc. (see keymaps.lua)

### Core Settings
- `opt.scrolloff = 6` - Keep 6 lines margin when scrolling
- `opt.scroll = 5` - Smooth scroll
- `opt.mouse = "a"` - Full mouse support (vertical + horizontal)
- `opt.colorcolumn = "80,100"` - Line length rulers

## Files

| File | Responsibility |
|------|----------------|
| `options.lua` | Neovim core settings (scrolloff, mouse, colorcolumn, etc.) |
| `keymaps.lua` | Global keymap definitions (leader=`<Space>`, core LSP maps) |
| `deprecate.lua` | Deprecation warning handler (silences ruby-lsp lspconfig warnings) |
| `setup.lua` | Core initialization entry point (calls deprecate.setup()) |
| `init.lua` | Loads options + keymaps and highlights on yank |

## Troubleshooting

**Issue**: Leader keymaps not working
- Verify `lua/angel/core/keymaps.lua` loads (check with `:Lazy core`)
- Ensure `<Space>` set as leader in options.lua

**Issue**: Ruby LSP warnings at startup
- `deprecate.lua` should silence `ruby-lsp.nvim` using deprecated lspconfig API
- If warnings persist, check `setup.setup()` is called in `init.lua`

## Future Options

- [ ] Move keymaps to `after/` folder in lazy.nvim structure
- [ ] Add core autocmd group file (currently in init.lua only)
- [ ] Extract deprecate handler to its own plugin if reusable

---

## Links
- **Configuration**: See `options.lua` for all core settings
- **Keymaps**: See `keymaps.lua` for global mappings
- **Related**: `lua/angel/core/` (source code)