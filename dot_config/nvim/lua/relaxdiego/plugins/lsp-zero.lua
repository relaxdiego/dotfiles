return {
	"VonHeikemen/lsp-zero.nvim",
	commit = "52582fc91efb40ee347c20570ff7d32849ef4a89", -- From 2.x branch
	event = "VeryLazy",
	dependencies = {
		{
			"neovim/nvim-lspconfig",
			-- commit = "b6b34b9",
			commit = "67f151e84daddc86cc65f5d935e592f76b9f4496",
		},
		{
			"williamboman/mason.nvim",
			commit = "664c987",
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			commit = "17a4934",
		},
		{
			"hrsh7th/nvim-cmp",
			commit = "b8c2a62",
		},
		{
			"hrsh7th/cmp-nvim-lsp",
			commit = "44b16d1",
		},
		{
			"hrsh7th/cmp-buffer",
			commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
		},
		{
			"hrsh7th/cmp-path",
			commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
		},
		{
			"saadparwaiz1/cmp_luasnip",
			commit = "18095520391186d634a0045dacaa346291096566",
		},
		{
			"hrsh7th/cmp-nvim-lua",
			commit = "f12408bdb54c39c23e67cab726264c10db33ada8",
		},
		{
			"hrsh7th/cmp-cmdline",
			commit = "8ee981b4a91f536f52add291594e89fb6645e451",
		},
		{
			"hrsh7th/cmp-nvim-lsp-signature-help",
			commit = "3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1",
		},
		{
			"L3MON4D3/LuaSnip",
			commit = "3d2ad0c0fa25e4e272ade48a62a185ebd0fe26c1",
		},
		{
			"rafamadriz/friendly-snippets",
			commit = "5749f09",
		},
	},
	config = function()
		-- See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#introduction
		-- Troubleshooting: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#troubleshooting
		local lsp = require("lsp-zero")

		-- LSP list at https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		-- You can also use the :Mason command to interactively install LSPs
		lsp.ensure_installed({
			"gopls",
			"lua_ls",
			"pylsp",
			"terraformls",
			"yamlls",
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
		-- For more config options, see:
		-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/integrate-with-null-ls.md
		lsp.format_on_save({
			format_opts = {
				async = false,
				timeout_ms = 3000,
			},
			servers = {
				["lua_ls"] = { "lua" },
				["gopls"] = { "go" },
				-- Which filetypes can null-ls operate on
				["null-ls"] = {
					"javascript",
					-- Null-ls is configured to use black; See plugins/null-ls.lua
					"python",
					"typescript",
					"lua",
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
				prefix = "●", -- Could be '■', '▎', 'x'
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
		-- See: nvim-notify.lua
		vim.notify = require("notify")
		vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
			vim.notify(result.message, lvl, {
				title = "LSP | " .. client.name,
				timeout = 5000,
				keep = function()
					return lvl == "ERROR" or lvl == "WARN"
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
		local util = require("lspconfig/util")
		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod" },
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					gofumpt = true,
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		})
		vim.cmd([[
            command! GoImports lua vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        ]])
		vim.cmd([[autocmd BufWritePre *.go,*.gomod,*.gosum lua vim.lsp.buf.format()]])

		-- Lua
		-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		})
		vim.cmd([[autocmd BufWritePre *.lua lua vim.lsp.buf.format()]])

		-- Terraform
		-- See: https://github.com/hashicorp/terraform-ls/blob/main/docs/USAGE.md#neovim-v080
		require("lspconfig").terraformls.setup({})
		vim.cmd([[autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()]])
		vim.cmd([[autocmd BufWritePre *.tf lua vim.lsp.buf.format()]])

		-- YAML
		-- See: https://github.com/b0o/SchemaStore.nvim
		require("lspconfig").yamlls.setup({
			settings = {
				yaml = {
					validate = true,
					completion = true,
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		})
		vim.cmd([[autocmd BufWritePre *.yaml,*.yml lua vim.lsp.buf.format()]])
	end,
}
