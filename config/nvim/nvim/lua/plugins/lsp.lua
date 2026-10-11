return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "typescript-language-server",
        "tailwindcss-language-server",
        "emmet-language-server",
        "eslint-lsp",
        "css-lsp",
        "html-lsp",
        "biome",
        "prettierd",
        "json-lsp",
        "ruff",
        "prisma-language-server",
      },
    },
  },
}
