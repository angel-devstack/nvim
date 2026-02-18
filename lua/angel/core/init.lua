require("angel.core.options")
require("angel.core.keymaps")

-- Highlight on yank (built-in since Neovim 0.5)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
