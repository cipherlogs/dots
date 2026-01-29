vim.diagnostic.config { signs = false }

local configs = require "nvchad.configs.lspconfig"
local servers = {
  -- lua_ls = {
  --   settings = {
  --     Lua = {
  --       diagnostics = {
  --         globals = { "vim" },
  --       },
  --       hint = { enable = true },
  --     },
  --   },
  -- },
  html = {},
  cssls = {
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        colorDecorators = false,
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
  ts_ls = {
    init_options = {
      preferences = {
        importModuleSpecifierPreference = "non-relative",
      },
    },
    settings = {
      completions = {
        completeFunctionCalls = false,
      },
    },
    on_attach = function(client, bufnr)
      configs.on_attach(client, bufnr)

      vim.keymap.set("n", "<leader>fm", function()
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { "source.addMissingImports.ts" },
            diagnostics = {},
          },
        }
      end, {
        buffer = bufnr,
        desc = "TS > Format & Add missing imports",
      })
    end,
  },
  hls = {
    filetypes = { "haskell", "lhaskell", "cabal" },
  },
  eslint = {},
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.capabilities = configs.capabilities

  if not opts.on_attach then
    opts.on_attach = configs.on_attach
  end

  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- lspconfig.hls.setup({
--   filetypes = { 'haskell', 'lhaskell', 'cabal' },
--   capabilities = capabilities,
--   on_init = on_init,
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     on_attach(client, bufnr)
--   end,
-- })
