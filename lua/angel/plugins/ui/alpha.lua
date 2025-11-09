return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Logo
    dashboard.section.header.val = {
      "    █████╗ ███╗   ██╗ ██████╗ ███████╗██╗        ",
      "   ██╔══██╗████╗  ██║██╔════╝ ██╔════╝██║        ",
      "   ███████║██╔██╗ ██║██║  ███╗█████╗  ██║        ",
      "   ██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██║        ",
      "   ██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗   ",
      "   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝   ",
      "                                                 ",
      "                🄳 🄴 🅅  🅂 🅃 🄰 🄲 🄺                 ",
    }

    -- Botones del dashboard
    dashboard.section.buttons.val = {
      dashboard.button("e", "  Nuevo archivo", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle Explorador de Archivos", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼  Buscar archivo", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  Buscar palabra", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  Restaurar sesión", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", "  Salir", "<cmd>qa<CR>"),
    }

    dashboard.section.footer.val = function()
      return "⚡ https://github.com/angel-devstack"
    end

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)

    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
