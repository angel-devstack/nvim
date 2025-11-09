return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "BufReadPre",
  ft = { "markdown", "vimwiki" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.nvim",
  },
  opts = {
    file_types = { "markdown", "vimwiki" },
    render_modes = true,
  },
}

