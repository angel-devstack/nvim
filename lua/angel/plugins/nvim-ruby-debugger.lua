return {
  "kaka-ruto/nvim-ruby-debugger",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local nvim_ruby_debugger = require("nvim-ruby-debugger")
    nvim_ruby_debugger.setup({
      rails_port = 38698,
      worker_port = 38699,
      minitest_port = 38700,
      host = "127.0.0.1",
    })
  end,
}
