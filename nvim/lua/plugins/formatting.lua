local options = {
  formatters = {
    ["fourmolu"] = {
      args = {
        "--indent-wheres=true",
        -- "--comma-style=trailing",
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
    python = { "isort", "black" },
    solidity = { "forge" },
  },

  format_after_save = function(_)
    -- Places where I don't want auto formatting
    local bufname = vim.fn.expand "%:p"
    local cantFormat = bufname:match "/node_modules/"
      or bufname:match "/Repos/openSource"

    if cantFormat then
      return
    end

    return { lsp_fallback = true }
  end,
}

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup(options)
  end,
}
