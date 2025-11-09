return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gs", "<cmd>Neogit<CR>", desc = " Neogit status" },
    { "<leader>gf", "<cmd>Neogit fetch<CR>", desc = " Git fetch" },
    { "<leader>gl", "<cmd>Neogit pull<CR>", desc = " Git pull" },
    { "<leader>gp", "<cmd>Neogit push<CR>", desc = " Git push" },
    { "<leader>gP", "<cmd>Neogit push --force<CR>", desc = " Git push force" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = " Git commit" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neogit").setup({
      disable_commit_confirmation = true,
      integrations = {
        diffview = true,
        telescope = true,
      },
    })
  end,
}
