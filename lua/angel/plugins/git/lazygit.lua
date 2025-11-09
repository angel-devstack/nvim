return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  keys = {
    { "<leader>lg", "<cmd>LazyGit<CR>", desc = " Open LazyGit" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.g.lazygit_floating_window_winblend = 10
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_use_neovim_remote = 1
  end,
}
