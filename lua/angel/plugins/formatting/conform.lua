-- Archivo: lua/angel/plugins/formatting.lua
-- Configuración moderna de formateo automático con conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local venv = require("angel.utils.venv")
    local asdf = require("angel.utils.asdf")

    local prettier = { "prettier" }

    -- Configurar ruff_format formatter para usar el path resuelto (.venv si existe)
    local ruff_path = venv.resolve_ruff()
    if ruff_path then
      conform.formatters.ruff_format = { command = ruff_path }
    end

    -- Configurar forge formatter para usar el path resuelto de ASDF
    local forge_path = asdf.resolve_forge()
    if forge_path then
      conform.formatters.forge_fmt = { command = forge_path }
    end

    -- Resolver formatter de Solidity basado en tipo de proyecto
    local function resolve_solidity_formatter()
      local project_type = asdf.detect_project_type()

      if project_type == "foundry" then
        return { "forge_fmt" }
      elseif project_type == "hardhat" then
        return { "prettier", "prettier-plugin-solidity" }
      else
        -- Fallback a forge si está disponible, si no prettier
        if forge_path then
          return { "forge_fmt" }
        else
          return { "prettier" }
        end
      end
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

        -- Solidity (detectar Foundry vs Hardhat automáticamente)
        solidity = resolve_solidity_formatter(),

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
