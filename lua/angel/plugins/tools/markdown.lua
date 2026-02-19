local terminal = require("angel.utils.terminal")

return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "VeryLazy",
  ft = { "markdown", "vimwiki" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.nvim",
  },
  opts = {
    file_types = { "markdown", "vimwiki" },
    render_modes = true,

    mermaid = {
      enabled = terminal.is_wezterm(),
      render_options = {
        theme = "default",
      },
    },

    code = {
      enabled = true,
    },
  },
}
