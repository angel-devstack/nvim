return {
  "godlygeek/tabular",
  cmd = { "Tabularize" },
  keys = {
    -- Changed from <leader>ta* to <leader>a* to avoid conflict with Testing
    { "<leader>a=", ":Tabularize /=<CR>", desc = "Align by '='" },
    { "<leader>a:", ":Tabularize /:<CR>", desc = "Align by ':'" },
    { "<leader>a,", ":Tabularize /,<CR>", desc = "Align by ','" },
  },
}
