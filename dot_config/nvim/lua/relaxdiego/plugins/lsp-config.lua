return {
    "neovim/nvim-lspconfig",
    commit = "0b8165c", -- v0.1.8
    event = "VeryLazy",
    dependencies = {
        -- LSP Management
        {
            "williamboman/mason.nvim",
            commit = "c43eeb5614a09dc17c03a7fb49de2e05de203924", -- v1.10.0
            build = function()
                pcall(vim.cmd, "MasonUpdate")
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            commit = "9ae570e", -- v1.29.0
        },
        -- For formatters and linters
        {
            "nvimtools/none-ls.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },
        -- Schema support
        {
            "b0o/schemastore.nvim",
            commit = "f0ca13e2634f08f127e086909d18a9387a47e760",
        },
        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            commit = "5260e5e8ecadaf13e6b82cf867a909f54e15fd07",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "hrsh7th/cmp-nvim-lua",
                "saadparwaiz1/cmp_luasnip",
            },
        },
        -- Snippets
        {
            "L3MON4D3/LuaSnip",
            commit = "3d2ad0c0fa25e4e272ade48a62a185ebd0fe26c1",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
    },
    config = function()
        -- Load shared LSP utilities
        local lsp_utils = require("relaxdiego.plugins.lsp")

        -- Set logging level
        vim.lsp.set_log_level("error")

        -- Setup diagnostic signs and configuration
        lsp_utils.setup_diagnostic_signs()
        lsp_utils.setup_diagnostics()

        -- Add border to LspInfo window
        require("lspconfig.ui.windows").default_options.border = "single"

        -- Setup Mason for LSP server management
        require("mason").setup({
            ui = {
                border = "single",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "gopls",
                "lua_ls",
                "pylsp",
                "terraformls",
                "yamlls",
                "jsonls",
                "pyright",
            },
        })

        -- Setup completion
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Load snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                -- Tab completion
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
                { name = "nvim_lua" },
            }),
            preselect = cmp.PreselectMode.None,
        })

        -- Autocompletion for / and ?
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

        -- Setup null-ls
        local null_ls = require("null-ls")

        -- Create a context object to share with language modules
        local lsp_context = {
            capabilities = lsp_utils.get_capabilities(),
            null_ls = null_ls,
            null_ls_sources = {},
        }

        -- Load basic null-ls configuration
        require("relaxdiego.plugins.lsp.null_ls").setup(null_ls)

        -- Initialize each language-specific configuration with shared context
        require("relaxdiego.plugins.lsp.python").setup(lsp_context)
        require("relaxdiego.plugins.lsp.lua").setup(lsp_context)
        require("relaxdiego.plugins.lsp.go").setup(lsp_context)
        require("relaxdiego.plugins.lsp.terraform").setup(lsp_context)
        require("relaxdiego.plugins.lsp.yaml").setup(lsp_context)
        require("relaxdiego.plugins.lsp.json").setup(lsp_context)

        -- Start null-ls with all configured sources from language modules
        null_ls.setup({
            debug = false,
            sources = lsp_context.null_ls_sources,
        })
    end,
}
