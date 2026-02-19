local terminal = require("angel.utils.terminal")

return {
  "3rd/image.nvim",
  cond = function()
    return terminal.is_wezterm()
  end,
  opts = {
    backend = "kitty", -- wezterm y kitty comparten el protocolo gráfico
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
    },
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
}
