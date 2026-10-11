return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
}
