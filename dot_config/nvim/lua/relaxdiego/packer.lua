vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    use {
        "wbthomason/packer.nvim",
        commit = "ed2d5c9c17f4df2eeaca4878145fecc9669e0138"
    }

    use {
      "nvim-telescope/telescope.nvim",
      commit = "991d5db62451ee7a50944b84aaad4b58c3447b60",
      requires = { {"nvim-lua/plenary.nvim"} }
    }

    use {
        "rebelot/kanagawa.nvim",
        commit = "14a7524a8b259296713d4d77ef3c7f4dec501269",
        as = "kanagawa",
    }

    use {
        "folke/trouble.nvim",
        commit = "2af0dd9767526410c88c628f1cbfcb6cf22dd683",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        commit = "2c59e0ff3da6514b03d853ebecb6c36c515a5d7d",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-context",
        commit = "e2ea37627c0681421ccf4a3cf19d68bb958e1817",
    }
    -- Run :TSPlaygroundToggle to explore the current buffer"s syntax tree
    use {
        "nvim-treesitter/playground",
        commit = "2b81a018a49f8e476341dfcb228b7b808baba68b"
    }

    use {
        "mbbill/undotree",
        commit = "485f01efde4e22cb1ce547b9e8c9238f36566f21",
    }

    use {
        "tpope/vim-fugitive",
        commit = "5f0d280b517cacb16f59316659966c7ca5e2bea2",
    }

    use {
        "VonHeikemen/lsp-zero.nvim",
        commit = "4c8ebf2e5f2b5ae10cd4347020bb0bb2e7e02384", -- From 1.x branch
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        }
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        commit = "a138b14099e9623832027ea12b4631ddd2a49256",
    }
    use {
        "jay-babu/mason-null-ls.nvim",
        commit = "54d702020bf94e4eefd357f0b738317af30217eb",
    }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        commit = "d883632bf8f92f1d5abea4a9c28fb2f90aa795aa",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }

    use {
        'nvim-lualine/lualine.nvim',
        commit = "05d78e9fd0cdfb4545974a5aa14b1be95a86e9c9",
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    use {
        "windwp/nvim-autopairs",
        commit = "59df87a84c80a357ca8d8fe86e451b93ac476ccc",
        config = function() require("nvim-autopairs").setup {} end
    }

    use {
        "kylechui/nvim-surround",
        commit = "10b20ca7d9da1ac8df8339e140ffef94f9ab3b18",
    }

    use {
        'simrat39/symbols-outline.nvim',
        commit = "512791925d57a61c545bc303356e8a8f7869763c",
    }
end)
