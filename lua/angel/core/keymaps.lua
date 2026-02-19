vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap
local path_utils = require("angel.utils.path")

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tab management
keymap.set("n", "<leader>tto", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>ttx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>ttn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>ttp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>ttf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })
keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { noremap = true, silent = true })

-- Quit: Crtl+Q
keymap.set("n", "<C-q>", ":qa<CR>", { noremap = true, silent = true })

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================

-- Move between window splits using <leader> + HJKL
keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, desc = "Move to left split" })
keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, desc = "Move to bottom split" })
keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, desc = "Move to top split" })
keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, desc = "Move to right split" })

-- Tele­scope: buscar archivos
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
-- Tele­scope: buscar texto en proyecto
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })

-- Git: Estado rápido con Neogit
keymap.set("n", "<leader>gs", "<cmd>Neogit<CR>", { desc = "Neogit Status" })

-- Clipboard / Paths
keymap.set("n", "<leader>cu", path_utils.copy_absolute_file_url, { desc = "Copy absolute file URL to clipboard" })
