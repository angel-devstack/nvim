# Trouble Plugin

## Purpose
Trouble provides diagnostics UI to navigate issues, todos, and workspace problems. Simplified to 3 high-signal keymaps (from 6).

## Keymaps

| Keymap | Command | Purpose |
|--------|---------|---------|
| `<leader>xx` | `TroubleToggle` | Toggle trouble diagnostics |
| `<leader>xt` | Switch to list | Select mode: Todos/Workspace/Symbols |
| `<leader>xw` | Switch to workspace | Workspace diagnostics |

## Features

### Simplified keymaps (audit Slice 2)
**Before (6 → 3 simplification)**:
- `<leader>xd, <leader>xq, <leader>xl` removed
- Only keeps high-signal maps: `xx` (toggle), `xt` (lists), `xw` (workspace)

### Diagnostics sources
- LSP diagnostics (Ruby, Python, JS/TS, Lua)
- Linting diagnostics (Ruff, flake8, shellcheck, rubocop)
- Other diagnostics (if configured in DAP/LSP)

### Navigation
- Use standard `:copen` command in quickfix list to navigate issues

## Usage Examples

### View all diagnostics
```
<leader>xx  # Toggle trouble open
           # Lists all diagnostics in project
           # <Enter> to jump to file
```

### Switch to specific list
```
<leader>xt  # Switch mode: Todos → Workspace → Symbols → ...

Lists:
- Todos (TODO comments)
- Workspace (all file diagnostics)
- Symbols (LSP symbols per file)
```

### Workspace diagnostics
```
<xleader>xw  # Switch to workspace diagnostics view
            # Shows diagnostics per file (Ruby, Python, etc.)
```

## Configuration
- See `lua/angel/plugins/ui/trouble.lua` for setup
- Simplified from 6→3 keymaps in Slice 2 (NAVIGATION)

## Notes

**Why simplified?**
- `<leader>xd` (document diagnostics) → Use `<leader>D` instead
- `<leader>xq` (quickfix list) → Use `:copen` command
- `<leader>xl` (location list) → Duplicates with workspace

## Troubleshooting

**Issue**: Trouble not listing diagnostics
- Verify linting/LSP configured (Ruff, rubocop, etc.)
- Check trouble loads: `:Lazy status trouble`
- Ensure `keys = { "<leader>xx", "<leader>xt", "<leader>xw" }` configured

**Issue**: Keymaps not working
- Check `<leader>` prefix set to `<Space>` (core/keymaps.lua)
- Verify trouble loads: `:Lazy status trouble`
- Test with: `:TroubleToggle` command

---

## Links
- **Configuration**: See `lua/angel/plugins/ui/trouble.lua`
- **Related**: See `docs/lua/angel/plugins/ui/README.md` (UI plugins overview)