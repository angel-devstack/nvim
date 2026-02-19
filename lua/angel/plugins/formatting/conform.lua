-- Archivo: lua/angel/plugins/formatting.lua
-- Configuración moderna de formateo automático con conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local venv = require("angel.utils.venv")

    local prettier = { "prettier" }

    -- Configurar ruff_format formatter para usar el path resuelto (.venv si existe)
    local ruff_path = venv.resolve_ruff()
    if ruff_path then
      conform.formatters.ruff_format = { command = ruff_path }
    end

    conform.setup({
      formatters_by_ft = {
        -- Lenguajes comunes
        lua = { "stylua" },
        ruby = { "rubocop" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        dockerfile = { "dockfmt" },

        -- Web / Frontend
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        svelte = prettier,
        css = prettier,
        html = prettier,
        json = prettier,
        yaml = prettier,
        markdown = prettier,
        graphql = prettier,

        -- Fallback para otros tipos
        ["*"] = { "trim_whitespace" },
      },

      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 2000,
      },
    })

    vim.keymap.set("n", "<leader>cf", function()
      conform.format({ bufnr = vim.api.nvim_get_current_buf() })
    end, { desc = "🧹 Format current file" })
  end,
}
