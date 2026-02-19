# 🔧 Troubleshooting Guide

This document contains solutions to common issues encountered with this Neovim configuration.

---

## 📋 Quick Diagnostics

Run these commands to check overall health:

```vim
:checkhealth           " Comprehensive health check
:checkhealth mason     " Check Mason installation
:checkhealth lsp       " Check LSP configuration
:LspInfo              " Check active LSP servers
:Lazy                 " Check plugin status
```

---

## 🚨 Common Issues

### LSP Server "not executable" Warning

**Symptom:**
```
⚠️ WARNING 'lua-language-server' is not executable. Configuration will not be used.
```

**Diagnosis:**
- Mason shows server installed (✓ in `:Mason`)
- `:LspInfo` shows warning but configuration looks correct
- Server binary exists but is not in PATH

**Root Cause:**
Mason installs LSP servers to `~/.local/share/nvim/mason/bin/` but this path may not be in your shell's PATH.

**Solutions:**

#### Option A: Add Mason bin to PATH (Recommended)
Add to your shell config (`~/.zshrc`, `~/.bashrc`, etc):

```bash
# Neovim Mason LSP servers
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
```

Then reload:
```bash
source ~/.zshrc  # or ~/.bashrc
```

#### Option B: Verify Mason Installation
```vim
:Mason
```
- Press `i` on the server to install
- Press `X` to uninstall and `i` to reinstall if it's stuck

#### Option C: Manual PATH Check
```bash
# Check if executable exists
ls ~/.local/share/nvim/mason/bin/lua-language-server

# Try running it manually
~/.local/share/nvim/mason/bin/lua-language-server --version
```

**Verification:**
After applying fix:
1. Restart Neovim
2. Open a Lua file
3. Run `:LspInfo` - warning should be gone
4. Press `K` over a function - hover docs should appear

---

### Plugin Load Errors

**Symptom:**
```
Error detected while processing ...
Could not load plugin: <plugin-name>
```

**Solutions:**

1. **Sync plugins:**
   ```vim
   :Lazy sync
   ```

2. **Clear cache and reinstall:**
   ```vim
   :Lazy clean
   :Lazy sync
   ```

3. **Check lazy-lock.json:**
    - Ensure it's committed and up to date
    - Delete it and run `:Lazy restore` to regenerate

4. **Check for typos in plugin specs:**
    - Review `lua/angel/plugins/` files for syntax errors
    - Look for missing commas, quotes, or brackets

---

### Conform Formatter: nested {} Syntax Error

**Symptom:**
```
conform.nvim ... The nested {} syntax to run the first formatter has been replaced by the stop_after_first option
Formatting failed on BufWritePre
```

**Diagnosis:**
- Nested table syntax like `{{ "formatter1", "formatter2" }}` is deprecated
- Conform expects flat formatter lists with `stop_after_first = true`

**Root Cause:**
Breaking change in conform.nvim: old pattern `python = { { "ruff_format", "black" } }` changed to new pattern:
```lua
python = { "ruff_format", "black" }
stop_after_first = true
```

**Current Config Status (Fixed):**
Configuration uses flat formatter lists:
```lua
python = { ruff_formatter },  -- ruff_formatter is path or command name
```
No nested arrays present.

**Verification:**
```vim
" Run conform format manually
:lua require('conform').format()
```
Should succeed without nested array error.

---

### nvim-cmp Not Working

**Symptom:**
- No completion menu appears
- Tab doesn't work
- Errors about `has_words_before`

**Solutions:**

1. **Check has_words_before function exists:**
   - Verify `lua/angel/plugins/nvim-cmp.lua` has the function defined (added in Phase 1)

2. **Check LSP is running:**
   ```vim
   :LspInfo
   ```
   - At least one server should be attached

3. **Check sources:**
   ```vim
   :lua print(vim.inspect(require('cmp').get_config().sources))
   ```
   Should show: nvim_lsp, luasnip, buffer, path

4. **Reinstall completion plugins:**
   ```vim
   :Lazy restore cmp-nvim-lsp
   :Lazy restore cmp-buffer
   :Lazy restore cmp-path
   ```

---

### DAP Debugger Not Working

**Symptom:**
- `<F5>` doesn't start debugging
- "No configuration found" error
- Breakpoints don't work

**Solutions:**

1. **Check adapter installed:**
   ```vim
   :Mason
   ```
   - Verify language-specific adapter installed:
     - Ruby: `debug` gem or Mason's debugger
     - Python: `debugpy` 
     - JS/TS: `node-debug2-adapter`
     - Rust: `codelldb`

2. **Check DAP setup:**
   ```bash
   # Ruby
   which rdbg
   gem list | grep debug

   # Python
   which debugpy
   pip show debugpy

   # Node
   which node
   ```

3. **Check configuration loaded:**
   ```vim
   :lua print(vim.inspect(require('dap').configurations))
   ```

4. **Try manual adapter:**
   ```vim
   :lua require('dap').run(<configuration>)
   ```

---

### Git Integration Issues

**Symptom:**
- `<leader>gs` doesn't open Neogit
- `<leader>lg` doesn't open LazyGit
- Gitsigns not showing

**Solutions:**

1. **LazyGit not installed:**
   ```bash
   brew install jesseduffield/lazygit/lazygit
   ```

2. **Not in a git repository:**
   ```bash
   git status
   # Should show you're in a repo
   ```

3. **Check plugin loaded:**
   ```vim
   :Lazy load neogit.nvim
   :Lazy load lazygit.nvim
   :Lazy load gitsigns.nvim
   ```

---

### Keymap Conflicts

**Symptom:**
- Keymap doesn't work
- Delay before keymap triggers
- Wrong action happens

**Diagnosis:**
```vim
:verbose map <leader>ta
```
Shows which plugin/file defined the keymap.

**Solutions:**

1. **Check KEYMAP_REGISTRY.md** (created in Phase 2)
   - Verify no conflicts
   - Use proper prefix

2. **Check which-key timeout:**
   - Default timeout is 500ms
   - If multiple keymaps start with same prefix, which-key waits

3. **Reload keymaps:**
   ```vim
   :source ~/.config/nvim/lua/angel/core/keymaps.lua
   ```

---

### Mason Installation Failures

**Symptom:**
```
mason.nvim: Failed to install <package>
```

**Solutions:**

1. **Check internet connection:**
   ```bash
   ping github.com
   ```

2. **Check Mason log:**
   ```vim
   :Mason
   ```
   Press `g?` for help, `X` to view logs

3. **Manual install retry:**
   ```vim
   :MasonInstall <package>
   :MasonUninstall <package>
   :MasonInstall <package>
   ```

4. **Check disk space:**
   ```bash
   df -h ~/.local/share/nvim
   ```

5. **Clear Mason cache:**
   ```bash
   rm -rf ~/.local/share/nvim/mason
   ```
   Then reopen Neovim and run `:Mason` to reinstall.

---

### Treesitter Parsing Errors

**Symptom:**
```
Error detected: treesitter/highlighter: Error executing lua
```

**Solutions:**

1. **Update parsers:**
   ```vim
   :TSUpdate
   ```

2. **Reinstall specific parser:**
   ```vim
   :TSInstall! lua
   :TSInstall! ruby
   ```

3. **Check health:**
   ```vim
   :checkhealth nvim-treesitter
   ```

4. **Clear parser cache:**
   ```bash
   rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/
   ```

---

### Slow Startup

**Symptom:**
- Neovim takes >2 seconds to start
- Lag when opening files

**Diagnosis:**
```vim
:Lazy profile
```
Shows which plugins are slow to load.

**Solutions:**

1. **Review lazy-loading:**
   - Check plugins use `cmd`, `ft`, `keys`, or `event`
   - Avoid `lazy = false` unless necessary

2. **Disable unused plugins:**
   - Comment out in plugin specs
   - Run `:Lazy clean`

3. **Check for expensive autocmds:**
   ```vim
   :autocmd
   ```

4. **Profile startup:**
   ```bash
   nvim --startuptime startup.log
   cat startup.log | sort -k2 -n | tail -20
   ```

---

### Python Ruff: "ENOENT" Error or Not Found

**Symptom:**
```
ERROR: ENOENT: no such file or directory
Ruff no encontrado - usa virtualenv para instalar ruff
"ruff" executable not found
```

**Diagnosis:**
- Ruff works in terminal after activating venv
- Neovim can't find Ruff when opened without venv
- `.venv/bin/ruff` exists but isn't used

**Root Cause:**
Neovim's PATH doesn't include `.venv/bin/` when venv isn't activated in the shell.

**Solution Built-in (Automatic):**
The configuration includes automatic Ruff path resolution:

1. Searches upward from current directory for `.venv`
2. Uses `.venv/bin/ruff` if found and executable
3. Falls back to global Ruff if available
4. Non-blocking error if Ruff not found

**Verification:**
```vim
:lua print(require('angel.utils.venv').resolve_ruff())
```
Should show path to `.venv/bin/ruff` or global `ruff` path.

**Manual Workaround (if automatic doesn't work):**
```bash
# Activate venv before opening Neovim
source .venv/bin/activate
nvim
```

**Fix for Future Projects:**
- Configuration already implements automatic resolution
- No manual venv activation required after this fix

---

## 🆘 Getting More Help

### Useful Commands

```vim
:messages          " Show recent messages
:Lazy log          " Show lazy.nvim logs  
:LspLog            " Show LSP client logs
:checkhealth       " Run all health checks
:verbose set <option>?   " Check where option was set
```

### Debug Mode

Start Neovim with verbose logging:
```bash
nvim -V9nvim.log
```

Check the log:
```bash
tail -f nvim.log
```

### Reset to Clean State

**⚠️ Warning: This removes all plugins and data**

```bash
# Backup first
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Clone config fresh
git clone <your-repo> ~/.config/nvim
nvim
# Run :Lazy sync
```

---

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)

---

**Last Updated:** 2025-11-09  
**Related:** See `WARP.md` for configuration details, `PHASE_TRACKING.md` for known issues
