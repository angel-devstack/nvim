-- Virtual environment path resolution helper
-- Resolves tool binaries (ruff, rubocop, etc.) in project venv or globally

local M = {}

-- Buscar .venv hacia arriba desde cwd
local function find_venv()
  local cwd = vim.loop.cwd()
  local current = cwd

  while current and current ~= "/" and current ~= vim.fn.expand("~") do
    local venv_path = current .. "/.venv"
    local bin_path = venv_path .. "/bin/"
    local ruff_path = bin_path .. "ruff"

    -- Verificar si .venv existe Y ruff existe dentro
    if vim.fn.isdirectory(venv_path) > 0 and vim.fn.executable(ruff_path) == 1 then
      return venv_path
    end

    current = vim.fn.fnamemodify(current, ":h")
  end

  return nil, nil
end

-- Función principal: resolve Ruff path
-- Search order: 1) .venv/bin/ruff, 2) global ruff
function M.resolve_ruff()
  local venv_path = find_venv()

  if venv_path then
    local ruff_path = venv_path .. "/bin/ruff"
    if vim.fn.executable(ruff_path) == 1 then
      return ruff_path
    end
  end

  -- Fallback: usar ruff global
  if vim.fn.executable("ruff") == 1 then
    return "ruff"
  end

  -- Ruff no encontrado
  return nil
end

-- Wrapper seguro para ejecutar Ruff con el path resuelto
-- Retorna true si éxito, false si falla
function M.run_ruff(cmd_args)
  local ruff_path = M.resolve_ruff()

  if not ruff_path then
    -- Ruff no encontrado, notificar pero no bloquear
    vim.notify("Ruff no encontrado - usa virtualenv para instalar ruff", vim.log.levels.WARN)
    return false
  end

  local ruff_cmd = { ruff_path, unpack(cmd_args or {}) }
  local exit_code = vim.fn.system(ruff_cmd)

  if exit_code ~= 0 then
    vim.notify("Ruff falló con código " .. exit_code, vim.log.levels.ERROR)
    return false
  end

  return true
end

return M
