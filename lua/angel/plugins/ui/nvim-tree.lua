return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeCollapse" },
  keys = {
    { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File explorer" },
    { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Focus Current file" },
    { "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse Explorer" },
    { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh Explorer" },
  },

  config = function()
    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local nvimtree = require("nvim-tree")
    nvimtree.setup({
      view = {
        width = 30,
        relativenumber = true,
      },

      renderer = {
        root_folder_label = function(path)
          local parts = vim.fn.split(path, "/") -- Divide la ruta en partes por "/"
          local count = #parts -- Cuenta cuántos niveles hay en la ruta
          if count >= 2 then
            return table.concat({ parts[count - 1], parts[count] }, "/") -- Retorna los dos últimos
          else
            return path -- Si la ruta tiene menos de dos niveles, devuelve todo
          end
        end,
        indent_markers = {
          enable = true,
        },
        icons = {
          show = { file = true, folder = true, folder_arrow = true },
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },

      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store", "node_modules", "vendor" },
      },
      git = {
        enable = true,
        ignore = false,
      },
    })
  end,
}
