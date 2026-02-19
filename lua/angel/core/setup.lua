-- lua/angel/core/setup.lua
-- Core setup initialization

local M = {}

function M.setup()
  -- Silencia warnings de deprecación del plugin externo ruby-lsp.nvim
  -- Ruby LSP funciona correctamente, usa API vieja de lspconfig
  local ok, deprecate = pcall(require, "angel.core.deprecate")
  if ok then
    deprecate.setup()
  end
end

return M