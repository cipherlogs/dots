return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },

  opts = function()
    require "configs.treesitter"
  end,

  config = function(_, opts)
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
    require("nvim-treesitter.configs").setup(opts)
    require("nvim-ts-autotag").setup({})
  end
}
