# Phase 4: Directory Restructure - Testing Guide

## 🎯 Goal
Verify that the new organized directory structure works correctly and all plugins load properly.

---

## ✅ Pre-Testing Checklist

```bash
# 1. Ensure you're on Phase 4 branch
git branch --show-current
# Should show: phase-4/directory-restructure

# 2. Check for uncommitted changes
git status
# Should be clean

# 3. Verify structure
tree -L 2 lua/angel/plugins/
# Should show 13 directories with organized plugins
```

---

## 🧪 Test Steps

### Test 1: Plugin Loading (Critical)

**Command:**
```bash
nvim --headless "+Lazy sync" +qa 2>&1 | tee /tmp/lazy-sync.log
```

**Expected Result:**
- No error messages
- Exit code 0
- All plugins sync successfully

**Verification:**
```bash
cat /tmp/lazy-sync.log | grep -i error
# Should be empty

echo $?  # exit code from nvim command
# Should be 0
```

---

### Test 2: Startup Without Errors

**Steps:**
1. Open Neovim normally:
   ```bash
   nvim
   ```

2. Check for errors on startup:
   - No error popups
   - Status line appears (lualine)
   - No "Press ENTER" prompts with errors

3. Check messages:
   ```vim
   :messages
   ```
   - Should not show any "Error" or "Failed" messages

**Expected Result:** ✅ Clean startup, no errors

---

### Test 3: Core Plugins

#### LSP (Language Server)
```bash
nvim test.rb
```

In Neovim:
```vim
:LspInfo
```

**Expected:** 
- ✅ ruby_lsp attached
- No "not executable" errors

**Test keymaps:**
- `K` on a method → hover documentation appears
- `gd` on a method → jumps to definition

---

#### Completion (nvim-cmp)

In any file, start typing:
```ruby
def hel
```

**Expected:**
- ✅ Completion popup appears
- Can navigate with `<C-j>` / `<C-k>`
- Can select with `<Tab>` or `<CR>`

---

#### Telescope (Fuzzy Finder)

```vim
:Telescope find_files
```
Or: `<leader>ff`

**Expected:**
- ✅ Telescope opens
- Can search files
- Can select with `<CR>`

---

#### File Tree (nvim-tree)

`<leader>ee`

**Expected:**
- ✅ File explorer opens on left
- Shows directory structure
- Can navigate and open files

---

### Test 4: Git Integration

In a git repo:
```vim
:Neogit
```
Or: `<leader>gs`

**Expected:**
- ✅ Neogit status opens
- Shows git status

**Test gitsigns:**
- Make a change in a tracked file
- Should see sign in gutter (left side)
- `]h` / `[h` navigate between hunks

---

### Test 5: Testing (Neotest)

Open a test file:
```bash
nvim test/controllers/home_controller_test.rb
```

Run test:
```
<leader>tt
```

**Expected:**
- ✅ Neotest executes test
- Shows test result (pass/fail)
- `<leader>to` shows output
- `<leader>ts` shows summary

---

### Test 6: DAP (Debugging)

Open a Ruby file:
```bash
nvim app/controllers/home_controller.rb
```

1. Set breakpoint: `<leader>db`
   - ✅ Breakpoint icon appears in gutter

2. Press `F5`
   - ✅ Shows debug configurations
   - Options include: Rails server, Ruby files, Minitest

3. Select "Ruby files (plain)"
   - ✅ DAP UI opens (if file is executable)
   - Scopes, Stacks, Breakpoints panels visible

---

### Test 7: Formatting

Open a Ruby file with bad formatting:
```ruby
def    foo
  x=1+2
    return   x
end
```

Run formatter: `<leader>cf`

**Expected:**
- ✅ File auto-formats
- Proper spacing applied
- No errors

---

### Test 8: Ruby-Specific Plugins

In a Rails project:
```bash
nvim app/models/user.rb
```

**Test vim-rails:**
```vim
:Rails
```
**Expected:** ✅ Rails commands available

**Test bundler:**
```vim
:Bundle
```
**Expected:** ✅ Bundler commands available

---

### Test 9: Syntax Highlighting (Treesitter)

Open a Ruby file with complex syntax:
```ruby
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

**Expected:**
- ✅ All keywords highlighted correctly
- Classes, methods, strings have distinct colors
- No plain white/gray text

**Verify treesitter:**
```vim
:TSInstallInfo
```
Should show installed parsers: ruby, lua, javascript, etc.

---

### Test 10: Editing Enhancements

**Test autopairs:**
Type: `def foo(`
**Expected:** ✅ Auto-closes with `)`

**Test surround:**
Visual select word, press `S"` (surround with quotes)
**Expected:** ✅ Word wrapped in quotes

**Test comment:**
`<leader>c<space>` (or `gcc` in normal mode)
**Expected:** ✅ Line commented

---

### Test 11: Tools & Utilities

**Test TODO comments:**
Add in file:
```ruby
# TODO: Fix this later
# FIXME: Bug here
```

```vim
:TodoTelescope
```
Or: `<leader>ft`

**Expected:** ✅ Shows all TODOs in project

**Test REST client:**
Open or create `test.http`:
```http
GET https://api.github.com/users/octocat
```

Cursor on request, press: `<leader>rr`

**Expected:** ✅ Executes HTTP request, shows response

---

### Test 12: Misc Utilities

**Test session:**
Open some files, then:
```vim
:SessionSave
```

Close Neovim, reopen in same directory:
```bash
nvim
```

**Expected:** ✅ Auto-restores previous session

**Test maximizer:**
Split windows: `<leader>wsv`
Toggle maximize: `<leader>wsm`

**Expected:** ✅ Window toggles between full and split

---

## 📋 Quick Verification Checklist

Copy and paste this into your testing notes:

```markdown
## Phase 4 Testing Results

### Critical Tests
- [ ] Plugins load without errors (Test 1)
- [ ] Neovim starts without errors (Test 2)
- [ ] LSP works (Test 3)
- [ ] Completion works (Test 3)
- [ ] Telescope works (Test 3)

### Feature Tests
- [ ] Git integration works (Test 4)
- [ ] Testing works (Test 5)
- [ ] DAP works (Test 6)
- [ ] Formatting works (Test 7)
- [ ] Ruby plugins work (Test 8)
- [ ] Treesitter syntax highlighting (Test 9)
- [ ] Editing enhancements work (Test 10)
- [ ] Tools work (Test 11)
- [ ] Utilities work (Test 12)

### Overall Status
- [ ] All tests passed
- [ ] Ready for merge
```

---

## 🐛 Troubleshooting

### Issue: Plugins not loading

**Symptom:** Error messages about missing plugins

**Solution:**
```bash
nvim --headless "+Lazy sync" +qa
# Then restart Neovim
```

---

### Issue: LSP not attaching

**Symptom:** `:LspInfo` shows no servers attached

**Check:**
```vim
:Mason
```
Verify ruby_lsp is installed

**Fix:**
```vim
:LspRestart
```

---

### Issue: Import errors

**Symptom:** Error like "module not found: angel.plugins.xxx"

**Check file paths:**
```bash
# Verify init.lua exists in category
ls -la lua/angel/plugins/completion/init.lua
ls -la lua/angel/plugins/ui/init.lua
# etc...

# Verify plugin files exist
ls -la lua/angel/plugins/completion/nvim-cmp.lua
```

**Fix:** If file is missing, check git history:
```bash
git log --all --full-history -- "lua/angel/plugins/nvim-cmp.lua"
```

---

### Issue: Keymaps not working

**Symptom:** Keymap doesn't trigger expected action

**Debug:**
```vim
:verbose map <leader>ff
```
Should show the mapping and which file defined it

**Check which-key:**
```
<leader>
```
Should show popup with available keymaps

---

## 🎯 Success Criteria

Phase 4 is ready to merge when:

1. ✅ All 12 test steps pass
2. ✅ No startup errors
3. ✅ All previously working features still work
4. ✅ Plugin organization is logical and clear
5. ✅ Init files correctly import plugins

---

## 📝 Notes

- This is a **refactoring phase** - no new features added
- All functionality should work **exactly** as before
- Only the **file organization** changed
- If any feature is broken, it's a **critical bug** that must be fixed before merge

---

## 🚀 After Testing

If all tests pass:

```bash
# Switch to main
git checkout main

# Merge Phase 4
git merge phase-4/directory-restructure --no-ff -m "Merge phase-4/directory-restructure into main

Phase 4: Directory Restructure - COMPLETED

Organized plugins into logical categories:
- 13 commits with granular file moves
- 64 plugin files organized into 13 directories
- Each category has init.lua for auto-importing
- Main init.lua updated with clear category structure

All tests passed ✅"

# Push to GitHub
git push origin main
```

---

**Testing Date:** __________  
**Tested By:** __________  
**Result:** [ ] PASS / [ ] FAIL  
**Notes:** _______________________________________
