return {
  "rest-nvim/rest.nvim",
  ft = "http", -- activa solo en archivos .http/.rest
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "http" })
      end,
    },
  },
  keys = {
    { "<leader>rr", "<Plug>RestNvim", desc = "󰢻 Run request under cursor", ft = "http" },
    { "<leader>rp", "<Plug>RestNvimPreview", desc = "󰢻 Preview curl command", ft = "http" },
    { "<leader>rl", "<Plug>RestNvimLast", desc = "󰢻 Re-run last request", ft = "http" },
  },
  config = function()
    require("rest-nvim").setup({
      result_split_horizontal = false,
      skip_ssl_verification = false,
      encode_url = true,
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      jump_to_request = false,
    })
  end,
}
