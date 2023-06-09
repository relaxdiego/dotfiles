local lsp = require("lsp-zero")

lsp.preset("recommended")

-- LSP list at https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- You can also use the :Mason command to interactively install LSPs
lsp.ensure_installed({
  "gopls",
  "pylsp",
})

-- Fix Undefined global "vim"
lsp.nvim_workspace()


local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "",
        warn = "",
        hint = "",
        info = ""
    }
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- See: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
require("lspconfig").pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
            enabled = false,
        },
        pyflakes = {
            enabled = false,
        },
      }
    }
  }
})

-- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
require("lspconfig").gopls.setup({})

require("mason-null-ls").setup({
    ensure_installed = {
        "black",
        "blackd-client",
        "gofumpt",
        "isort",
        "jq",
        "luaformatter",
        "markdown-toc",
        "markdownlint",
        "prettier",
        "shellcheck",
        "shfmt",
        "yamlfmt",
    },
    automatic_installation = false,
    handlers = {}
})
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = true,
    sources = {
        formatting.black.with({ extra_args = {"--fast"} }),
        formatting.isort,
        formatting.prettier,
        diagnostics.flake8,
    }
})

vim.cmd [[ command! Format execute "lua vim.lsp.buf.format({async=true})" ]]
vim.api.nvim_exec([[
  autocmd BufWritePost *.py Format
]], false)
