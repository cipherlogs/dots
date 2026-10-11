return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo" },
  opts = {
    formatters = {
      fourmolu = {
        args = {
          "--indent-wheres=true",
          "--haddock-style=single-line",
          "--respectful=false",
          "--column-limit=78",
          "--stdin-input-file",
          "$FILENAME",
        },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "biome", "prettierd", stop_after_first = true },
      javascript = { "biome-check" },
      javascriptreact = { "biome-check" },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },
      haskell = { "fourmolu" },
      python = { "ruff_format", "ruff_organize_imports" },
      solidity = { "forge" },
    },
    format_after_save = function(_)
      local bufname = vim.fn.expand "%:p"
      if bufname:match "/node_modules/" or bufname:match "/Repos/openSource" then
        return
      end
      return { lsp_fallback = true }
    end,
  },
}
