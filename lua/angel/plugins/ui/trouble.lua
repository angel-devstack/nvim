return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Toggle trouble" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Todos in trouble" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
  },
}
