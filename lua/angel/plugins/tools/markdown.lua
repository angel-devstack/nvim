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

    -- 🔥 ESTA ES LA PARTE CLAVE: activar Mermaid
    mermaid = {
      enabled = true,
      render_options = {
        theme = "default", -- podés elegir: default / dark / neutral
      },
    },

    -- opcional, pero recomendable
    code = {
      enabled = true,
    },
  },
}
