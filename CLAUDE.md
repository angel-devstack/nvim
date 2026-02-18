# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Neovim configuration (Lua-based) managed as a dotfiles repo. The working directory is symlinked to `~/.config/nvim`. Plugin manager is **lazy.nvim** with all plugins lazy-loaded by default.

## Useful Commands

```bash
# Verify plugins load and sync correctly
nvim --headless "+Lazy sync" +qa

# Health check inside Neovim
:checkhealth

# Plugin management
:Lazy          # Plugin dashboard (install/update/clean)
:Mason         # LSP/DAP/formatter/linter installer

# Format Lua files
stylua lua/
```

## Architecture

**Entry point:** `init.lua` → loads `angel.core` (options + keymaps) then `angel.lazy` (bootstrap lazy.nvim + load plugins).

**Plugin organization** — `lua/angel/plugins/init.lua` imports categories via lazy.nvim's `import` mechanism:

| Directory | Purpose |
|-----------|---------|
| `plugins/lsp/` | Mason, lspconfig, schemastore |
| `plugins/dap/` | Debug adapters (Node, Python, Rust) |
| `plugins/completion/` | nvim-cmp with LSP, snippet, buffer, path sources |
| `plugins/testing/` | Neotest with rspec, pytest, jest, cargo adapters |
| `plugins/formatting/` | conform.nvim (formatters) + nvim-lint (linters) |
| `plugins/syntax/` | Treesitter + text objects |
| `plugins/ui/` | Telescope, NvimTree, lualine, which-key, alpha, trouble |
| `plugins/editing/` | autopairs, surround, comment, substitute, splitjoin |
| `plugins/ruby/` | vim-rails, bundler, cucumber, ruby-debugger |
| `plugins/git/` | Gitsigns, LazyGit, Neogit, git-conflict |
| `plugins/tools/` | REST client, Obsidian, gen.nvim, avante, markdown |
| `plugins/misc/` | auto-session, maximizer, sort, highlighted yank |

**Core config:**
- `lua/angel/core/options.lua` — vim.opt settings (2-space tabs, relative line numbers, dark theme)
- `lua/angel/core/keymaps.lua` — global keymaps (leader=`<Space>`, `jk`=Escape)
- `lua/angel/utils/` — shared utilities (path helpers)
- `lua/angel/snippets/` — custom LuaSnip snippets (Ruby, Rails)

## Coding Conventions

- **Lua formatting:** 2-space indentation (configured in `.stylua.toml`)
- **Plugin file pattern:** Each file returns a lazy.nvim spec table with lazy-loading triggers (`event`, `cmd`, `keys`, `ft`, or `cond`)
- **Keymaps:** Every keymap must include a `desc` field. Check `docs/user-guide/KEYMAP_REGISTRY.md` before adding or changing keymaps to avoid conflicts
- **Keymap prefixes:** `<leader>f` find, `<leader>w` window, `<leader>e` explorer, `<leader>g` git, `<leader>t` test, `<leader>c` code, `<leader>d` debug, `<leader>a` align, `<leader>r` REST
- **Error handling:** Use `pcall()` for optional dependencies
- **Conditional loading:** Use `cond` for context-dependent plugins (e.g., Rails plugins check for Gemfile)
- **Comments:** Some inline comments are in Spanish — this is intentional, maintain the existing language of any file you edit

## LSP Server Selection Logic

Ruby LSP has special handling in `plugins/lsp/lspconfig.lua`: it checks if `ruby-lsp` is available and no `.solargraph.yml` exists, falling back to solargraph otherwise. JSON/YAML use schemastore for enhanced schema support.

## Key Documentation

- `docs/user-guide/KEYMAP_REGISTRY.md` — authoritative keymap reference (check before adding keymaps)
- `docs/user-guide/WARP.md` — complete user guide
- `docs/user-guide/AI_KEYBINDINGS.md` — AI/LLM integration keybindings (gen.nvim, avante)
- `docs/development/CONTRIBUTING.md` — coding standards, commit conventions, branch naming
- `docs/user-guide/TROUBLESHOOTING.md` — common issues and solutions

## Commit Conventions

Conventional Commits format: `type(scope): subject`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Branch prefixes: `feature/`, `fix/`, `refactor/`, `docs/`, `test/`

## Runtime Dependencies

- `.tool-versions`: Lua 5.1, Node.js 20.17.0 (asdf/mise managed)
- External: `lazygit` (Git TUI), `ollama` (local LLM for gen.nvim)
- Mason auto-installs LSP servers, formatters, linters, and debug adapters on first launch
