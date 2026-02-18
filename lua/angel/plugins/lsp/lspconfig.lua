-- Configuración moderna de LSP para Neovim 0.11+

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
    { "b0o/schemastore.nvim" }, -- importante para JSON/YAML
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- =========================================================================
    -- 🧠 Función on_attach: define keymaps comunes
    -- =========================================================================
    local on_attach = function(client, bufnr)
      local keymap = vim.keymap
      local opts = { buffer = bufnr, silent = true }

      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", opts, { desc = "Go to definition" }))
      keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
      keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Go to references" }))
      keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
      keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
      keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", vim.tbl_extend("force", opts, { desc = "Document symbols" }))
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
      keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
      keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
      keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
    end

    -- =========================================================================
    -- 💎 Ruby (fallback automático)
    -- =========================================================================
    local ruby_server
    if vim.fn.executable("ruby-lsp") == 1 and not vim.loop.fs_stat(".solargraph.yml") then
      ruby_server = {
        name = "ruby_lsp",
        config = {
          init_options = {
            formatter = "rubocop",
            linters = { "rubocop" },
          },
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
        },
      }
    else
      ruby_server = {
        name = "solargraph",
        config = {
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = false,
              autoformat = false,
              completion = true,
            },
          },
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
        },
      }
    end

    -- =========================================================================
    -- 🧩 JSON y YAML con SchemaStore
    -- =========================================================================
    local schemastore = require("schemastore")

    -- =========================================================================
    -- ⚙️ Servidores configurados
    -- =========================================================================
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },
      [ruby_server.name] = ruby_server.config,
      pyright = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      },
      html = {},
      cssls = {},
      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "scss",
          "sass",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "eruby",
          "htmldjango",
        },
      },
      tailwindcss = {},
      svelte = {
        on_attach = function(client)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },
      graphql = {
        filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact", "svelte" },
      },
      marksman = {},
      bashls = {},
      dockerls = {},
      jsonls = {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = schemastore.yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
          },
        },
      },
      ts_ls = {}, -- para JS/TS
    }

    -- =========================================================================
    -- 🔧 Setup LSP servers with backward compatibility
    -- =========================================================================
    local lspconfig = require("lspconfig")

    -- Check if using new API (Neovim 0.11+) or old API (0.10 and below)
    local use_new_api = vim.lsp.config ~= nil

    for name, config in pairs(servers) do
      config.capabilities = capabilities
      config.on_attach = config.on_attach or on_attach

      if use_new_api then
        -- Neovim 0.11+ new API
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      else
        -- Neovim 0.10 and below (legacy API)
        lspconfig[name].setup(config)
      end
    end

    -- =========================================================================
    -- 🩵 Diagnostic signs with modern API (backward compatible)
    -- =========================================================================
    local signs = {
      Error = "🔴",
      Warn = "🟡",
      Hint = "🔵",
      Info = "🟢",
    }

    -- Use modern diagnostic.config if available (Neovim 0.10+)
    if vim.diagnostic.config then
      local sign_names = {}
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        sign_names[vim.diagnostic.severity[type:upper()]] = hl
        -- Still define signs for backward compatibility
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.diagnostic.config({
        signs = { text = signs },
        virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    else
      -- Fallback for older Neovim versions
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end
  end,
}
