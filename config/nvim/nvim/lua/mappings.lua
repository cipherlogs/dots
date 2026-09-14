require "nvchad.mappings"

local map = vim.keymap.set
local cmd = vim.cmd
local nomap = vim.keymap.del

-- Delete default nvchad mappings
nomap("n", "<C-s>", { noremap = true, silent = true })
nomap("n", "<leader>v", { noremap = true, silent = true })
nomap("n", "<leader>h", { noremap = true, silent = true })
nomap("n", "<leader>ff", { noremap = true, silent = true })
nomap("n", "<leader>fo", { noremap = true, silent = true })
nomap("n", "<leader>cm", { noremap = true, silent = true })
nomap("n", "<leader>gt", { noremap = true, silent = true })
nomap("n", "<leader>pt", { noremap = true, silent = true })
nomap("n", "<leader>fh", { noremap = true, silent = true })
nomap("n", "<Esc>", { noremap = true, silent = true })
nomap("n", "<leader>wK", { noremap = true, silent = true })
-- nomap("n", "<leader>b", { noremap = true, silent = true })
-- nomap("n", "<tab>", { noremap = true, silent = true })
-- nomap("n", "<S-tab>", { noremap = true, silent = true })
-- nomap("n", "<leader>x", { noremap = true, silent = true })

-- Misc mappings
map("n", "'", "`", { noremap = true, silent = true })
map("n", "`", "'", { noremap = true, silent = true })
map("n", "gz", "1z=gul", { noremap = true, silent = true })
map("n", "gd", "gdzz", { noremap = true, silent = true })
map(
  "n",
  "<leader>so",
  ":w<CR> :so $MYVIMRC<CR>",
  { noremap = true, silent = true }
)
map("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
map("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
map("n", "<leader>y", '"+y', { noremap = true, silent = true })
map("n", "<C-6>", "<C-6>zz", { noremap = true, silent = true })

map("i", "<C-j>", "<CR>", { noremap = true, silent = true })

-- split navigation
map("n", "<Left>", "<C-w>h", { noremap = true, silent = true })
map("n", "<Down>", "<C-w>j", { noremap = true, silent = true })
map("n", "<Up>", "<C-w>k", { noremap = true, silent = true })
map("n", "<Right>", "<C-w>l", { noremap = true, silent = true })

-- Terminal
map({ "t" }, "<C-Space>", "<C-\\><C-n>", { noremap = true, silent = true })

-- map("n", "<localleader>t", function()
--   cmd.vnew()
--   cmd.term()
--   cmd.wincmd "J"
--   vim.api.nvim_win_set_height(0, 10)
-- end, { desc = "Open a small terminal at the bottom" })

-- Buffers
map("n", "<leader>d", ":bp | bd#<CR>", { noremap = true, silent = true })

-- map("n", "<BS>h", "mx'H`x", { noremap = true, silent = true })
-- map("n", "<BS>j", "mx'J`x", { noremap = true, silent = true })
-- map("n", "<BS>k", "mx'K`x", { noremap = true, silent = true })
-- map("n", "<BS>l", "mx'L`x", { noremap = true, silent = true })
-- map("n", "<BS>g", "mx'G`x", { noremap = true, silent = true })
-- map("n", "<BS>d", "mx'D`x", { noremap = true, silent = true })
-- map("n", "<BS>s", "mx'S`x", { noremap = true, silent = true })
-- map("n", "<BS>a", "mx'A`x", { noremap = true, silent = true })

map("n", "<leader>v", function()
  local buffPos = vim.api.nvim_win_get_cursor(0)

  cmd "vsplit"
  cmd "wincmd l"
  vim.api.nvim_win_set_cursor(0, buffPos)
  cmd "normal! zz"
  cmd "wincmd p"
end, {
  noremap = true,
  silent = true,
  desc = "Vertical split here then focus on the current buffer.",
})

do
  local zoomed = false

  map("n", "<A-f>", function()
    if not zoomed then
      cmd "wincmd _"
      cmd "wincmd |"
      zoomed = true
    else
      cmd "wincmd ="
      zoomed = false
    end
  end, {
    noremap = true,
    silent = true,
    desc = "Toggle buffer's fullscreen mode.",
  })
end

-- harpoon
local harpoon = require "harpoon"
harpoon:setup()
local list = harpoon:list()

for i, char in ipairs { "h", "j", "k", "l", ";", "g", "f", "d", "s", "a" } do
  -- Add hot keys for mapping buffer to harpoon
  vim.keymap.set({ "n", "t" }, string.format("<leader>%d", i), function()
    if list:get(i) ~= nil then
      list:replace_at(i)
    else
      list:add()
    end
  end, {
    noremap = true,
    silent = true,
    desc = ("Harpoon: add/replace current file at slot %d"):format(i),
  })

  -- Add hot keys for selecting buffers from harpoon
  vim.keymap.set({ "n" }, string.format("<BS>%s", char), function()
    list:select(i)
  end, {
    noremap = true,
    silent = true,
    desc = ("Harpoon: Get buffer N%d from the harpoon list").format(i),
  })
end

-- Diagnostic and lsp mappings
map(
  { "n", "v" },
  "grn",
  vim.lsp.buf.rename,
  { noremap = true, silent = true }
)
map(
  { "n", "v" },
  "ga",
  vim.lsp.buf.code_action,
  { noremap = true, silent = true }
)
map("n", "gk", vim.diagnostic.open_float, { noremap = true, silent = true })
map("n", "gh", vim.lsp.buf.signature_help, { noremap = true, silent = true })

-- Telescope
map(
  "n",
  "<C-k>",
  "<cmd>Telescope find_files<cr>",
  { noremap = true, silent = true }
)

map(
  "n",
  "<C-b>",
  "<cmd>Telescope buffers<cr>",
  { noremap = true, silent = true }
)

-- Inlay hints
map("n", "gh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- LuaSnip
map({ "i", "s" }, "<C-l>", function()
  local ls = require "luasnip"
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = "expand or jump" })

map({ "i", "s" }, "<C-h>", function()
  local ls = require "luasnip"
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = "go back luasnip" })

map({ "i", "s" }, "<C-n>", function()
  local ls = require "luasnip"
  if ls.choice_active() then
    ls.change_choice()
  end
end, { desc = "change choise, luasnip" })
