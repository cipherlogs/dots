vim.keymap.set(
  "n",
  ",r",
  ":w<CR>:!python %<CR>",
  { buffer = true, noremap = true, silent = false, desc = "Run python file" }
)
