# Image Preview Example

This file demonstrates image preview in WezTerm.

## Placeholder Image

If you have actual images in your project, they'll be rendered like this:

![Placeholder Diagram](./diagram-placeholder.png "Example diagram" | alt="Diagram placeholder")

*You can replace this with actual images from your project.*

## Inlining Images

Images work inline in markdown files when:

1. **WezTerm is detected** (auto-detects via `terminal.lua`)
2. **image.nvim loads** (conditional, WezTerm-only)
3. **magick-rock loads** (LuaRocks for ImageMagick)

## Usage

```markdown
![Image from project](path/to/image.png)

You can also add alt text and specify dimensions:

![Image with alt text](path/to/image.png "Image Description" | alt="Alternative text")
```

## How to Use

### For local images in your project
1. Add images to project folder: `project/assets/images/`
2. Reference in markdown: `![My Diagram](./assets/images/my-diagram.png)`
3. Open markdown in WezTerm → See image preview inline

### For remote images
```markdown
![Remote Image](https://example.com/image.png)
```

## Notes

- **WezTerm required**: Image preview only works in WezTerm due to terminal graphics protocol
- **iTerm**: No image preview (shows alt text instead)
- **Auto-detection**: WezTerm/iTerm detected transparently by `terminal.is_wezterm()` helper
- **Examples here are placeholders** - replace with actual images from your projects

---

## Related Documentation
- See `docs/plugins/markdown-images.md` for rendering details
- See `docs/TERMINAL_SUPPORT.md` for WezTerm vs iTerm details
- See Mermaid diagram example in `mermaid-example.md` for diagram rendering
