vim.scriptencoding = "utf-8"

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.scroll = 5 -- smooth scroll
opt.scrolloff = 6 -- 6 lines scrolling margin
opt.signcolumn = "yes"

opt.splitright = true
opt.splitbelow = true

opt.clipboard:append("unnamedplus")

opt.swapfile = false

opt.wrap = false
opt.backspace = "indent,eol,start"
opt.title = true

opt.foldmethod = "indent"
opt.foldlevel = 1

opt.mouse = "a"
opt.colorcolumn = "80,100"
