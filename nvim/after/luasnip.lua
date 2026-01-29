local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_mode


ls.add_snippets("typescriptreact", {
  s("hi", {
    t("Hi, there!")
  })
})
