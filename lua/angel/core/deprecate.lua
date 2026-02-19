-- lua/angel/core/deprecate.lua
-- Deprecation warnings handling

local M = {}

-- Silencia warnings de deprecación no críticos del plugin externo ruby-lsp.nvim
-- Ruby LSP funciona correctamente, solo es un warning ruidoso
function M.setup()
  local original_deprecate = vim.deprecate

  vim.deprecate = function(...)
    -- Silencia warnings de ruby-lsp.nvim usando API vieja de lspconfig
    local name = select(1, ...)
    if name and name:match("lspconfig") then
      return
    end

    -- Preserva warnings de otros deprecations
    return original_deprecate(...)
  end
end

return M