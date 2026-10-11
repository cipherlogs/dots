vim.keymap.set(
  "n",
  ",r",
  ":w<CR>:!node %<CR>",
  { buffer = true, noremap = true, silent = false, desc = "Run javascript file" }
)
