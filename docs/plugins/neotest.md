# Neotest Plugin

## Purpose
Neotest provides test execution framework for RSpec (Ruby), pytest (Python), Jest/Mocha (JS/TS). Run tests, view results, jump to failures.

## Configuration
- **Plugin**: `lua/angel/plugins/testing/test-neotest.lua`
- Loads with `event = "VimEnter"`

## Supported frameworks
- Ruby: RSpec, Minitest (via nvim-ruby-debugger)
- Python: pytest (via dap-python)
- JS/TS: Jest, Mocha (via nvim-dap adapters)

## Usage
- Run tests: View test results in Neovim
- Jump failures: Navigate to failing test code
- Debug tests: Uses DAP integration

## Notes
- Test framework adapters configure via Mason/RTP
- See `lua/angel/plugins/testing/` for setup
- Integration with DAP allows debugging test failures

---

## Links
- **Configuration**: See `lua/angel/plugins/testing/test-neotest.lua`