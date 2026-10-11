return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local keys = {}
    local chars = { "h", "j", "k", "l", ";", "g", "f", "d", "s", "a" }
    for i, char in ipairs(chars) do
      keys[#keys + 1] = {
        string.format("<leader>%d", i),
        function()
          local list = require("harpoon"):list()
          if list:get(i) ~= nil then
            list:replace_at(i)
          else
            list:add()
          end
        end,
        desc = string.format("Harpoon add/replace at slot %d", i),
      }
      keys[#keys + 1] = {
        string.format("<BS>%s", char),
        function()
          require("harpoon"):list():select(i)
        end,
        desc = string.format("Harpoon go to slot %d", i),
      }
    end
    return keys
  end,
  config = function()
    require("harpoon"):setup()
  end,
}
