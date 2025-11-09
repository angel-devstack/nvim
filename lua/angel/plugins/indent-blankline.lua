return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl", -- usar el nuevo nombre del módulo
  opts = {
    indent = {
      char = "┊", -- puedes cambiarlo por "│", "⎸", "▏" según tu gusto
    },
    scope = {
      enabled = true, -- resalta el bloque de indentación actual
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "Trouble",
        "toggleterm",
        "lazyterm",
      },
    },
  },
}
