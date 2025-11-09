local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Método normal
  s("def", fmt("def {}({})\n  {}\nend", { i(1, "method"), i(2), i(0) })),

  -- Clase básica
  s("cls", fmt("class {}\nend", { i(1, "ClassName") })),

  -- Autosnippet para debugger (pry)
  s({ trig = "pry", snippetType = "autosnippet" }, t("require \"pry\"; binding.pry")),

  -- Autosnippet para puts debugging
  s({ trig = "pp", snippetType = "autosnippet" }, t("puts \"⚡ HERE\"")),
}
