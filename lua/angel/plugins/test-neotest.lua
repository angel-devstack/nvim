return {
  "nvim-neotest/neotest",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        -- Python
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
        }),
        -- Ruby
        require("neotest-rspec")({
          rspec_cmd = function()
            return { "bundle", "exec", "rspec" }
          end,
        }),
        -- JS/TS
        require("neotest-jest")({
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        -- Rust
        require("neotest-rust")({}),
      },

      -- Opciones adicionales
      status = { virtual_text = true },
      summary = { open = "botright vsplit | vertical resize 80" },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          vim.cmd("copen")
        end,
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Ejecutar pruebas
    keymap("n", "<leader>tt", function()
      neotest.run.run(vim.fn.expand("%"))
    end, vim.tbl_extend("force", opts, { desc = "🧪 Run test file" }))

    keymap("n", "<leader>tr", function()
      neotest.run.run()
    end, vim.tbl_extend("force", opts, { desc = "🧪 Run nearest test" }))

    keymap("n", "<leader>ta", function()
      neotest.run.run({ suite = true })
    end, vim.tbl_extend("force", opts, { desc = "🧪 Run all tests" }))

    -- Depuración (DAP)
    keymap("n", "<leader>tS", function()
      neotest.run.run({ strategy = "dap" })
    end, vim.tbl_extend("force", opts, { desc = "🐞 Debug test via DAP" }))

    -- Vistas y utilidades
    keymap("n", "<leader>to", function()
      neotest.output.open({ enter = true })
    end, vim.tbl_extend("force", opts, { desc = "📤 Show test output" }))

    keymap("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, vim.tbl_extend("force", opts, { desc = "📋 Toggle test summary" }))
  end,
}
