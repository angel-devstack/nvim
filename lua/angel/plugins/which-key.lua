return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup()

    -- Register keymap groups to show in which-key
    wk.add({
      -- Find/Files
      { "<leader>f", group = "�� Find" },
      
      -- Window/Workspace
      { "<leader>w", group = "�� Window/Workspace" },
      { "<leader>wt", group = "���� Tabs" },
      { "<leader>ws", group = "�� Splits" },
      
      -- Explorer
      { "<leader>e", group = "�� Explorer" },
      
      -- Git
      { "<leader>g", group = "�� Git" },
      { "<leader>gh", group = "�� Hunk" },
      
      -- Testing
      { "<leader>t", group = "🧪 Test" },
      
      -- Code/Format
      { "<leader>c", group = "🧹 Code" },
      
      -- Debug
      { "<leader>d", group = "�� Debug" },
      
      -- Align
      { "<leader>a", group = "�� Align" },
      
      -- Rest/HTTP
      { "<leader>r", group = "�� Rest/HTTP" },
    })
  end,
}
