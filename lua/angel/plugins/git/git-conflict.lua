return {
  "akinsho/git-conflict.nvim",
  dependencies = {
    "yorickpeterse/nvim-pqf",
  },
  version = "*",
  config = function()
    require("pqf").setup()
    require("git-conflict").setup({
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = true,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictDetected",
      callback = function()
        vim.notify("⚠️ Conflict detected in file: " .. vim.api.nvim_buf_get_name(0))
        vim.cmd("LspStop")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictResolved",
      callback = function()
        vim.cmd("LspRestart")
      end,
    })
  end,
}
