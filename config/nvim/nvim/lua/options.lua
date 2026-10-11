local o = vim.o
local opt = vim.opt

o.termguicolors = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.confirm = true
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.inccommand = "nosplit"
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
o.autoindent = true
o.smarttab = true
o.autoread = true
o.history = 1000
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.ttimeoutlen = 25
o.shortmess = o.shortmess .. "c"
o.clipboard = "unnamedplus"
o.textwidth = 100
o.showtabline = 1
o.laststatus = 0
o.cmdheight = 2
o.breakindent = true
o.linebreak = true
o.breakat = ""
o.list = true
o.listchars = "tab:>-,nbsp:%,trail:~"
o.wildignorecase = true
o.wildmode = "longest:full,full"
o.spelllang = "en_us"
o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.backup = false
o.swapfile = true
o.undofile = true

opt.path:remove "**" -- ponytail: no recursive gf/:find scan; add back per-project if needed
opt.wildignore:append { "*/node_modules/*", "*/.git/*" }
opt.backupdir:append(vim.fn.expand "~/.cache/nvim/backup//")
opt.directory:append { "/tmp", vim.fn.expand "~/.cache/nvim/swap//" }
opt.undodir:append(vim.fn.expand "~/.cache/nvim/undo//")

vim.diagnostic.config {
  signs = false,
  virtual_text = true,
  update_in_insert = false,
}
