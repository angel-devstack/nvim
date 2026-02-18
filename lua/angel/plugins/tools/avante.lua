return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<CR>", desc = "Avante: Ask", mode = { "n", "v" } },
    { "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Avante: Refresh" },
    { "<leader>ac", "<cmd>AvanteChat<CR>", desc = "Avante: New Chat" },
    { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Avante: Toggle" },
    { "<leader>aX", function()
      vim.fn.system("rm -rf " .. vim.fn.stdpath("state") .. "/avante/*")
      vim.notify("Avante: Historial limpiado", vim.log.levels.INFO)
    end, desc = "Avante: Clear history" },
  },
  opts = {
    provider = "ollama",
    providers = {
      ollama = {
        ["local"] = true,
        endpoint = "127.0.0.1:11434",
        model = os.getenv("LLM_MODEL") or "qwen2.5-coder:3b",
        timeout = 30000,
      },
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    -- Incluir archivo actual automáticamente
    system_prompt = "You are an expert software developer. When given code, analyze it thoroughly and provide detailed, actionable suggestions.",
    file_selector = {
      provider = "native",
    },
    mappings = {
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
    },
    hints = { enabled = true },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        align = "center",
        rounded = true,
      },
    },
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    diff = {
      autojump = true,
      list_opener = "copen",
    },
  },
  -- Build opcional - si falla, el plugin funciona sin componentes nativos
  build = function()
    local result = vim.fn.system({ "bash", "-c", "command -v make && make || true" })
    if vim.v.shell_error ~= 0 then
      vim.notify("avante.nvim: build skipped, plugin will work without native components", vim.log.levels.WARN)
    end
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- Optional dependencies
    "nvim-tree/nvim-web-devicons",
    {
      -- soporte para renderizado de imágenes
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      -- soporte para renderizado de markdown con imágenes
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
