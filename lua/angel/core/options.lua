vim.scriptencoding = "utf-8"

-- Suppress deprecation warnings (Neovim 0.10+ API changes)
vim.deprecate = function() end

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Número de línea
opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Interfaz
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- Swap / Backup
opt.swapfile = false

-- UI
opt.wrap = false
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
opt.title = true

-- Fold
opt.foldmethod = "indent" -- indent
opt.foldlevel = 1

-- Compatibilidad netrw
vim.cmd("let g:netrw_liststyle = 3")
