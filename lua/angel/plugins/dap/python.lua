-- lua/angel/plugins/dap/python.lua
return {
  "mfussenegger/nvim-dap-python",
  ft = { "python" },
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local ok, dap_python = pcall(require, "dap-python")
    if not ok then
      return
    end
    dap_python.setup("python", { console = "integratedTerminal" })
  end,
}
