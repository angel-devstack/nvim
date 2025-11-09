return {
  "rmagatti/auto-session",
  event = "VimLeavePre", -- opcional: carga más inteligentemente
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      log_level = "error", -- menos ruido
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = {
        "~/", -- home
        "~/Downloads",
        "~/Documents",
        "~/Desktop",
        "~/Dev", -- ignora raíz de proyectos grandes
        "/tmp", -- sesiones temporales
      },
      session_lens = {
        load_on_setup = false,
        theme_conf = { border = true },
        previewer = false,
      },
    })

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap(
      "n",
      "<leader>wr",
      "<cmd>SessionRestore<CR>",
      vim.tbl_extend("force", opts, { desc = "📂 Restore session" })
    )
    keymap("n", "<leader>ws", "<cmd>SessionSave<CR>", vim.tbl_extend("force", opts, { desc = "💾 Save session" }))
    keymap(
      "n",
      "<leader>wd",
      "<cmd>SessionDelete<CR>",
      vim.tbl_extend("force", opts, { desc = "🗑️ Delete session" })
    )
    keymap(
      "n",
      "<leader>wl",
      "<cmd>Telescope session-lens search_session<CR>",
      vim.tbl_extend("force", opts, { desc = "📜 List sessions" })
    )
  end,
}
