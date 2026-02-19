-- lua/angel/plugins/dap/node.lua
-- Configuración moderna de DAP para Node.js / TypeScript usando vscode-js-debug

return {
  "mxsdev/nvim-dap-vscode-js",
  ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local ok_dap, dap = pcall(require, "dap")
    if not ok_dap then
      return
    end

    local ok_js, dap_vscode_js = pcall(require, "dap-vscode-js")
    if not ok_js then
      vim.notify("⚠️ No se encontró nvim-dap-vscode-js. Instálalo con Lazy o Mason.", vim.log.levels.WARN)
      return
    end

    dap_vscode_js.setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = {
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "pwa-extensionHost",
        "node-terminal",
      },
    })

    for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "🟢 Ejecutar archivo actual",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "🧪 Ejecutar Jest en archivo actual",
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
            "${file}",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "🔌 Adjuntar a proceso Node",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "🌐 Depurar en Chrome (Next.js / React)",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
        },
      }
    end
  end,
}
