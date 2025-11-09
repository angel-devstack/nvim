return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
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

    -- configuración adicional por buffer, por ejemplo, para agregar ${...}
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
