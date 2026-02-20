-- ASDF tool path resolution helper
-- Resolves tool binaries (forge, prettier, etc.) managed by ASDF
-- Follows pattern from venv.lua for consistency

local M = {}

-- Buscar directorio de proyecto hacia arriba buscando .tool-versions
local function find_project_root()
  local cwd = vim.loop.cwd()
  local current = cwd

  while current and current ~= "/" and current ~= vim.fn.expand("~") do
    local tool_versions = current .. "/.tool-versions"
    if vim.fn.filereadable(tool_versions) == 1 then
      return current
    end
    current = vim.fn.fnamemodify(current, ":h")
  end

  return nil
end

-- Helper para resolver comando ASDF (como asdf which)
-- Retorna ruta absoluta si existe, nil si no
local function resolve_asdf_command(tool, version)
  if not version then
    return nil
  end

  -- Usar asdf que para buscar el binario
  local cmd = string.format("asdf which %s 2>&1", tool)
  local result = vim.fn.system(cmd)

  -- Verificar si es una ruta válida
  -- asdf which retorna la ruta si existe, o mensaje de error si no
  if result and result ~= "" and not string.match(result, "No version is set") and not string.match(result, "use one of") then
    local path = vim.trim(result)
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- Fallback: intentar ruta directa desde ASDF install
  local asdf_path = vim.fn.expand("~/.asdf/installs/" .. tool .. "/" .. version .. "/bin/" .. tool)
  if vim.fn.executable(asdf_path) == 1 then
    return asdf_path
  end

  return nil
end

-- Función principal: resolve solidity-lsp path (nomicfoundation-solidity-language-server)
-- Search order: 1) ASDF nodejs, 2) global npm
function M.resolve_solidity_lsp()
  -- Primero intentar shims de ASDF (más fácil)
  local lsp_shim = vim.fn.expand("~/.asdf/shims/nomicfoundation-solidity-language-server")
  if vim.fn.executable(lsp_shim) == 1 then
    return lsp_shim
  end

  -- Fallback: verificar instalación global de npm
  if vim.fn.executable("nomicfoundation-solidity-language-server") == 1 then
    return "nomicfoundation-solidity-language-server"
  end

  return nil
end

-- Función principal: resolve forge path (Foundry formatter)
-- Search order: 1) ASDF foundry, 2) global forge
function M.resolve_forge()
  -- Intentar resolver vía ASDF foundry
  -- Verificar si hay una versión de foundry instalada en .tool-versions
  if vim.fn.filereadable(find_project_root() .. "/.tool-versions") == 1 then
    -- Leer .tool-versions y buscar foundry
    local f = io.open(find_project_root() .. "/.tool-versions", "r")
    if f then
      local content = f:read("*a")
      f:close()
      for line in content:gmatch("[^\r\n]+") do
        local tool, version = line:match("^(%S+)%s+(%S+)")
        if tool == "foundry" and version then
          local forge_path = resolve_asdf_command("forge", version)
          if forge_path then
            return forge_path
          end
        end
      end
    end
  end

  -- Fallback: usar forge global de ASDF o PATH
  if vim.fn.executable("forge") == 1 then
    return "forge"
  end

  return nil
end

-- Wrapper seguro para ejecutar comando con la ruta resuelta
-- Retorna código de salida (0 = éxito)
function M.run_command(command, args)
  local cmd = command

  if args then
    cmd = cmd .. " " .. args
  end

  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  return result, exit_code
end

-- Detect tipo de proyecto (Foundry vs Hardhat)
-- Retorna "foundry" si foundry.toml existe, "hardhat" si package.json existe, nil si no se puede determinar
function M.detect_project_type()
  local project_root = find_project_root()
  if not project_root then
    return nil
  end

  -- Buscar foundry.toml
  if vim.fn.filereadable(project_root .. "/foundry.toml") == 1 then
    return "foundry"
  end

  -- Buscar package.json
  if vim.fn.filereadable(project_root .. "/package.json") == 1 then
    return "hardhat"
  end

  -- Fallback: buscar en directorios superiores hacia abajo
  local current = project_root
  while current and current ~= "/" do
    if vim.fn.filereadable(current .. "/foundry.toml") == 1 then
      return "foundry"
    end
    if vim.fn.filereadable(current .. "/package.json") == 1 then
      return "hardhat"
    end
    current = vim.fn.fnamemodify(current, ":h")
  end

  return nil
end

return M