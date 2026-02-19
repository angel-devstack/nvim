return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    signcolumn = true,
    signs = {
      add = { text = "+" },
      change = { text = "┃" },
      delete = { text = "-" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    numhl = true,
    linehl = true,
    max_file_length = 10000,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 100,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = "<summary> | <author>, <author_time:%Y-%m-%d>",
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- High-signal keymaps only (alto valor ~7)
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Prev hunk")
      map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle blame")
    end,
  },
}
