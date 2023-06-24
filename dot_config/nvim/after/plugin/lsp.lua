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


-- See more presets: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/api-reference.md#presetopts
lsp.preset({
  name = "recommended",
  set_lsp_keymaps = true,
  -- LSP Zero recommends that we configure nvim-cmp directly if we want to customize it.
  manage_nvim_cmp = false,
})

-- Executes the anonymous function everytime an LSP server is attached to the
-- current buffer. See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/api-reference.md#on_attachcallback
lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  local opts = { buffer = bufnr }

  -- Go to a symbol's definition
  -- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/lsp.md
  vim.keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
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

-- Add a border to :LspInfo window
require("lspconfig.ui.windows").default_options.border = "single"

-- Show helpful text next to code if there are linter errors
-- See: https://smarttech101.com/nvim-lsp-diagnostics-keybindings-signs-virtual-texts/#configuration_of_virtual_and_floating_text
vim.diagnostic.config({
  virtual_text = {
    -- source = "always",  -- Or "if_many"
    prefix = '●', -- Could be '■', '▎', 'x'
  },
  -- Set the order in which signs and virtual text are displayed.
  severity_sort = true,
  float = {
    -- Always shows diagnostic-source
    source = "always", -- Or "if_many"
  },
})

-- Autocompletions
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require("lsp-zero").cmp_action()
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  preselect = "none",
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- Enable "Super Tab" https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/autocomplete.md#enable-super-tab
    ["<Tab>"] = cmp_action.luasnip_supertab(),
    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lsp_signature_help" },
  },
})

-- Autcompletion for / and ?
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Autocompletion for vim commands
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Use nvim-notify for displaying LSP messages
-- See: https://github.com/rcarriga/nvim-notify
vim.notify = require("notify")
vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 5000,
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end

--
-- Configuration of various LSPs
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--

-- Python
require("lspconfig")["pylsp"].setup({
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
})

-- Go
-- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
require("lspconfig").gopls.setup({
  capabilities = capabilities,
})

-- Lua
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

-- Pseudo LSPs (Black, iSort, etc)
-- See: https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
  -- Set this to true to start logging
  -- Also use ":checkhealth null-ls" for more troubleshooting
  debug = false,
  log_level = "warn",
  -- See available sources: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  sources = {
    diagnostics.flake8,
    formatting.black,
    formatting.isort,
    formatting.prettierd,
    formatting.stylua,
  },
})
