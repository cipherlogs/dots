return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      pkgs = {
        "lua-language-server",
        "tailwindcss-language-server",
        "emmet-language-server",
        "haskell-language-server",
        "ts_ls",
        "eslint-lsp",
        "css-lsp",
        "html-lsp",
        "biome",
        "prettierd",
        "json-lsp",
        "fourmolu",
        "ruff",
        "prisma-language-server",
      },
    },
  },
}
