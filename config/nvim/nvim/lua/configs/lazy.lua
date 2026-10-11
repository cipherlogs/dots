return {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyodark", "habamax" } },
  change_detection = { notify = false },
  checker = { enabled = false },
  rocks = { enabled = false }, -- ponytail: no rockspec builds; silences luarocks checkhealth

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
      },
    },
  },
}
