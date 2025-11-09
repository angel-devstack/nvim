return {
  "David-Kunz/gen.nvim",
  event = "VeryLazy",
  cmd = { "Gen", "GenChat", "GenSelectModel" },
  keys = {
    { "<leader>g1>", "<cmd>Gen<CR>", desc = "Generate via LLM" },
    { "<leader>g2", "<cmd>GenChat<CR>", desc = "Open Gen chat session" },
  },
  opts = {
    model = os.getenv("LLM_MODEL"),
    host = "localhost",
    port = os.getenv("OLLAMA_PORT"),
    display_mode = "float",
    show_prompt = false,
    show_model = true,
    no_auto_close = false,
    hidden = false,
    debug = false,

    init = function()
      pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    end,

    command = function(options)
      return string.format(
        [[curl --silent --no-buffer -X POST http://%s:%s/api/chat -d '{"model": "%s", "stream": true, "messages": [{"role": "user", "content": "$prompt"}] }']],
        options.host,
        options.port,
        options.model
      )
    end,
  },
  config = function(_, opts)
    require("gen").setup(opts)
  end,
}
