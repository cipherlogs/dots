local group = vim.api.nvim_create_augroup("user", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})

-- show search matches only while searching
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  pattern = { "/", "\\?" },
  callback = function()
    vim.o.hlsearch = true
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  pattern = { "/", "\\?" },
  callback = function()
    vim.o.hlsearch = false
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})
