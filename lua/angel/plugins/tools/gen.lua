return {
  "David-Kunz/gen.nvim",
  event = "VeryLazy",
  cmd = { "Gen", "GenChat", "GenSelectModel" },
  keys = {
    { "<leader>g1", "<cmd>Gen<CR>", mode = { "n", "v" }, desc = "Generate via LLM" },
    { "<leader>g2", "<cmd>GenChat<CR>", desc = "Gen: Chat session" },
    { "<leader>gr", ":Gen Review_Code<CR>", mode = { "v" }, desc = "Gen: Review code" },
    { "<leader>ge", ":Gen Enhance_Code<CR>", mode = { "v" }, desc = "Gen: Enhance/refactor code" },
    { "<leader>gm", function()
      require('gen').select_model()
    end, desc = "Gen: Select model" },
  },
  opts = {
    model = os.getenv("LLM_MODEL") or "qwen2.5-coder:3b",
    host = "localhost",
    port = os.getenv("OLLAMA_PORT") or "11434",
    display_mode = "split",  -- usa 'float' si prefieres ventana flotante
    show_prompt = false,
    show_model = true,
    no_auto_close = false,
    debug = false,  -- cambia a true si necesitas troubleshooting
    -- No definimos 'command', dejamos que gen.nvim use su default
  },
  config = function(_, opts)
    local gen = require("gen")
    gen.setup(opts)
    
    -- Prompts personalizados con float (default)
    gen.prompts['Review_Code'] = {
      prompt = "Revisa el siguiente código y proporciona sugerencias de mejora, identificando posibles bugs, problemas de rendimiento y mejores prácticas:\n\n$text",
      replace = false,
    }
    gen.prompts['Enhance_Code'] = {
      prompt = "Refactoriza y mejora el siguiente código. Proporciona el código mejorado con explicaciones de los cambios realizados:\n\n$text",
      replace = false,
    }
    gen.prompts['Explain_Code'] = {
      prompt = "Explica detalladamente qué hace el siguiente código:\n\n$text",
      replace = false,
    }
    
    -- Prompts con split (más fácil para copiar/pegar)
    gen.prompts['Review_Code_Split'] = {
      prompt = "Revisa el siguiente código y proporciona sugerencias de mejora:\n\n$text",
      replace = false,
      model = opts.model,
      extract = "```$filetype\n(.-)\n```",
    }
    gen.prompts['Enhance_Code_Split'] = {
      prompt = "Refactoriza y mejora el siguiente código:\n\n$text",
      replace = false,
      model = opts.model,
      extract = "```$filetype\n(.-)\n```",
    }
  end,
}
