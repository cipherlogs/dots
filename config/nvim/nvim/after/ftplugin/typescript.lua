vim.keymap.set(
  "n",
  ",r",
  ":w<CR>:!tsx %<CR>",
  { buffer = true, noremap = true, silent = false, desc = "Run typescript file" }
)
