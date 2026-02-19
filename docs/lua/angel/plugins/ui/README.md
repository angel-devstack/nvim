# UI Plugins Module

## Purpose
UI plugins provide visual interface enhancements (file explorer, statusline, fuzzy finding, keymap hints, splash screen, etc.). Optimized for performance with lazy-loading.

## Entry Point
`lua/angel/plugins/ui/init.lua` imports:
- telescope
- nvim-tree
- lualine
- which-key
- plus conditional plugins (alpha, scrollbar, etc.)

## Load Triggers

### High-Value Plugins (immediately useful)
- **telescope**: `event = "VimEnter"` (fuzzy finding)
- **nvim-tree**: `cmd = NvimTreeToggle` (file explorer)
- **which-key**: `event = "VeryLazy"` (keymap menu)

### Visual Polish (lazy loaded)
- **lualine**: `event = "VeryLazy"` (statusline)
- **alpha**: `event = "VimEnter"` + empty buffer (splash screen)
- **indent-blankline**: `event = { "BufReadPre", "BufNewFile" }` (indent guides)
- **nvim-scrollbar**: `event = "BufReadPost"` (scrollbar)
- **trouble**: `keys = { "<leader>xx", "<leader>xt", "<leader>xw" }` (diagnostics)
- **colorscheme**: `lazy = false` (critical, loads immediately)
- **dressing**: `event = "VeryLazy"` (UI dialogs)

## User Actions

### File Explorer (nvim-tree)
- `<leader>ee` - Toggle NvimTree (explorer)

### Fuzzy Finding (telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Buffers
- `<leader>fh` - Help
- `<leader>`f` - Search in files

### Diagnostics (trouble - simplified from 6 to 3 mappings)
- `<leader>xx` - Toggle trouble
- `<leader>xt` - Switch to list (todos)
- `<leader>xw` - Switch to workspace

### Keymaps (which-key)
- Press `<leader>` + incomplete key → Shows available options

### Splash Screen (alpha)
- Shows when Neovim opens with no files

### Statusline (lualine)
- Shows mode, git branch, diagnostics, LSP info

## Files

| Plugin | File | Load Trigger | Purpose |
|--------|------|--------------|---------|
| Telescope | `telescope.lua` | `event = "VimEnter"` | Fuzzy finding files/buffers/grep |
| Nvim-tree | `nvim-tree.lua` | `cmd = NvimTreeToggle` | File explorer |
| Trouble | `trouble.lua` | `keys = { <leader>xx, xt, xw }` | Diagnostics UI |
| Lualine | `lualine.lua` | `event = "VeryLazy"` | Statusline |
| Which-key | `which-key.lua` | `event = "VeryLazy"` | Keymap popup |
| Alpha | `alpha.lua` | `event = "VimEnter"` | Splash screen |
| Colorscheme | `colorscheme.lua` | `lazy = false` | Dark theme (critical) |
| Indent-blankline | `indent-blankline.lua` | `event = BufReadPre` | Indent guides |
| Scrollbar | `nvim-scrollbar.lua` | `event = BufReadPost` | Scrollbar |
| Dressing | `dressing.lua` | `event = "VeryLazy"` | UI dialogs |

## Troubleshooting

**Issue**: Nvim-tree not showing files
- Check `<leader>ee` keymap exists
- Ensure `cmd = NvimTreeToggle` is configured

**Issue**: Telescope keymaps not working
- Verify telescope.load_on_startup in init.lua
- Check `:Telescope` command works

**Issue**: Lualine not showing
- Verify lualine loads with `:Lazy status lualine`
- Ensure `event = "VeryLazy"` configured

## Future Options

- [ ] Extract alpha.lua to `plugins/ui/welcome/`folder
- [ ] Add UI themes configuration file
- [ ] Add plugin-specific keymaps to individual READMEs

---

## Links
- **Detailed plugin docs**: See [Telescope docs/plugins/telescope.md](docs/plugins/telescope.md)
- **Config examples**: See `lua/angel/plugins/ui/*.lua` for plugin-specific settings
- **Related**: `lua/angel/plugins/ui/` (source code)