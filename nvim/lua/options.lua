require "nvchad.options"
local cmd = vim.cmd

-- Basic settings
vim.o.termguicolors = true
cmd "syntax on"
cmd "filetype plugin indent on"

vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

cmd "set backupdir=~/.cache/nvim/backup//"
cmd "set directory=/tmp/,~/.cache/nvim/swap//"
cmd "set undodir=~/.cache/nvim/undo//"

cmd 'set buftype=""'
cmd "set clipboard=unnamedplus"
cmd "set number relativenumber"
cmd "set laststatus=0"
cmd "set textwidth=100"
cmd "set showtabline=1"
cmd "set smartcase ignorecase incsearch"
cmd "set inccommand=nosplit"
cmd "set shiftwidth=2 tabstop=2 softtabstop=2 expandtab smartindent"
cmd "set autoindent"
cmd "set autoread"
cmd "set smarttab"
cmd "set history=200"
cmd "set undolevels=1000"
cmd "set scrolloff=0"
cmd "set spelllang=en_us"
cmd "set updatetime=50"
cmd "set shortmess+=c"
cmd "set timeoutlen=150"
cmd "set ttimeoutlen=25"
cmd "set nofoldenable"
cmd "set cmdheight=2"
cmd "set breakindent"
-- cmd("set breakindentopt=shift:2")
cmd 'set breakat=""'
cmd "set linebreak"

-- Column width
cmd [[
  noremap <leader>ll :execute "set cc=" . (&cc == "" ? "110" : "")<CR>
]]

-- Show whitespace chars
cmd "set list"
cmd "set listchars=tab:>-,nbsp:%,trail:~"

-- Path
cmd "set path=.,**"
cmd "set wildignorecase"
cmd "set wildignore+=*/node_modules/*,*/.git/*"
cmd "set wildmode=longest:full,full"

-- Turn off hlsearch
cmd [[
  augroup vimrc-incsearch-highlight
      autocmd!
      autocmd CmdlineEnter /,\? :set hlsearch
      autocmd CmdlineLeave /,\? :set nohlsearch
  augroup END
]]

-- Yank highlihgt
cmd [[
  augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
  augroup END
]]

-- Show diagnostics only on load and save.
vim.api.nvim_create_autocmd({ "BufNew", "InsertEnter", "BufEnter" }, {
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

vim.api.nvim_create_autocmd({ "BufWrite" }, {
  callback = function()
    vim.diagnostic.enable(true)
  end,
})

-- Terminal
local term_augroup =
  vim.api.nvim_create_augroup("CustomTermOpen", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = term_augroup,
  pattern = "*",
  callback = function()
    -- window-local settings
    vim.wo.number = false
    vim.wo.relativenumber = false

    -- immediately enter insert mode
    vim.cmd "startinsert"
  end,
})

-- load default snippets
-- vim.g.vscode_snippets_path = "~/.config/nvim/lua/snippets/react.json"
