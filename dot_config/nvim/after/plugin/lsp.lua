-- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#introduction
-- Troubleshooting: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#troubleshooting
local lsp = require("lsp-zero")

-- LSP list at https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- You can also use the :Mason command to interactively install LSPs
lsp.ensure_installed({
  "gopls",
  "lua_ls",
  "pylsp",
})

lsp.preset({
  name = "recommended",
  set_lsp_keymaps = true,
  manage_nvim_cmp = false,
})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  local opts = { buffer = bufnr }

  -- Go to a symbol's definition
  -- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/lsp.md
  vim.keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
end)

-- Autoformat on save
lsp.format_on_save({
  format_opts = {
    async = true,
  },
  servers = {
    ["lua_ls"] = { "lua" },
    ["gopls"] = { "go" },
    -- Which filetypes can null-ls operate on
    ["null-ls"] = {
      "javascript",
      -- Null-ls is configured to use black; See below
      "python",
      "typescript",
    },
  },
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = "",
    warn = "",
    hint = "󰉀",
    info = "",
  },
})

lsp.setup()

-- TODO: Figure out what this does
vim.diagnostic.config({
  virtual_text = true,
})

-- Autocompletions
local cmp = require 'cmp'
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  preselect = 'none',
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    -- Enable "Super Tab" https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/autocomplete.md#enable-super-tab
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

--
-- Python
--

require('lspconfig')['pylsp'].setup {
  capabilities = capabilities,
  -- See: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
      },
    },
  },
}

--
-- Go
--

-- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
require("lspconfig").gopls.setup({
  capabilities = capabilities,
})

--
-- Lua
--

-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
require("lspconfig").lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  log_level = 'warn',
  -- See available sources: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  sources = {
    formatting.black,
    formatting.isort,
    formatting.prettierd,
    formatting.stylua,
    diagnostics.flake8,
  },
})
