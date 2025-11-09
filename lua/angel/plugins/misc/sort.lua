return {
  "sQVe/sort.nvim",
  cmd = { "Sort", "SortLines", "SortWords" }, -- carga bajo demanda
  keys = {
    { "<leader>so", "<cmd>Sort<CR>", desc = "Sort selection" },
  },
  config = function()
    require("sort").setup()
  end,
}
