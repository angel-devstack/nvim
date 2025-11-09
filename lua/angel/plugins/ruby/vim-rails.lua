return {
  "tpope/vim-rails",

  ft = { "ruby", "eruby", "haml", "slim" },

  cond = function()
    return vim.fn.filereadable("Gemfile") == 1
  end,

  cmd = { "Rails", "Rmodel", "Rview", "Rcontroller", "Rake", "Generate" },
}
