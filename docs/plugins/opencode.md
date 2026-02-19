# Opencode Plugin

## Purpose
Opencode provides AI assistant (LLM) built into Neovim. Ask questions about code, select code for analysis, toggle on/off, without leaving editor. Powered by snacks.nvim.

## Dependencies
- `folke/snacks.nvim` (provides input, picker, terminal)

## Keymaps

| Keymap | Command | Purpose |
|--------|---------|---------|
| `<C-a>` | `opencode.ask("@this: ")` | Ask opencode AI question about current code |
| `<C-x>` | `opencode.select()` | Execute selected opencode action |
| `ga` | `opencode.prompt("@this")` | Add to opencode |
| `<C-.>` | `opencode.toggle()` | Toggle opencode on/off |
| `<S-C-u>` | `opencode.command("session.half.page.up")` | Half page up |
| `<S-C-d>` | `opencode.command("session.half.page.down")` | Half page down |

## Usage

### Ask questions about code
```
<C-a>  # Open opencode ask prompt (line-by-line or selection-based)

Example:
  <C-a> "What does this function do?"
  <C-a> "Explain if this code has any bugs"
  <C-a> "How can I optimize this loop?"
```

### Select code for analysis
```
<C-x>  # Execute opencode action (after selection via vim motions)

Example:
  v (visual mode) → Select code → <C-x> → Opocode provides analysis
```

### Add context to opencode
```
ga  # Add to opencode

Example:
  Select code → ga → Add to opencode for question
```

### Toggle on/off
```
<C-.>  # Toggle opencode activation

Useful if opencode is annoying or you want to test without AI
```

## Configuration

### Core options
```lua
vim.g.opencode_opts = {
  -- Custom options for opencode behavior (if any)
}
```

### Auto-reload
```lua
vim.o.autoread = true  -- Required for opts.auto_reload
```

## Notes
- **Lazy-loaded with VeryLazy**: Loads after all plugins (no startup impact)
- **No builtin <C-a>冲突**: User confirmed not using builtin increment key
- **Integration**: Works with snacks.nvim for input/picker/terminal (modern UI)
- **Usage patterns**:
  - Ask questions while coding without leaving Neovim
  - Select code segments with `<C-x>` for focused analysis
  - Toggle with `<C-.>` if opocode becomes invasive

## Troubleshooting

**Issue**: `<C-a>` not working
- Check `<C-a>` keymap exists: `:map <C-a>`
- Verify opencode loaded: `:Lazy status opencode`
- Ensure `keys = { "<C-a>" }` configured (done in audit)

**Issue**: Opencode not responding to questions
- Verify LLM configured (opencode.nvim requires LLM API key)
- Check snacks.nvim dependencies loaded: `:Lazy status snacks.nvim`
- Confirm `vim.g.opencode_opts` configured

**Issue**: Opocode interfering with other keymaps
- Toggle off: `<C-.>`
- Check if other plugins use `<C-x>` (execute action) - uncommon

## Future Options

- [ ] Add LLM API key configuration docs
- [ ] Create usage examples (question patterns)
- [ ] Extract snacks dependencies docs

---

## Links
- **Configuration**: See `lua/angel/plugins/tools/opencode.lua` (keymaps)
- **Related**: See `docs/plugins/telescope.md` for code search integration with opencode