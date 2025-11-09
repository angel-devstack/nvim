-- lua/angel/plugins/autopairs.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local ok_autopairs, autopairs = pcall(require, "nvim-autopairs")
    if not ok_autopairs then
      return
    end

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- Integración con nvim-cmp
    local ok_cmp, cmp = pcall(require, "cmp")
    if not ok_cmp then
      return
    end

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
