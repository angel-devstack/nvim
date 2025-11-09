return {
  "kaka-ruto/nvim-ruby-debugger",
  ft = { "ruby" }, -- Load on Ruby files
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local ok, nvim_ruby_debugger = pcall(require, "nvim-ruby-debugger")
    if not ok then
      vim.notify("nvim-ruby-debugger not loaded", vim.log.levels.ERROR)
      return
    end
    
    nvim_ruby_debugger.setup({
      rails_port = 38698,
      worker_port = 38699,
      minitest_port = 38700,
      host = "127.0.0.1",
    })
  end,
}
