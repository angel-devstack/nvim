-- Bootstrap y configuración principal de lazy.nvim

local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repository = "https://github.com/folke/lazy.nvim.git"

  fn.system({ "git", "clone", "--filter=blob:none", repository, "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Plugins por defecto (importa todos los módulos en lua/angel/plugins)
  spec = {
    { import = "angel.plugins" },
  },

  -- Control de performance y cheks
  defaults = {
    lazy = true, -- por defecto todos los plugins serán cargados de forma lazy a menos que especifiques lo contrario
    version = nil, -- usa nil si quieres la última versión (fija en lockfile si necesitas estabilidad)
  },

  -- Opciones de checker (busca updates)
  checker = {
    enabled = true,
    notify = false,
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  dev = {
    path = vim.fn.stdpath("config") .. "/lua", -- si trabajas plugins locales
    fallback = true,
  },

  -- Optimización: rutas de runtime a ignorar para mejorar startup
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
