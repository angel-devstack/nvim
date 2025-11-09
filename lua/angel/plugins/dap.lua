-- lua/angel/plugins/dap.lua
-- Configuración global de DAP para Neovim — incluye adaptadores Ruby, Python, TS/JS, Rust

return {
  "mfussenegger/nvim-dap",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "rcarriga/nvim-dap-ui", config = true },
    { "theHamsta/nvim-dap-virtual-text", config = true },
  },
  config = function()
    local dap = require("dap")

    -- Teclado / mapeos comunes
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL Open" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP Run Last" })

    -- UI setup
    local ok_ui, dapui = pcall(require, "dapui")
    if ok_ui then
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e" },
        layouts = {
          { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "right" },
          { elements = { "repl" }, size = 10, position = "bottom" },
        },
      })
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end

    local ok_vt, dapvt = pcall(require, "nvim-dap-virtual-text")
    if ok_vt then
      dapvt.setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
        commented = false,
      })
    end

    -- Carga adaptadores específicos por lenguaje
    local dap_configs = {
      "angel.plugins.dap.ruby",
      "angel.plugins.dap.python",
      "angel.plugins.dap.node",
      "angel.plugins.dap.rust",
    }
    for _, module in ipairs(dap_configs) do
      local ok, _ = pcall(require, module)
      if not ok then
        vim.notify(("DAP: módulo '%s' no cargado"):format(module), vim.log.levels.WARN)
      end
    end
  end,
}
