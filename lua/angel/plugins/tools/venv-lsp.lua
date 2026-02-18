-- Automatically detect and use Python virtual environments for LSP
-- Integrates with pyright/basedpyright to set correct pythonPath

return {
  "jglasovic/venv-lsp.nvim",
  version = "*", -- Use latest version
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- venv-lsp.nvim config - no manual setup needed
    -- Plugin automatically handles venv detection when loaded
  end,
}