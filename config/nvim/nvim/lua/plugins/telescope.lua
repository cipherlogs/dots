return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<C-k>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<C-b>", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
