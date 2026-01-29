return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = math.floor(vim.o.columns * 0.5),
    open_mapping = [[<localleader>t]],
    direction = "vertical",
  },
}
