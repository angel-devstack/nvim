-- Automatically detect and use Python virtual environments for LSP
-- Integrates with pyright/basedpyright to set correct pythonPath

return {
  "jglasovic/venv-lsp.nvim",
  version = "*", -- Use latest version
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("venv-lsp").setup({
      default_venv = nil, -- Don't set default, let it auto-detect
      search_venv = true,  -- Enable automatic venv detection
    })
  end,
}