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
        "rose-pine/neovim",
        commit = "6b7b38bbb3dac648dbf81f2728ce1101f476f920",
        as = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    }

    use {
        "catppuccin/nvim",
        commit = "233c4175780d9b4e39ae4fe4535c1e4c14bd76ed",
        as = "catppuccin",
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
end)
