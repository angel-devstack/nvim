-- return {
--   -- DAP para JS/TS
--   {
--     "mxsdev/nvim-dap-vscode-js",
--     dependencies = { "mfussenegger/nvim-dap" },
--     config = function()
--       require("dap-vscode-js").setup({
--         debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
--         adapters = {
--           "pwa-node",
--           "pwa-chrome",
--           "pwa-msedge",
--           "pwa-extensionHost",
--           "node-terminal",
--         },
--       })
--     end,
--   },
--
--   -- Módulo Git
--   require("angel.plugins.git"),
--
--   -- Módulo Tests / Neotest
--   require("angel.plugins.test-neotest"),
-- }

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
