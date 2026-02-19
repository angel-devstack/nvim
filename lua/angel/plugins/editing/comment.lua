return {
  "numToStr/Comment.nvim",
  keys = {
    { "gcc", mode = "n", desc = "Comment line" },
    { "gcc", mode = "v", desc = "Comment selection" },
  },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local comment = require("Comment")
    local ok_ts, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

    local pre_hook = nil
    if ok_ts then
      pre_hook = ts_context_commentstring.create_pre_hook()
    end

    comment.setup({
      pre_hook = pre_hook,
    })
  end,
}
