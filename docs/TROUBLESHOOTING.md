# Troubleshooting: Common Issues & Fixes

**Fixes for frequently encountered problems.**

---

Plugin Not Working

Issue: "Plugin not loading / keymaps not working"

Steps to fix:
1. Check plugin loads: `:Lazy status <plugin-name>`
2. Verify triggers configured: Check `event`, `cmd`, `keys`, `ft` in plugin file
3. See documentation: `docs/plugins/<plugin>.md` or `docs/lua/angel/plugins/<dir>/README.md`
4. Restart Neovim if needed: Restart Neovim after configuration changes

---

LSP Not Attaching

Issue: "LSP language servers not starting/attaching"

Steps to fix:
1. Check Mason: `:Mason` - Verify LSP server installed
2. Check Mason registry: `:MasonUpdate` - Update if needed
3. Install missing tools: Install LSP servers, formatters, linters via Mason
4. Check toolchain:
   - Ruby: `bundle which rubocop` (Bundler detection)
   - Python: `python -m venv` (venv detection)
   - Rust: Check `.tool-versions` file in project
5. Restart LSP: `<leader>rs`

Ruby-specific: see Ruby Development
Python-specific: see Python Development
General LSP: see [USER_MANUAL.md](USER_MANUAL.md) for LSP operations

---

Format/Linting Not Working

**Issue: "No auto-format on save / Ruff/linting errors"**

Steps to fix:

Auto-formatting (conform):
1. Verify conform loads: `:Lazy status conform`
2. Check formatters: `:lua print(vim.inspect(require('conform').formatters))`
3. Verify toolchain: Check if Ruff, styua, rubocop, prettier installed (Mason or system)
4. Check configuration: `lua/angel/plugins/formatting/conform.lua` - See docs/plugins/formatting/README.md

Linting (nvim-lint):
5. Verify linting loaded: `:Lazy status lint-nvim`
6. Check linters configured: Check `lua/angel/plugins/formatting/linting.lua` - See docs/plugins/formatting/README.md
7. Test manually: Run linter manually (e.g., `ruff check file)`)

Python setup:
- Verify `.venv/bin/ruff` path works: `lua print(require angel.utils.venv.resolve_ruff())`
- See `docs/plugins/formatting/README.md` (Ruff auto-detection details)

Ruby setup:
- Run in project with Gemfile: `bundle install rubocop rubocop`
- Ensure Bundler detected: Check `lua/angel/plugins/ruby/` (vim.bundler.lua has cond detection)

---

Ruby Development

**Issue: "Bundler not detecting / gem not found"**

Steps to fix:
1. Check project has `Gemfile`: `ls Gemfile` (must exist)
2. Verify Bundler config: `lua/angel/plugins/ruby/vim-bundler.lua` has `cond = function() return vim.fn.filereadable("Gemfile") == 1 end`
3. Test Bundler: `bundle which rubocop` (should return path if Gemfile present)
4. Install tools if missing: `bundle install` (installs Bundler + bundled gems)

---

Python Development

**Issue: "Ruff ENOENT errors / virtual environment not detected"**

Steps to fix:
1. Check venv path: `lua print(require("angel.utils.venv").resolve_ruff())`
2. Verify detectable venv: Check if `.venv` folder exists in project root
3. Test Python manually: `python -m venv` (should activate without errors)
4. See `lua/angel/utils/venv.lua` for venv detection code

Fix (if needed): Re-run initialization or verify `.venv/bin/ruff` exists

---

Rust Development

**Issue: "cargo not found / tool-versions missing version"**

Steps to fix:
1. Check `.tool-versions` file in project: `cat .tool-versions`
2. Verify `rust 1.92.0` (or current version) is present
3. Add to file if missing:
   ```bash
   echo "rust 1.92.0" >> .tool-versions
   ```
4. Install Rust (if not present): `brew install rust` (or system package manager)
5. Verify cargo: `which cargo`

---

Git Operations

**Issue: "Gitsigns not showing diffs / merge conflicts not detected"**

Steps to fix:

Gitsigns not showing diffs:
1. Check Gitsigns loads: `:Lazy status gitsigns`
2. Verify triggers: Should be `event = "VeryLazy" (optimized in Slice 5)
3. Restart Neovim: Lazy-loaded plugins might not be attached

Merge conflicts not detected:
1. Check git-conflict loads: `:Lazy status git-conflict`
2. Verify autocmd: Check `lua/angel/plugins/git/git-conflict.lua` for `User GitConflictDetected`
3. Test manually: Create a merge conflict in test file, verify notification appears

---

Plugin Installation Errors

**Issue: "Plugin installation failed / Lua errors"**

Steps to fix:

General:
1. Check plugin spec syntax: Verify return structure is correct (not M.config = {})
2. Verify dependencies: Ensure all dependencies listed in plugin spec
3. Check Mason: `:Mason` - Install dependencies if missing (LSP servers, etc.)
4. Restart Neovim: Sometimes requires restart after fixes

magick-rock / image.nvim:
1. Check plugin spec: Return `return { "plugin", ... }` (not M.config = {})
2. Verify cond function: Should return `return terminal.is_wezterm()` for conditional load
3. Check ImageMagick: Check magick rock installed via LuaRocks: `:lua print(require('magick').rocks)"`

See `docs/audit/POST-AUDIT-FIXES.md` for magick-rock fix details (commit e3e962e).

DAP (Debug Adapters):
1. Check adapter loaded: `:Lazy status dap-python`, `:Lazy status nvim-ruby-debugger`
2. Verify ft lazy-load config: `ft = { python }, ft = { ruby }, ft = { javascript, typescript, }`
3. Install via Mason: `:Mason` → Install debugpy, codelldb, nvim-ruby-debugger

---

Startup Performance

**Issue: "Neovim slow to start / plugins loading slowly"**

Baseline: ~156ms (post-optimization: ~260ms)

Steps to optimize:

1. Check offender trace: See `docs/audit/BASELINE.md` for startup offenders
2. Lazy-load heavy plugins: Use `event = "VeryLazy"` for non-critical plugins
3. Filetype-specific load: Use `ft = { ruby, eruby, python }` instead of `event = "VimEnter"`
4. Conditional load: Use `cond = terminal.is_wezterm()` for WezTerm-only plugins
5. See `docs/ARCHITECTURE.md` for optimization strategy

---

Plugin Keymaps Not Working

**Issue**: "My `<leader>ff` keymap is not working / shows wrong action"

Steps to fix:
1. Verify leader key set: Check `lua/angel/core/keymaps.lua` (`vim.g.mapleader = "<Space>"`)
2. Check lazy.nvim loads: `:Lazy status telescope` or `:Lazy status <plugin>`
3. Check keymap registration:
   - Check documentation for keymap: `docs/plugins/telescope.md`
   - Look in plugin file for `keys = { "<leader>ff", ... }` config
4. Check conflicts: Use `:map <leader>ff` to see mapping
5. Review keymaps in `docs/USER_MANUAL.md` for reference

---

Images Not Showing / Mermaid Not Rendering

**Issue**: "Opening markdown file shows text, no images or Mermaid diagram"

Steps to fix:

Check terminal:
1. Determine terminal: `:lua print(vim.env.TERM_PROGRAM)`
2. If "iTerm.app": Images not supported (use WezTerm for features)
3. If not WezTerm: Check config: Should be `vim.env.WEZTERM_PANE` or `vim.env.TERM_PROGRAM == "WezTerm"`

Check plugins load:
1. Check image.nvim: `:Lazy status image.nvim`
2. Check magick-rock: `:Lazy status magick-rock`
3. Verify cond configured: Check `lua/angel/plugins/tools/image.lua` for `terminal.is_wezterm()`
4. Verify Mermaid enabled: Check `lua/angel/plugins/tools/markdown.lua` for `mermaid.enabled = terminal.is_wezterm()`

Test functionality:
1. Verify terminal detection: `:lua print(require('angel.utils.terminal').is_wezterm())` (should be `true` in WezTerm)
2. Check image.nvim config: `require('angel.plugins.tools.image').opts.integration` (markdown integration set to true)
3. Test examples: Try `nvim docs/examples/markdown/mermaid-example.md` and `images-example.md`

---

## Configuration Files

### Core Configuration
- `lua/angel/core/options.lua` - Neovim core settings
- `lua/angel/core/keymaps.lua` - Global keymaps (leader=`<Space>`)
- See `docs/lua/angel/core/README.md` for details

### Plugin Configuration
- By plugin: `lua/angel/plugins/<plugin-name>.lua`
- By category: `docs/lua/angel/plugins/<category>/README.md`
- Important plugins: `docs/plugins/<plugin>.md` (e.g., Telescope, DAP, Trouble)

---

## Common Error Messages

### "command 'Lazy status plugin-name': command not found"
**Cause**: Plugin doesn't exist or typos in command
- **Fix**: Check plugin file exists: `ls lua/angel/plugins/<plugin>.lua`
- **Verify**: Use exact name with underscores (e.g., `telescope.lua`, not `telescope`)

### "lua error: module 'angel.xxx' not found"
**Cause**: Module not found or typo in require("angel.xxx") statement
- **Fix**: Check file exists: `ls lua/angel/xxx.lua`
- **Verify**: Use exact paths, check Lua syntax

### "Invalid plugin spec: { config = { ... } }"
**Cause**: Incorrect plugin spec format (M.config = {} is not valid)
- **Fix**: Use return: `return { "plugin", config = {} }` (see magick-rock fix in POST-AUDIT-FIXES.md, commit e3e962e)

### "No version is set for command cargo / No version in .tool-versions"
**Cause**: `.tool-versions` file in project missing `rust 1.92.0` line
- **Fix**: Add `rust 1.2010` (or your version) to `.tool-versions` in project

---

## Getting Help

### Documentation Navigation
- **User Manual**: `docs/USER_MANUAL.md` - How to use this configuration
- **Architecture**: `docs/ARCHITECTURE.md` - How lua/angel is organized
- **Terminal Support**: `docs/TERMINAL_SUPPORT.md` - WezTerm vs iTerm
- **Plugin Docs**: `docs/plugins/<plugin>.md` - Individual plugin documentation
- **Local Docs**: `docs/lua/angel/` - Folder-by-folder documentation

### Quick Fixes Flowchart
1. Plugin not working → `:Lazy status <plugin>` → Check triggers in plugin file
2. LSP not attaching → `:Mason` → Install tools → `<leader>rs`
3. Format/lint broken → Check Mason → `:Lazy status conform` → `:Lazy status lint-nvim`
4. Toolchain missing → Check `.tool-versions` / `.venv` / `Gemfile`
5. Images/Mermaid broken → Check WezTerm detected → `vim.env.TERM_PROGRAM`

---

## Related Resources

- **Post-Audit Fixes**: [POST-AUDIT-FIXES.md](../audit/POST-AUDIT-FIXES.md) - Recent error fixes
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md) - System organization
- **Examples**: `docs/examples/` - Mermaid/image examples

**Version:** 1.0 (Post-Audit Optimized)
**Last Updated:** 2026-02-19
