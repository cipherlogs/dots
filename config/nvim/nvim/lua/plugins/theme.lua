return {
  "tiagovla/tokyodark.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    custom_highlights = function(_, p)
      return {
        Normal = { fg = p.fg, bg = p.black },
        EndOfBuffer = { fg = p.bg2, bg = p.black },
        Delimiter = { link = "@keyword" },

        Comment = { italic = true, fg = "#9192a1" },
        ["@comment"] = { italic = true, fg = "#9192a1" },

        ["@ibl.scope.underline.1"] = { bg = "#32344e" },
        Visual = { link = "PmenuSel" },

        ["@tag.builtin"] = { link = "@tag" },
        ["@tag.delimiter"] = { link = "@tag" },

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

        ["@variable"] = { bold = true },
        ["@string"] = { fg = p.fg },
        ["@variable.parameter"] = { link = "@variable" },
        -- ponytail: "@normal" is not a real group (carried over from old
        -- chadrc as-is); the link resolves empty, i.e. member vars stay plain
        ["@variable.member"] = { link = "@normal" },
        ["@constant"] = { link = "@variable" },
        ["@function"] = { link = "@variable" },
        ["@function.call"] = { bold = true },
        ["@function.method.call"] = { bold = true },
        ["@function.method"] = { link = "@variable" },
      }
    end,
  },
  config = function(_, opts)
    require("tokyodark").setup(opts)
  end,
}
