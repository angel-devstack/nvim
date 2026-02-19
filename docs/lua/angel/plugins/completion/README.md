# Completion Plugins Module

## Purpose
Completion plugin provides intelligent autocomplete from LSP, snippets, buffer contents, and file paths. Powered by nvim-cmp with multiple sources.

## Entry Point
`lua/angel/plugins/completion/init.lua` imports:
- nvim-cmp

## Load Triggers

### nvim-cmp (completion engine)
- Loads in Insert mode automatically (completion sources configured)

### Sources
- **LSP source**: Configured when LSP attaches (provides completion from Ruby LSP, Python LSP, etc.)
- **Buffer source**: Provides words from current buffer
- **Path source**: Provides file path completion

## User Actions

### Completion Keys
- `<C-n>` - Select next completion item
- `<C-p>` - Select previous completion item
- `<C-y>` - Confirm completion
- `<C-e>` - Cancel completion

### Completion Sources (auto-selected)
- LSP (language server smart completions)
- Snippets (from `lua/angel/snippets/`)
- Buffer (words in current buffer)
- Path (file system completions)

## Files

| Plugin | File | Load Trigger | Purpose |
|--------|------|--------------|---------|
| nvim-cmp | `nvim-cmp.lua` | Insert mode auto | Completion engine |
| LMP Snippets | `lua/angel/snippets/*.lua` | Auto on completion | Language snippets (Ruby, Rails) |

## Snippets

### Ruby-specific snippets
- `lua/angel/snippets/rails.lua` - Rails snippets (model routes, controller actions)
- `lua/angel/snippets/ruby.rb` - Core Ruby snippets (begin, rescue, class)

### Usage
- Type snippet prefix (e.g., `def` for function)
- Press `<Tab>` or `<C-n>` to expand
- Jump between placeholders with `<C-j>` / `<C-k>`

## Troubleshooting

**Issue**: Completion not showing
- Verify nvim-cmp loaded: `:Lazy status nvim-cmp`
- Check LSP attached: `:lua print(vim.inspect(vim.lsp.buf_get_clients()))`
- Ensure Insert mode is active

**Issue**: Snippets not expanding
- Check snippets loaded: `:lua print(vim.inspect(require('LuaSnippet'))`
- Verify luasnip configured in nvim-cmp
- Test snippet with `<C-x> <C-o>` (expand snippet)

## Future Options

- [ ] Add friendly-snippets documentation
- [ ] Create snippet templates list
- [ ] Add completion source configuration docs

---

## Links
- **Snippet examples**: See `lua/angel/snippets/` (Ruby, Rails snippets)
- **Related**: `lua/angel/plugins/completion/` (source code)