local ls = require "luasnip"
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

ls.add_snippets("all", {
  s(
    "lo",
    fmt("console.info({})", {
      i(1),
    })
  ),
})
