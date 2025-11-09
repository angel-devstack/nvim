-- lua/angel/plugins/dap/ruby.lua
return {
  "suketa/nvim-dap-ruby",
  ft = { "ruby" },
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local ok, dap_ruby = pcall(require, "dap-ruby")
    if not ok then
      return
    end
    dap_ruby.setup()
  end,
}
