return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ui = {
      enable = true,
    },
    workspaces = {
      {
        name = "work",
        path = "~/Vaults/Harvis",
      },
    },
    wiki_link_func = "use_alias_only",
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Asegurate de establecer conceallevel correctamente para archivos markdown
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt.conceallevel = 2
      end,
    })
  end,
}
