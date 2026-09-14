return {
  ensure_installed = {
    -- defaults
    "vim",
    "lua",
    "vimdoc",

    -- web dev
    "html",
    "css",
    "javascript",
    "json",
    "typescript",
    "tsx",

    -- others
    "bash",
    "solidity",
    "python",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "haskell",
    "ssh_config",
    "xml",
    "yaml",
    "toml",
    "markdown",
    "sql",
    "prisma",
    "luadoc",
    "printf",
    "vim",
    "vimdoc",
  },

  autotag = { enable = true },
  indent = { enable = true },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Space><Space>",
      node_incremental = "<Space>",
      node_decremental = "<bs>",
      scope_incremental = false,
    },
  },
}
