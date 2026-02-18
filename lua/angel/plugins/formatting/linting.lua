-- Archivo: lua/angel/plugins/linting.lua
-- Configuración de linters automáticos usando nvim‑lint

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local venv = require("angel.utils.venv")
    local ruff_path = venv.resolve_ruff()

    -- Configurar ruff para usar la ruta resuelta (.venv si existe)
    local ruff_linter = lint.linters.ruff
    ruff_linter.cmd = ruff_path

    -- Define linters por tipo de archivo
    lint.linters_by_ft = {
      ruby = { "rubocop" },
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      -- Puedes añadir más filetypes según tu stack
    }

    -- Autocmd para ejecutar linters al guardar el archivo
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
      group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
    })
  end,
}
