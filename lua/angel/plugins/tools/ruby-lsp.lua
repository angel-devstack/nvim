-- Auto-install and configure Ruby LSP for projects
-- Ensures ruby-lsp gem is installed for the current Ruby version

return {
  "adam12/ruby-lsp.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = true, -- Auto-configs lspconfig with ruby-lsp server
}