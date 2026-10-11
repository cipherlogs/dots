local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

local servers = {
  html = {},
  cssls = {
    settings = {
      css = {
        validate = true,
        lint = { unknownAtRules = "ignore" },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        emmetCompletions = true,
        classAttributes = {
          "class",
          "className",
          "classNames",
          "class:list",
          "classList",
          "styles",
          "classes",
        },
        experimental = {
          classRegex = {
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          },
        },
      },
    },
  },
  emmet_language_server = {},
  biome = {},
  jsonls = {},
  ruff = {},
  prismals = {},
  lua_ls = {
    settings = {
      Lua = { diagnostics = { globals = { "vim" } } },
    },
  },
  ts_ls = {
    init_options = {
      preferences = { importModuleSpecifierPreference = "non-relative" },
    },
    settings = {
      completions = { completeFunctionCalls = false },
    },
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<leader>fm", function()
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { "source.addMissingImports.ts" },
            diagnostics = {},
          },
        }
      end, { buffer = bufnr, desc = "TS add missing imports" })
    end,
  },
  eslint = {},
}

for name, opts in pairs(servers) do
  opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
