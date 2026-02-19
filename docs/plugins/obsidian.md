# Obsidian Plugin

## Purpose
Obsidian provides vault integration (notes, zettelkasten) with wiki-links, backlinks, daily notes, and templates.

## Configuration
- **Plugin**: `lua/angel/plugins/tools/obsidian.lua`
- Loads with: `ft = "markdown"` + `lazy = true`

## Features

### Vault integration
- Workspaces configured: `~/Vaults/Harvis`
- Wiki-links: `[[note name]]` syntax
- Backlinks: See files linking to current note
- Daily notes: Daily.md templates
- Templates: Note templates configured

### Setup
- Uses markdown files only
- Integrates with render-markdown for preview
- Uses nvim-tree for file explorer (same as regular markdown)

## Usage
- Create notes: Use Obsidian vault structure
- Link notes: `[[note name]]`
- Backlinks view: `:ObsidianBacklinks`
- Daily notes: `:ObsidianToday`

## Notes
- Requires Obsidian vault configured in setup
- Markdown rendering: See `docs/plugins/markdown-images.md` (images, Mermaid)
- Works with nvim-tree explorer (keymap: `<leader>ee`)

---

## Links
- **Configuration**: See `lua/angel/plugins/tools/obsidian.lua`
- **Related**: `docs/plugins/markdown-images.md` (rendering, images, Mermaid)