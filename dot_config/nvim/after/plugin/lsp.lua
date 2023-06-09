-- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#introduction
-- Troubleshooting: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#troubleshooting
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  local opts = { buffer = bufnr }

  -- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#introduction
  vim.keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
end)

vim.api.nvim_command("command! Format :lua vim.lsp.buf.format({ async = true})")
vim.api.nvim_exec(
  [[
  autocmd InsertLeave *.* Format
]],
  false
)

-- LSP list at https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- You can also use the :Mason command to interactively install LSPs
lsp.ensure_installed({
  "gopls",
  "lua_ls",
  "pylsp",
})

-- Autoformat
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

-- Autocompletion
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
})
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
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

vim.diagnostic.config({
  virtual_text = true,
})

--
-- Python
--

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
      },
    },
  },
})

--
-- Go
--

-- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
require("lspconfig").gopls.setup({})

--
-- Lua
--

-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
require("lspconfig").lua_ls.setup({
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
  -- See available sources: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  sources = {
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.isort,
    formatting.prettier,
    formatting.stylua,
    diagnostics.flake8,
  },
})
