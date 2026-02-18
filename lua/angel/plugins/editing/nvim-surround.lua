return {
  "kylechui/nvim-surround",
  keys = {
    { "ys", mode = "n", desc = "Surround" },
    { "yss", mode = "n", desc = "Surround line" },
    { "yS", mode = "n", desc = "Surround line (newline)" },
    { "S", mode = "v", desc = "Surround selection" },
    { "gS", mode = "v", desc = "Surround lines" },
    { "ds", mode = "n", desc = "Delete surround" },
    { "cs", mode = "n", desc = "Change surround" },
  },
  version = "*",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        normal = "ys", -- "you surround"
        normal_cur = "yss", -- surround current line
        normal_line = "yS", -- surround whole line
        visual = "S", -- surround visual selection
        visual_line = "gS", -- surround visual line
        delete = "ds", -- delete surround
        change = "cs", -- change surround
      },
    })

    -- Configuración adicional por buffer para JS/TS (${...} syntax)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      callback = function()
        require("nvim-surround").buffer_setup({
          surrounds = {
            ["$"] = {
              add = function()
                return { "${", "}" }
              end,
              find = "%${.-}", -- busca el patrón `${...}`
              delete = "^(%${)().-(})()$", -- cómo borrarlo
            },
          },
        })
      end,
    })
  end,
}

-- | Modo   | Comando | Acción                                   | Ejemplo                   |
-- | ------ | ------- | ---------------------------------------- | ------------------------- |
-- | Normal | `ysiw"` | Rodea palabra con comillas dobles        | `word` → `"word"`         |
-- | Normal | `yss(`  | Rodea línea completa con paréntesis      | `line` → `(line)`         |
-- | Normal | `yS{`   | Rodea línea completa con llaves          | `line` → `{line}`         |
-- | Visual | `S"`    | Rodea selección visual con comillas      | seleccionás → `"texto"`   |
-- | Visual | `gS[`   | Rodea líneas seleccionadas con corchetes | varias líneas → `[ ... ]` |
-- | Normal | `ds'`   | Elimina comillas simples                 | `'texto'` → `texto`       |
-- | Normal | `cs'"`  | Cambia comillas simples a dobles         | `'text'` → `"text"`       |
