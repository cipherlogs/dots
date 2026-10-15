return {
  ensure_installed = {
    "vim",
    "lua",
    "vimdoc",
    "luadoc",
    "bash",
    "html",
    "css",
    "javascript",
    "json",
    "typescript",
    "tsx",
    "markdown",
    "yaml",
    "toml",
    "xml",
    "sql",
    "prisma",
    "python",
    "solidity",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "ssh_config",
    "printf",
  },

  indent = { enable = true },

  highlight = {
    enable = true,
    -- shortcut: no treesitter highlight for markdown; master's markdown
    -- queries use offset directives the 0.12 runtime rejects (range nil
    -- crash). Upgrade: migrate nvim-treesitter to the main branch.
    disable = { "markdown", "markdown_inline" },
    use_languagetree = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-Space><C-Space>",
      node_incremental = "<C-Space>",
      node_decremental = "<bs>",
      scope_incremental = false,
    },
  },
}
