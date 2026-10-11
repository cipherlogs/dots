return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "biome", "prettierd", stop_after_first = true },
      javascript = { "biome-check" },
      javascriptreact = { "biome-check" },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },
      python = { "ruff_format", "ruff_organize_imports" },
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
