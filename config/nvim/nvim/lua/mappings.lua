local map = vim.keymap.set

-- mark navigation
map("n", "'", "`", { noremap = true, silent = true })
map("n", "`", "'", { noremap = true, silent = true })

-- misc
map("n", "gz", "1z=gul", { noremap = true, silent = true })
map("n", "<leader>w", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Write" })
map("n", "<leader>q", "<cmd>q<CR>", { noremap = true, silent = true, desc = "Quit" })
map("n", "<leader>d", "<cmd>bp | bd#<CR>", { noremap = true, silent = true, desc = "Close buffer" })
map("n", "<C-6>", "<C-6>zz", { noremap = true, silent = true })
map("i", "<C-j>", "<CR>", { noremap = true, silent = true })

-- split navigation
map("n", "<Left>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
map("n", "<Down>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
map("n", "<Up>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
map("n", "<Right>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- vertical split keeping cursor position
map("n", "<leader>v", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.vsplit()
  vim.cmd "wincmd l"
  vim.api.nvim_win_set_cursor(0, pos)
  vim.cmd "normal! zz"
  vim.cmd "wincmd p"
end, { noremap = true, silent = true, desc = "Vertical split here" })

-- zoom toggle
do
  local zoomed = false
  map("n", "<A-f>", function()
    if not zoomed then
      vim.cmd "wincmd _"
      vim.cmd "wincmd |"
      zoomed = true
    else
      vim.cmd "wincmd ="
      zoomed = false
    end
  end, { noremap = true, silent = true, desc = "Toggle fullscreen window" })
end

-- terminal escape
map("t", "<C-Space>", "<C-\\><C-n>", { noremap = true, silent = true })

-- lsp / diagnostics
map({ "n", "v" }, "grn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP rename" })
map({ "n", "v" }, "ga", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP code action" })
map("n", "gk", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Line diagnostics" })
map("n", "gH", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "Signature help" })
map("n", "gh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle inlay hints" })

-- snippets
map({ "i", "s" }, "<C-l>", function()
  local ls = require "luasnip"
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = "Snippet expand/jump" })
map({ "i", "s" }, "<C-h>", function()
  local ls = require "luasnip"
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = "Snippet jump back" })
map({ "i", "s" }, "<C-n>", function()
  local ls = require "luasnip"
  if ls.choice_active() then
    ls.change_choice()
  end
end, { silent = true, desc = "Snippet change choice" })
