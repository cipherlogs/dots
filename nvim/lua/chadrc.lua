local M = {}

M.ui = {
  statusline = {
    theme = "minimal",
  },
  tabufline = {
    enabled = false,
  },
  cmp = {
    lspkind_text = true,
    style = "flat_light",
  },
}

M.base46 = {
  theme = "tokyodark",
  hl_override = {
    Normal = { bg = { "black", -2 } },
    -- Include = { bold = true },
    -- Number = { bold = true },
    Delimiter = { link = "@keyword" },

    ["Comment"] = { italic = true, fg = "#9192a1" },
    ["@comment"] = { italic = true, fg = "#9192a1" },

    ["@ibl.scope.underline.1"] = { bg = "#32344e" },
    ["Visual"] = { link = "PmenuSel" },
    -- ["@tag.attribute"] = { bold = true },
    ["@tag.builtin"] = { link = "@tag" },
    ["@tag.delimiter"] = { link = "@tag" },
    -- ["@keyword"] = { bold = true },
    ["@keyword.conditional"] = { link = "@keyword" },
    ["@keyword.conditional.ternary"] = { link = "@keyword" },
    ["@keyword.directive"] = { link = "@keyword" },
    ["@keyword.directive.define"] = { link = "@keyword" },
    ["@keyword.exception"] = { link = "@keyword" },
    ["@keyword.function"] = { link = "@keyword" },
    ["@keyword.import"] = { link = "@keyword" },
    ["@keyword.operator"] = { link = "@keyword" },
    ["@keyword.repeat"] = { link = "@keyword" },
    ["@keyword.return"] = { link = "@keyword" },
    ["@keyword.sotrage"] = { link = "@keyword" },

    ["@type.builtin"] = { bold = true },
    Type = { link = "@type.builtin" },

    -- ["@constant"] = { bold = true },
    -- ["@constant.builtin"] = { bold = true },
    ["@variable"] = { bold = true },
    ["@string"] = { fg = { "white", -1 } },
    ["@variable.parameter"] = { link = "@variable" },
    ["@variable.member"] = { link = "@normal" },
    -- ["@variable.member"] = { bold = true },
    -- ["Type"] = { bold = true },
    ["@constant"] = { link = "@variable" },
    ["@function"] = { link = "@variable" },
    ["@function.call"] = { bold = true },
    ["@function.method.call"] = { bold = true },
    ["@function.method"] = { link = "@variable" },
  },
}

M.plugins = "plugins"

return M
