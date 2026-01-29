return {
  "nvim-lua/plenary.nvim",
  -- load it lazily so it doesn't affect startup too much
  event = "VeryLazy",
  config = function()
    -- call the module (module must live at lua/slot_manager.lua)
    require("slot_manager").setup { scope = "repo" } -- choose "repo"|"branch"|"global"
  end,
}
