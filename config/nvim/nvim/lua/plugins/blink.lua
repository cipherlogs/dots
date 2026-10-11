return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = { "L3MON4D3/LuaSnip" },
  opts = {
    keymap = { preset = "default" },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
}
