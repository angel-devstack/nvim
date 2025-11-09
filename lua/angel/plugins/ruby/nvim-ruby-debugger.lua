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

    -- Fallback configuration for plain Ruby files (non-Rails)
    local dap = require("dap")
    if not dap.configurations.ruby then
      dap.configurations.ruby = {}
    end
    
    -- Add simple Ruby file execution if not already present
    local has_ruby_files = false
    for _, config in ipairs(dap.configurations.ruby) do
      if config.name and config.name:match("Ruby files") then
        has_ruby_files = true
        break
      end
    end
    
    if not has_ruby_files then
      table.insert(dap.configurations.ruby, {
        type = "ruby",
        name = "Ruby files (plain)",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
      })
    end
  end,
}
