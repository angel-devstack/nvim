# Telescope Plugin

## Purpose
Telescope provides fuzzy finding for files, buffers, live grep, and advanced searches. Alternative to standard Vim search with live results and preview.

## Entry Point
- Configured in `lua/angel/plugins/ui/telescope.lua`
- Loads with `cmd = "Telescope"`

## Keymaps

| Keymap | Command | Purpose |
|--------|---------|---------|
| `<leader>ff` | `Telescope find_files` | Find files recursively |
| `<leader>fr` | `Telescope oldfiles` | Recent files |
| `<leader>fs` | `Telescope live_grep` | Live grep across project |
| `<leader>fc` | `Telescope grep_string` | Find word under cursor |
| `<leader>ft` | `TodoTelescope` | Find TODOs (via todo-comments.nvim) |

## Configuration

### Previewers
- **file_previewer**: `vim_buffer_cat.new` (file preview)
- **grep_previewer**: `vim_buffer_vimgrep.new` (grep preview)
- **qflist_previewer**: `vim_buffer_qflist.new` (quickfix preview)

### Layout
- `sorting_strategy = "ascending"`
- `layout_strategy = "horizontal"`
- `preview_width = 0.55`, `results_width = 0.8`
- `path_display = { "smart" }`

### File Ignoring
- Excludes: `node_modules`, `.git/objects/`, `dist/`, `coverage/`, `.pytest_cache/`, `venv`, `.rbenv/`, etc.

### Extensions
- **plenary.nvim** - Core Lua library
- **fzf-native** - Fast fuzzy finder alternative
- **nvim-web-devicons** - File icons in search results
- **todo-comments.nvim** - TODO Comments integration

### LSP Extensions
- **LSP diagnostics** - `Telescope diagnostics`
- **LSP document symbols** - `Telescope document_symbols`
- **LSP workspace symbols** - `Telescope workspace_symbols`
- **LSP references** - `Telescope lsp_references`

## Usage Examples

### Finding files
```
<leader>ff  # Open Telescope find_files
           # Type filename to search
           # <Enter> to open
```

### Live grep
```
<leader>fs  # Open Telescope live_grep
<ctrl-r>   # Search for content: "def foo"
           # Live results update as you type
           # <Enter> to open matched file
```

### Search TODOs
```
<leader>ft  # Open TODO comments Telescope
           # Lists all TODO/FIXME/HACK comments
           # <Enter> to jump to file
```

## Troubleshooting

**Issue**: `ft_to_lang nil` error in previews
- **Fixed in audit**: `preview.treesitter = false` (disabled tree-sitter in preview)
- See `SLICE6-TESTING-DEBUG-FULL.md` in docs/audit/

**Issue**: Telescope slow on large projects
- Check fzf-native loaded: `:Lazy status fzf-native`
- Verify file_ignore_patterns configured correctly

**Issue**: Search results not showing
- Check dependencies loaded: `plenary.nvim`, `fzf-native`
- Ensure telescope.setup() called

## Advanced Usage

### Custom searches
```lua
-- Search filetypes
:Telescope filetypes

-- Search commands
:Telescope commands

-- Search keymaps
:Telescope keymaps

-- Search highlights
:Telescope highlights
```

### LSP-powered searches
```lua
-- Document symbols (current file)
:Telescope document_symbols

-- Workspace symbols (all files)
:Telescope workspace_symbols

-- References (function usages)
:Telescope lsp_references
```

---

## Links
- **Configuration**: See `lua/angel/plugins/ui/telescope.lua` for full configuration
- **Related**: See `docs/plugins/opencode.md` for AI assistant usage in searches
- **Examples**: See `docs/examples/telescope/` (if created)