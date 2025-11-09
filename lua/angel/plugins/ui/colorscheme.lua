return {
  "Tsuzat/NeoSolarized.nvim",
  lazy = false, -- carga siempre en startup
  priority = 1000,
  config = function()
    local transparent = true
    local theme = require("NeoSolarized")

    theme.setup({
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_colors = function(colors)
        colors.bg = "#011628"
        colors.bg_dark = transparent and colors.none or "#011423"
        colors.bg_float = transparent and colors.none or "#011423"
        colors.bg_highlight = "#143652"
        colors.bg_popup = "#011423"
        colors.bg_search = "#0A64AC"
        colors.bg_sidebar = transparent and colors.none or "#011423"
        colors.bg_statusline = transparent and colors.none or "#011423"
        colors.bg_visual = "#275378"
        colors.border = "#547998"
        colors.fg = "#CBE0F0"
        colors.fg_dark = "#B4D0E9"
        colors.fg_float = "#CBE0F0"
        colors.fg_gutter = "#627E97"
        colors.fg_sidebar = "#B4D0E9"
      end,
    })

    vim.cmd("colorscheme NeoSolarized")
  end,
}
