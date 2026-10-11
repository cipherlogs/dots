return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  opts = function()
    return require "configs.treesitter"
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    require("nvim-ts-autotag").setup {}
  end,
}
