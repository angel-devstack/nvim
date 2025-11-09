require("angel.core.options")
require("angel.core.keymaps")

-- Silenciar advertencias healthcheck de which‑key
do
  local orig_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if type(msg) == "string" and msg:match("which%-key") and level == vim.log.levels.WARN then
      return
    end
    return orig_notify(msg, level, opts)
  end
end
