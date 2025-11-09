return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup()

    wk.register({
      -- Git
      { "<leader>g", group = " Git" },
      { "<leader>gh", group = " Hunk" },

      -- Format
      { "<leader>c", group = "🧹 Code / Format" },

      -- Testing
      { "<leader>t", group = "🧪 Test" },
    })
  end,
}
