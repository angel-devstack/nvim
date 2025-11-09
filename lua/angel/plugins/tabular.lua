return {
  "godlygeek/tabular",
  cmd = { "Tabularize" },
  keys = {
    { "<leader>ta=", ":Tabularize /=<CR>", desc = "Alinear por '='" },
    { "<leader>ta:", ":Tabularize /:<CR>", desc = "Alinear por ':'" },
    { "<leader>ta,", ":Tabularize /,<CR>", desc = "Alinear por ','" },
  },
}
