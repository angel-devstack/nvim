-- Archivo: lua/angel/plugins/formatting.lua
-- Configuración moderna de formateo automático con conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local venv = require("angel.utils.venv")

    local prettier = { "prettier" }

    -- Resolver Ruff path (prioridad .venv/bin/ruff)
    local ruff_path = venv.resolve_ruff()
    local ruff_formatter = ruff_path and { ruff_path } or "ruff_format"

    conform.setup({
      formatters_by_ft = {
        -- Lenguajes comunes
        lua = { "stylua" },
        ruby = { "rubocop" },
        python = { ruff_formatter }, -- usa resolved path
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
