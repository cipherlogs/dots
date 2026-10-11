vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.have_nerd_font = true
vim.g.loaded_perl_provider = 0 -- no perl provider; silences cpan checkhealth warning
vim.g.loaded_ruby_provider = 0 -- no ruby provider either

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require "options"
require("lazy").setup({ import = "plugins" }, require "configs.lazy")

pcall(vim.cmd.colorscheme, "tokyodark")

require "autocmds"
require "mappings"
