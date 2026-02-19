-- Auto-install and configure Ruby LSP for projects
-- Ensures ruby-lsp gem is installed for the current Ruby version

return {
  "adam12/ruby-lsp.nvim",
  ft = { "ruby", "eruby" },
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = true,
}
