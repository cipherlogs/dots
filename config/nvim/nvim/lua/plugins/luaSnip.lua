return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require "luasnip"
    ls.config.set_config {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    }
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load { paths = vim.fn.stdpath "config" .. "/lua/snippets/" }
  end,
}
