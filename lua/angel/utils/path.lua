local M = {}

function M.copy_absolute_file_url()
  local file = vim.fn.expand("%:p")

  if file == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.WARN)
    return
  end

  -- Normalizar path para URL (especialmente en macOS/Linux)
  local url = "file://" .. file

  -- Copiar al clipboard del sistema
  vim.fn.setreg("+", url)

  vim.notify("Copied to clipboard:\n" .. url, vim.log.levels.INFO)
end

return M
