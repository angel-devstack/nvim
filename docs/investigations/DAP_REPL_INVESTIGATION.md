# DAP REPL Investigation

## Status: PENDING INVESTIGATION

## Issue
DAP REPL (`<leader>dr`) opens successfully but expressions evaluated in REPL don't show visible output.

## What Works
- ✅ DAP UI opens correctly
- ✅ Breakpoints work (`<leader>db`)
- ✅ Debug navigation (F5, F10, F11, F12) works
- ✅ DAP Scopes panel shows local variables
- ✅ DAP Stacks panel shows call stack
- ✅ Tests execute with debug (`<leader>tS`)

## What Needs Investigation
- ❌ REPL evaluation output not visible
- ❌ Expressions like `root_url`, `banana`, `self` don't show results in REPL
- ❓ Need to verify if output is going to different buffer/terminal

## Test Cases to Investigate

### Test 1: Simple Ruby file
```ruby
# test_dap.rb
def greet(name)
  message = "Hello, #{name}!"
  puts message  # breakpoint here
  message
end

greet("World")
```

**Steps:**
1. Open `test_dap.rb`
2. Place breakpoint on `puts message`
3. F5 → "Ruby files (plain)"
4. When stopped, open REPL: `<leader>dr`
5. Try: `name`, `message`, `self`

### Test 2: Rails test with breakpoint
```ruby
test "should get index" do
  banana = "boy"
  get root_url  # breakpoint here
  assert_response :success
end
```

**Steps:**
1. Open test file
2. Place breakpoint on `get root_url`
3. `<leader>tS` (debug nearest test)
4. When stopped, open REPL: `<leader>dr`
5. Try: `banana`, `root_url`, `response`

## Possible Causes

1. **Output buffer issue**: REPL might be writing to different buffer
2. **DAP configuration**: REPL console might need explicit configuration
3. **nvim-ruby-debugger compatibility**: Plugin might not fully support REPL evaluation
4. **rdbg version**: Older `debug` gem versions had REPL issues

## Investigation Steps

1. Check `:messages` after REPL evaluation
2. Check if output appears in `:DapShowLog`
3. Verify `debug` gem version: `gem list debug`
4. Test with Python DAP (working reference)
5. Check nvim-ruby-debugger issues: https://github.com/kaka-ruto/nvim-ruby-debugger/issues

## Workarounds (Current)

### Use DAP Scopes Panel
- Variables automatically visible in left panel when stopped at breakpoint
- No need to evaluate in REPL

### Use DAP Watches
- Add watch: `:lua require('dap.ui.widgets').hover()`
- Or add to watches panel manually

### Use Terminal REPL
- When using `bundle exec rdbg`, use terminal REPL directly
- Commands: `p variable`, `puts variable`, `info locals`

## Related Files
- `lua/angel/plugins/dap.lua`
- `lua/angel/plugins/nvim-ruby-debugger.lua`
- `DAP_TESTING_GUIDE.md`

## Priority
**LOW** - DAP core functionality works, REPL is convenience feature

## Next Steps
1. Complete Phase 4-6 first
2. Return to investigate when time permits
3. Consider filing issue with nvim-ruby-debugger if confirmed bug
