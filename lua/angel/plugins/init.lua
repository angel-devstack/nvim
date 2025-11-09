-- lua/angel/plugins/init.lua
return {
  -- Plugins DAP
  { import = "angel.plugins.dap" },

  -- Plugins Git
  { import = "angel.plugins.git" },

  -- Plugins LSP
  { import = "angel.plugins.lsp" },

  -- Resto de plugins generales (cada archivo .lua en plugins/)
  { import = "angel.plugins" },
}
