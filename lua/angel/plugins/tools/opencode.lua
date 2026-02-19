return {
  "NickvanDyke/opencode.nvim",
  event = "VeryLazy",
  keys = {
    { "<C-a>", mode = { "n", "x" }, desc = "Ask opencode" },
    { "<C-x>", mode = { "n", "x" }, desc = "Execute opencode action" },
    { "ga", desc = "Add to opencode" },
    { "<C-.>", mode = { "n", "t" }, desc = "Toggle opencode" },
    { "<S-C-u>", mode = "n", desc = "opencode half page up" },
    { "<S-C-d>", mode = "n", desc = "opencode half page down" },
  },
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.auto_reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "x" }, "ga", function()
      require("opencode").prompt("@this")
    end, { desc = "Add to opencode" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "opencode half page up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "opencode half page down" })
    -- NOTE: Opencode uses <C-a> and <C-x> which shadows Vim's increment/decrement.
    -- The plugin suggests remapping + and - as alternatives, but we keep the
    -- standard Vim behavior. Use <leader>+ and <leader>- (from core/keymaps.lua)
    -- if you need increment/decrement while using opencode.
    --
    -- Uncomment these if you prefer + and - for increment/decrement:
    -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
  end,
}
