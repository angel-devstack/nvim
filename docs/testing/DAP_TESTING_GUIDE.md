# 🐛 DAP Testing Guide

**Complete guide to test Debug Adapter Protocol (DAP) functionality after Phase 3 consolidation.**

---

## 📋 Pre-Testing Checklist

### 1. Verify Dependencies Installed

```bash
# Ruby/Rails
gem list | grep debug
# Should show: debug (1.x.x) or similar

# Python  
pip show debugpy
# Should show package info

# Node/JS
which node
# Should show path to node

# Rust
rustc --version
cargo --version
```

### 2. Check Mason Installation

Open Neovim:
```vim
:Mason
```

Verify these are installed (✓):
- `debugpy` (Python)
- `node-debug2-adapter` (Node/JS)
- `codelldb` (Rust)

---

## 🧪 TESTING PHASE 3 CHANGES

### What Changed in Phase 3?

1. ✅ Removed `nvim-dap-ui.lua` (redundant with dap.lua)
2. ✅ Removed `nvim-dap-virtual-text.lua` (redundant with dap.lua)
3. ✅ Simplified `dap.lua` (removed manual adapter loading)
4. ✅ Consolidated Ruby debugging to `nvim-ruby-debugger`

### Expected Behavior

**Should still work:**
- ✅ DAP UI opens automatically when debugging starts
- ✅ Virtual text shows variable values inline
- ✅ All keymaps work (F5, F10, F11, F12, <leader>db, <leader>dr, <leader>dl)
- ✅ Language adapters load correctly

**Should NOT happen:**
- ❌ No duplicate DAP plugin loading
- ❌ No warnings about missing adapters
- ❌ No UI flickering or duplicate windows

---

## 🔴 TEST 1: Basic DAP Functionality

### Create Test File

```bash
# Create a simple Ruby file
cat > /tmp/test_dap.rb << 'EOF'
def greet(name)
  message = "Hello, #{name}!"
  puts message
  message
end

result = greet("World")
puts "Result: #{result}"
EOF
```

### Test Steps

1. **Open file in Neovim:**
   ```bash
   nvim /tmp/test_dap.rb
   ```

2. **Set breakpoint on line 3:**
   - Move cursor to line 3 (`puts message`)
   - Press `<leader>db`
   - You should see a breakpoint icon in the sign column (🔴 or similar)

3. **Start debugging:**
   - Press `<F5>`
   - DAP UI should open automatically on the right side
   - Execution should stop at line 3

4. **Verify UI panels:**
   - Right side should show:
     * Scopes (variables)
     * Breakpoints
     * Stacks (call stack)
     * Watches
   - Bottom should show REPL

5. **Check variable values:**
   - Look for `name` variable in Scopes panel
   - Should show: `name = "World"`
   - Virtual text should appear inline showing variable values

6. **Test step controls:**
   - Press `<F10>` (step over) → should move to next line
   - Press `<F11>` (step into) → if there's a function call
   - Press `<F12>` (step out) → return from function
   - Press `<F5>` (continue) → run to next breakpoint or end

7. **Test REPL:**
   - Press `<leader>dr` to open REPL
   - Type: `p name` and press Enter
   - Should print the value of `name`

8. **Expected result:**
   - ✅ All steps work without errors
   - ✅ UI appears and shows correct data
   - ✅ No duplicate windows

---

## 🌿 TEST 2: Ruby/Rails Debugging (nvim-ruby-debugger)

### Understanding nvim-ruby-debugger

This plugin provides **3 debugging modes**:

1. **Standard debugging** (files)
2. **Rails server attach** (port 38698)
3. **Background workers** (Sidekiq/etc, port 38699)
4. **Minitest** (port 38700)

### Test 2A: Standard Ruby File Debugging

**Already tested in TEST 1** ✅

### Test 2B: Rails Server Attach

**Prerequisites:**
- Rails project with `debug` gem
- Add to Gemfile: `gem 'debug', group: :development`
- Run `bundle install`

**Steps:**

1. **Start Rails server with debugger:**
   ```bash
   # In your Rails project root
   rdbg -n --open --port 38698 -- bundle exec rails server
   ```
   
   You should see:
   ```
   DEBUGGER: Debugger can attach via TCP/IP (127.0.0.1:38698)
   ```

2. **Add debugger statement in controller:**
   ```ruby
   # app/controllers/home_controller.rb
   class HomeController < ApplicationController
     def index
       debugger  # <-- Add this
       @message = "Hello from Rails"
       render json: { message: @message }
     end
   end
   ```

3. **Attach from Neovim:**
   ```vim
   :lua require('nvim-ruby-debugger').attach_rails_server()
   ```
   
   Or check `:DapContinue` configurations for "Attach to Rails server"

4. **Trigger the breakpoint:**
   - In browser or curl: `curl http://localhost:3000/`
   - Neovim should switch to debug mode
   - Should stop at `debugger` line

5. **Verify:**
   - ✅ DAP UI opens
   - ✅ Shows controller context (variables, request params)
   - ✅ Can step through code
   - ✅ Can inspect `@message`, `params`, etc.

### Test 2C: Background Worker Debugging

**For Sidekiq or similar workers:**

1. **Start worker with debugger:**
   ```bash
   rdbg -n --open --port 38699 -- bundle exec sidekiq
   ```

2. **Add debugger in worker:**
   ```ruby
   class MyWorker
     include Sidekiq::Worker
     
     def perform(arg)
       debugger  # <-- Add this
       puts "Processing: #{arg}"
     end
   end
   ```

3. **Attach from Neovim:**
   ```vim
   :lua require('nvim-ruby-debugger').attach_worker()
   ```

4. **Trigger worker:**
   ```ruby
   # In Rails console
   MyWorker.perform_async("test")
   ```

5. **Verify:**
   - ✅ Stops at debugger in worker code
   - ✅ Can inspect worker context

### Test 2C: Minitest Debugging

1. **Start minitest with debugger:**
   ```bash
   rdbg -n --open --port 38700 -- bundle exec rails test
   ```

2. **Add debugger in test:**
   ```ruby
   # test/models/user_test.rb
   class UserTest < ActiveSupport::TestCase
     test "something" do
       user = User.new
       debugger  # <-- Add this
       assert user.valid?
     end
   end
   ```

3. **Should attach automatically** when test runs

---

## 🐍 TEST 3: Python Debugging

### Create Test File

```python
# /tmp/test_dap.py
def calculate(a, b):
    result = a + b
    print(f"Result: {result}")
    return result

def main():
    x = 5
    y = 10
    total = calculate(x, y)
    print(f"Total: {total}")

if __name__ == "__main__":
    main()
```

### Test Steps

1. **Open in Neovim:**
   ```bash
   nvim /tmp/test_dap.py
   ```

2. **Set breakpoint on line 3** (`result = a + b`)

3. **Press `<F5>`**
   - Should prompt for configuration
   - Select: "Python: Current File"

4. **Verify:**
   - ✅ Stops at breakpoint
   - ✅ Shows variables: `a`, `b`
   - ✅ Virtual text shows values
   - ✅ Can step through with F10/F11

---

## 🟨 TEST 4: JavaScript/TypeScript Debugging

### Create Test File

```javascript
// /tmp/test_dap.js
function greet(name) {
    const message = `Hello, ${name}!`;
    console.log(message);
    return message;
}

const result = greet("JavaScript");
console.log(`Result: ${result}`);
```

### Test Steps

1. **Open in Neovim:**
   ```bash
   nvim /tmp/test_dap.js
   ```

2. **Set breakpoint on line 3**

3. **Press `<F5>`**
   - Select: "Node: Launch Current File"

4. **Verify:**
   - ✅ Stops at breakpoint
   - ✅ Shows variables
   - ✅ Can step through

---

## 🦀 TEST 5: Rust Debugging

### Create Test File

```rust
// /tmp/test_dap.rs
fn greet(name: &str) -> String {
    let message = format!("Hello, {}!", name);
    println!("{}", message);
    message
}

fn main() {
    let result = greet("Rust");
    println!("Result: {}", result);
}
```

### Test Steps

1. **Compile first:**
   ```bash
   rustc /tmp/test_dap.rs -o /tmp/test_dap
   ```

2. **Open in Neovim:**
   ```bash
   nvim /tmp/test_dap.rs
   ```

3. **Set breakpoint on line 3**

4. **Press `<F5>`**
   - Select: "Rust: Debug"

5. **Verify:**
   - ✅ Stops at breakpoint
   - ✅ Shows variables with correct Rust types
   - ✅ Can step through

---

## 🧪 TEST 6: Neotest + DAP Integration

**Test debugging a test with DAP:**

### Ruby/RSpec Example

1. **Create test file:**
   ```ruby
   # /tmp/example_spec.rb
   RSpec.describe "Math" do
     it "adds numbers" do
       a = 5
       b = 10
       result = a + b
       expect(result).to eq(15)
     end
   end
   ```

2. **Open in Neovim:**
   ```bash
   nvim /tmp/example_spec.rb
   ```

3. **Set cursor on test** (line with `it "adds numbers"`)

4. **Debug test:**
   - Press `<leader>tS` (debug nearest test with DAP)

5. **Verify:**
   - ✅ Test starts in debug mode
   - ✅ Can set breakpoints in test
   - ✅ Can inspect test variables

---

## ✅ SUCCESS CRITERIA

After completing all tests, verify:

### Core Functionality
- [x] DAP UI opens automatically when debugging starts
- [x] Virtual text shows variable values inline
- [x] All keymaps work correctly
- [x] No error messages about missing plugins
- [x] No warnings about duplicate loading

### Language Support
- [x] Ruby: Standard debugging works
- [x] Ruby: Rails server attach works (if tested with Rails project)
- [x] Python: Debugging works
- [x] JavaScript: Debugging works
- [x] Rust: Debugging works (if Rust installed)

### UI/UX
- [x] Breakpoint icons appear in sign column
- [x] Scopes panel shows variables
- [x] Call stack panel shows correct trace
- [x] REPL is accessible and functional
- [x] Virtual text displays inline values
- [x] UI closes cleanly when debugging ends

### Integration
- [x] Neotest can debug tests via `<leader>tS`
- [x] No conflicts with other plugins
- [x] Session persists across multiple debug runs

---

## 🚨 TROUBLESHOOTING

### Issue: "No configuration found"

**Solution:**
```vim
:lua print(vim.inspect(require('dap').configurations))
```
Should show configurations for ruby, python, etc.

If empty, check:
```vim
:Lazy load nvim-dap
:Lazy load nvim-ruby-debugger
```

### Issue: DAP UI doesn't open

**Check:**
```vim
:lua print(vim.inspect(require('dapui')))
```
Should not error.

**Force open:**
```vim
:lua require('dapui').open()
```

### Issue: Rails server won't attach

**Verify:**
1. Server is running with `rdbg -n --open --port 38698`
2. Check port: `lsof -i :38698`
3. Check debugger gem: `bundle show debug`

**Manual test:**
```bash
telnet 127.0.0.1 38698
```
Should connect without error.

### Issue: Virtual text not showing

**Check plugin loaded:**
```vim
:lua print(vim.inspect(require('nvim-dap-virtual-text')))
```

**Check enabled:**
```vim
:lua print(require('nvim-dap-virtual-text').config.enabled)
```
Should return `true`.

---

## 📊 TESTING REPORT TEMPLATE

```markdown
## Phase 3 DAP Testing Report

**Date:** [DATE]
**Tester:** [YOUR NAME]

### TEST 1: Basic DAP Functionality
- [ ] Breakpoint set successfully
- [ ] F5 starts debugging
- [ ] DAP UI opens
- [ ] Variable inspection works
- [ ] Step controls work (F10, F11, F12)
- [ ] REPL accessible

**Notes:** 

### TEST 2: Ruby/Rails Debugging
- [ ] Standard file debugging works
- [ ] Rails server attach works (if applicable)
- [ ] Worker debugging works (if applicable)
- [ ] Minitest debugging works (if applicable)

**Notes:**

### TEST 3-5: Other Languages
- [ ] Python debugging works
- [ ] JavaScript debugging works
- [ ] Rust debugging works (if applicable)

**Notes:**

### TEST 6: Neotest Integration
- [ ] <leader>tS debugs test correctly

**Notes:**

### Issues Found
[List any issues encountered]

### Conclusion
- [ ] ✅ ALL TESTS PASSED - Ready to merge
- [ ] ⚠️ MINOR ISSUES - Merge with notes
- [ ] ❌ BLOCKING ISSUES - Do not merge

**Overall Assessment:**
[Your assessment]
```

---

## 🎯 NEXT STEPS AFTER TESTING

1. **If all tests pass:**
   - Fill out testing report
   - Merge phase-3/dap-consolidation to main
   - Push to GitHub
   - Proceed to Phase 4

2. **If issues found:**
   - Document issues in PHASE_TRACKING.md
   - Create fix commits in phase-3 branch
   - Re-test
   - Then merge

---

**Related Files:**
- Main DAP config: `lua/angel/plugins/dap.lua`
- Ruby debugger: `lua/angel/plugins/nvim-ruby-debugger.lua`
- Adapter configs: `lua/angel/plugins/dap/` directory
- Troubleshooting: `TROUBLESHOOTING.md`
- Phase tracking: `PHASE_TRACKING.md`
