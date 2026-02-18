-- Bundler hook for Ruby LSP - project-aware command selection
-- Only affects Ruby files, detects Gemfile, uses bundle exec when available
-- Ensures only ONE LSP (ruby-lsp or solargraph) is active, not both

local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  local log_prefix = "[BundlerHook] "

  -- Detectar si hay Gemfile
  local has_gemfile = vim.fn.filereadable("Gemfile") > 0

  -- Elegir LSP: solargraph si existe .solargraph.yml y no ruby-lsp
  local has_solargraph_config = vim.loop.fs_stat(".solargraph.yml")
  local prefer_solargraph = has_solargraph_config ~= nil and vim.fn.executable("ruby-lsp") == 0

  local function log(msg)
    vim.notify(log_prefix .. msg, vim.log.levels.INFO)
  end

  if has_gemfile then
    -- Proyecto con Bundler: usar bundle exec
    log("Gemfile detected, using bundle exec for Ruby LSP")

    if prefer_solargraph then
      -- Solargraph with bundle exec
      lspconfig.solargraph.setup({
        cmd = { "bundle", "exec", "solargraph", "stdio" },
        root_dir = util.root_pattern("Gemfile", ".ruby-version", ".git"),
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = false,
            autoformat = false,
            completion = true,
          },
        },
      })
      log("Configured: solargraph with bundle exec")
    else
      -- Ruby LSP with bundle exec
      lspconfig.ruby_lsp.setup({
        cmd = { "bundle", "exec", "ruby-lsp" },
        root_dir = util.root_pattern("Gemfile", ".ruby-version", ".git"),
        settings = {
          ruby = {
            linters = { "rubocop" },
            formatter = "rubocop",
          },
        },
      })
      log("Configured: ruby-lsp with bundle exec")
    end
  else
    -- Proyecto sin Gemfile: usar asdf shims o comando directo
    log("No Gemfile, using command from PATH (asdf shims if available)")

    local asdf_shim_rubylsp = vim.fn.expand("~/.asdf/shims/ruby-lsp")
    local asdf_shim_solargraph = vim.fn.expand("~/.asdf/shims/solargraph")

    if prefer_solargraph then
      local cmd = vim.fn.executable(asdf_shim_solargraph) == 1
        and { asdf_shim_solargraph, "stdio" }
        or { "solargraph", "stdio" }

      lspconfig.solargraph.setup({
        cmd = cmd,
        root_dir = util.root_pattern(".ruby-version", ".git"),
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = false,
            autoformat = false,
            completion = true,
          },
        },
      })
      log("Configured: solargraph (" .. cmd[1] .. ")")
    else
      local cmd = vim.fn.executable(asdf_shim_rubylsp) == 1
        and { asdf_shim_rubylsp }
        or { "ruby-lsp" }

      lspconfig.ruby_lsp.setup({
        cmd = cmd,
        root_dir = util.root_pattern(".ruby-version", ".git"),
        settings = {
          ruby = {
            linters = { "rubocop" },
            formatter = "rubocop",
          },
        },
      })
      log("Configured: ruby-lsp (" .. cmd[1] .. ")")
    end
  end
end

return M