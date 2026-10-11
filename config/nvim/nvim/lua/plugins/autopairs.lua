return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "windwp/nvim-ts-autotag" },
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
    },
  },
}
