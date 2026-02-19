local M = {}

local terminal = require("angel.utils.terminal")

M.config = {
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

return M
