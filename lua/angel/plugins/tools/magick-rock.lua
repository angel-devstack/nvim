local terminal = require("angel.utils.terminal")

return {
  "vhyrro/luarocks.nvim",
  cond = function()
    return terminal.is_wezterm()
  end,
  priority = 1001,
  opts = {
    rocks = {
      "magick",
    },
  },
}
