# Terminal Support: WezTerm vs iTerm

**Terminal detection and feature support by terminal type.**

---

## Which terminals are supported?

| Feature | WezTerm | iTerm | Standard terminals |
|---------|---------|------|------------------|
| **Image preview** | ✅ Inline (sixel, kitty protocol) | ❌ Not supported | ❌ Not supported |
| **Mermaid diagrams** | ✅ Rendered as images | ❌ Text-only | ❌ Text-only |
| **Terminal graphics** | ✅ (sixel, sixel, kitty) | ❌ None | ❌ None |
| **Unicode/sixel** | ✅ Full support | Partial (some) | ❌ No |
| **Auto-detection** | ✅ Transparent | ✅ Transparent | ❌ Limited |

---

## WezTerm (Recommended)

### Advantages
- **Image preview**: See inline images directly in Neovim
- **Mermaid diagrams**: Inline rendering of workflow diagrams
- **Terminal graphics**: Sixel/sixel (progress bars, charts, images)
- **Mouse scroll**: Vertical + horizontal wheel support (MX Master 3 Mac)

### Configuration
- **Detection**: `vim.env.TERM_PROGRAM == "WezTerm"` (primary)
- **Detection**: `vim.env.WEZTERM_PANE ≠ nil` (alternative)
- **No user config needed**: Auto-detects in terminal.lua helper

### Supported Features
- **render-markdown**: Mermaid rendering, code blocks, lists
- **image.nvim**: Image preview (PNG, JPG, SVG)
- **magick-rock**: LuaRocks for ImageMagick (via conditional load)
- **nvim-scrollbar**: Mouse scroll interaction (vertical + horizontal)

---

## iTerm

### Advantages
- **Standard terminal compatibility**: Works everywhere
- **No special configuration needed**: Uses standard terminal protocols
- **Fast performance**: Lightweight, no graphics overhead

### Limitations
- **No image rendering**: Text-only mode (images shown as alt text)
- **Mermaid text-only**: Diagrams show as code blocks, not rendered
- **No terminal graphics**: No fancy UI elements

### Supported Features
- **Core LSP functionality** (Ruby LSP, Python LSP, etc.)
- **Completion** (nvim-cmp with snippets, buffer, path sources)
- **Text editing** (surround, substitute, autopairs, etc.)
- **All non-visual plugins work** (Telescope, Trouble, Neogit, etc.)

---

## How Detection Works

### Helper Module: `lua/angel/utils/terminal.lua`

```lua
-- Detect WezTerm by environment variable
function is_wezterm()
  return vim.env.WEZTERM_PANE ~= nil or vim.env.TERM_PROGRAM == "WezTerm"
end
```

### Usage in Plugins

#### WezTerm-only plugins (conditional)
```lua
-- image.nvim: Only loads in WezTerm
cond = function()
  return terminal.is_wezterm()
end
```

#### Mermaid rendering (conditional)
```lua
-- render-markdown: Only enable Mermaid in WezTerm
mermaid.enabled = terminal.is_wezterm()
```

#### result
- **WezTerm**: Plugins load, images render, Mermaid diagrams show
- **iTerm**: Plugins don't load, text-only mode, no images

---

## Related Documentation

- **Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md) for terminal detection helper
- **Examples**: See `docs/examples/markdown/mermaid-example.md` (diagrams)
- **Plugin docs**: See `docs/plugins/markdown-images.md` (render-markdown + image integration)

---

## Summary

**WezTerm**: Full feature support (images, Mermaid, terminal graphics)
- Auto-detection transparent (no config needed)
- Optimized for this setup (conditional plugin loading)

**iTerm**: Standard terminal compatibility
- No visual features (no images, no Mermaid rendering)
- Core features work normally (LSP, completion, editing, etc.)

**Recommendation**: Use WezTerm for visual features (images diagrams), but iTerm works fine if you prefer standard terminal.

---

**Auto-detection Note**:
- WezTerm/iTerm detected via `vim.env.TERM_PROGRAM` (env var set by terminal)
- Configured transparently in `lua/angel/utils/terminal.lua` (helper module)
- Plugins load conditionally based on detection (no manual config needed)
- See docs/ARCHITECTURE.md for implementation details
