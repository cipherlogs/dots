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
