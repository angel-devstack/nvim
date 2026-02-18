-- Venv hook for Python LSP - project-aware venv detection
-- Only affects Python files, detects .venv, uses appropriate pythonPath
-- Integrates with venv-lsp.nvim for automatic detection

local M = {}

function M.setup()
  local lspconfig = require("lspconfig")

  local log_prefix = "[VenvHook] "

  local function log(msg)
    vim.notify(log_prefix .. msg, vim.log.levels.INFO)
  end

  -- Buscar venv en común (.venv, .direnv, etc.)
  local function find_venv()
    local cwd = vim.loop.cwd()

    -- Buscar .venv primero
    local venv_path = cwd .. "/.venv"
    if vim.fn.isdirectory(venv_path) > 0 then
      return venv_path, ".venv"
    end

    -- Buscar venv directory por nombre
    for _, dir in ipairs({".direnv", "venv", ".virtualenv"}) do
      venv_path = cwd .. "/" .. dir
      if vim.fn.isdirectory(venv_path) > 0 then
        return venv_path, dir
      end
    end

    -- Buscar venv en directorios ocultos
    local uv_path = cwd .. ".uv"
    if vim.fn.isdirectory(uv_path) > 0 then
      -- uv usa un sistema diferente, verificar si hay python dentro
      local python_path = uv_path .. "/bin/python"
      if vim.fn.executable(python_path) == 1 then
        return uv_path, ".uv"
      end
    end

    return nil, nil
  end

  -- Configurar pyright con pythonPath del venv
  local venv_path, venv_type = find_venv()

  if venv_path and venv_type then
    -- Encontró venv, configurar pyright
    local python_bin = venv_path .. "/bin/python"
    if vim.fn.executable(python_bin) == 1 then
      log("Found " .. venv_type .. " at " .. venv_path .. ", using pythonPath")

      lspconfig.pyright.setup({
        settings = {
          python = {
            pythonPath = python_bin,
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      log("Configured: pyright with pythonPath from " .. venv_type)
    else
      log("Found " .. venv_type .. " but no python binary, using system python")
    end
  else
    -- No venv encontrado, usar python del PATH (asdf shims si en PATH)
    log("No venv found, using python from PATH (asdf shims if available)")
    lspconfig.pyright.setup({})
  end
end

return M