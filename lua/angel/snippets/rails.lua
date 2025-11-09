local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Autosnippet para Rails migration
  s({ trig = "mig", snippetType = "autosnippet" }, fmt([[
    class {} < ActiveRecord::Migration[7.0]
      def change
        {}
      end
    end
  ]], { i(1, "CreateTable"), i(0) })),

  -- Autosnippet para action en controller
  s({ trig = "act", snippetType = "autosnippet" }, fmt([[
    def {}
      {}
    end
  ]], { i(1, "index"), i(0) })),
}
