return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")
    local devicons = require("nvim-web-devicons")

    -- 📁 Ruta relativa al root Git (fallback: cwd)
    local function relative_git_filepath()
      local path = vim.fn.expand("%:p")
      if path == "" then
        return "[No Name]"
      end
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if git_root == nil or git_root == "" then
        git_root = vim.fn.getcwd()
      end
      local relpath = vim.fn.fnamemodify(path, ":." .. git_root)
      return relpath
    end

    -- 🖼️ Ícono con color y ruta
    local function file_with_icon()
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
      local filepath = relative_git_filepath()

      vim.api.nvim_set_hl(0, "LualineFileIconDynamic", { fg = icon_color, bg = "NONE" })
      return string.format("%%#LualineFileIconDynamic#%s %%#Normal#%s", icon, filepath)
    end

    -- 🎨 Paleta de colores (ajústala a tu esquema si querés)
    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    -- 🌈 Tema visual personalizado
    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = { a = { bg = colors.green, fg = colors.bg, gui = "bold" } },
      visual = { a = { bg = colors.violet, fg = colors.bg, gui = "bold" } },
      replace = { a = { bg = colors.red, fg = colors.bg, gui = "bold" } },
      command = { a = { bg = colors.yellow, fg = colors.bg, gui = "bold" } },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.fg },
        c = { bg = colors.inactive_bg, fg = colors.fg },
      },
    }

    -- ⚙️ Configuración principal
    lualine.setup({
      options = {
        theme = my_lualine_theme,
        globalstatus = false, -- ✅ <--- Esto asegura una línea por split!
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = {
          {
            file_with_icon,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding", fmt = string.upper },
          { "fileformat", icons_enabled = true },
          { "filetype" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { file_with_icon },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "nvim-tree" }, -- eliminamos fugitive
    })
  end,
}
