return {
  "jeffrydegrande/bundler-info.nvim",
  ft = { "ruby", "eruby" },
  config = function()
    local ok, bundler = pcall(require, "bundler-info")
    if not ok then
      return
    end
    bundler.setup()
  end,
}
