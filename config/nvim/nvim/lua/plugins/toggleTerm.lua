return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<localleader>t", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle terminal" },
  },
  opts = {
    direction = "vertical",
  },
  config = function(_, opts)
    opts.size = function()
      return math.floor(vim.o.columns * 0.5)
    end
    require("toggleterm").setup(opts)
  end,
}
