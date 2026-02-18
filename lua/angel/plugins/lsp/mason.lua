-- Configura mason.nvim y mason-lspconfig con soporte moderno (Neovim 0.11+)

return {
  "williamboman/mason.nvim",
  cmd = "Mason", -- importante para que :Mason funcione
  build = ":MasonUpdate",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    --------------------------------------------------------------------------
    -- 📦 SERVIDORES LSP A INSTALAR AUTOMÁTICAMENTE
    --------------------------------------------------------------------------
    mason_lspconfig.setup({
      ensure_installed = {
        -- Lenguajes principales
        "lua_ls",
        "ruby_lsp",
        "pyright",
        "rust_analyzer",

        -- Web / Frontend
        "html",
        "cssls",
        "emmet_ls",
        "svelte",
        "tailwindcss",
        "ts_ls",

        -- Otros
        "graphql",
        "marksman",
        "bashls",
        "dockerls",
        "jsonls",
        "yamlls",
      },
    })

    --------------------------------------------------------------------------
    -- 🧰 TOOLS: FORMATTERS, LINTERS, DEBUGGERS
    --------------------------------------------------------------------------
    mason_tool_installer.setup({
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "shfmt",
        "black",
        "isort",
        "rubocop",

        -- Linters
        "eslint_d",
        "pylint",

        -- Debuggers
        "debugpy",
        "node-debug2-adapter",
        "codelldb",
      },
    })
  end,
}
