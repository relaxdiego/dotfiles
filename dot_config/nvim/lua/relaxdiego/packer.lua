vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  use({
    "wbthomason/packer.nvim",
    commit = "ed2d5c9c17f4df2eeaca4878145fecc9669e0138",
  })

  use({
    "nvim-telescope/telescope.nvim",
    commit = "991d5db62451ee7a50944b84aaad4b58c3447b60",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  use({
    "rebelot/kanagawa.nvim",
    commit = "14a7524a8b259296713d4d77ef3c7f4dec501269",
    as = "kanagawa",
  })

  use({
    "folke/trouble.nvim",
    commit = "2af0dd9767526410c88c628f1cbfcb6cf22dd683",
    config = function()
      require("trouble").setup({
        icons = false,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    commit = "2c59e0ff3da6514b03d853ebecb6c36c515a5d7d",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })
  use({
    "relaxdiego/nvim-treesitter-context",
    branch = "fix/capture-test-scenario",
  })

  use({
    "mbbill/undotree",
    commit = "485f01efde4e22cb1ce547b9e8c9238f36566f21",
  })

  use({
    "tpope/vim-fugitive",
    commit = "5f0d280b517cacb16f59316659966c7ca5e2bea2",
  })

  use({
    "VonHeikemen/lsp-zero.nvim",
    commit = "4c8ebf2e5f2b5ae10cd4347020bb0bb2e7e02384", -- From 1.x branch
    requires = {
      -- LSP Support
      {
        "neovim/nvim-lspconfig",
        commit = "08f1f34",
      }, -- Required
      {
        -- Optional
        "williamboman/mason.nvim",
        commit = "4be1226",
        run = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      {
        "hrsh7th/nvim-cmp",
        commit = 'b8c2a62'
      },                              -- Required
      { "hrsh7th/cmp-nvim-lsp" },     -- Required
      { "hrsh7th/cmp-buffer" },       -- Optional
      { "hrsh7th/cmp-path" },         -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-nvim-lua" },     -- Optional
      {
        'hrsh7th/cmp-cmdline',
        commit = '8ee981b4a91f536f52add291594e89fb6645e451'
      },
      {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        commit = '3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1'
      },

      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        commit = 'a13af80734eb28f744de6c875330c9d3c24b5f3b'
      },
      {
        "rafamadriz/friendly-snippets",
        commit = '49ca2a0e0e26427b550b1f64272d7fe7e4d7d51b'
      },
    },
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    commit = "a138b14099e9623832027ea12b4631ddd2a49256",
  })
  use({
    "jay-babu/mason-null-ls.nvim",
    commit = "54d702020bf94e4eefd357f0b738317af30217eb",
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    commit = "d883632bf8f92f1d5abea4a9c28fb2f90aa795aa", -- v2.x branch
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      {
        "MunifTanjim/nui.nvim",
        commit = 'f008972'
      },
    },
  })

  use({
    "nvim-lualine/lualine.nvim",
    commit = "05d78e9fd0cdfb4545974a5aa14b1be95a86e9c9",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
  })

  use({
    "windwp/nvim-autopairs",
    commit = "59df87a84c80a357ca8d8fe86e451b93ac476ccc",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  use({
    "kylechui/nvim-surround",
    commit = "10b20ca7d9da1ac8df8339e140ffef94f9ab3b18",
  })

  use({
    "simrat39/symbols-outline.nvim",
    commit = "512791925d57a61c545bc303356e8a8f7869763c",
  })

  use({
    "ludovicchabant/vim-gutentags",
    commit = "1337b1891b9d98d6f4881982f27aa22b02c80084",
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    commit = "7075d7861f7a6bbf0de0298c83f8a13195e6ec01",
  })

  use({
    'vim-test/vim-test',
    commit = '08250c56f11cb3460c8a02c8fdb80c8d39c92173',
  })

  use({
    'relaxdiego/tslime.vim',
    commit = '28e9eba642a791c6a6b044433dce8e5451b26fb0',
  })

  use({
    'github/copilot.vim'
  })

  use({
    'rcarriga/nvim-notify',
    commit = 'ea9c8ce7a37f2238f934e087c255758659948e0f'
  })

  use({
    'numToStr/Comment.nvim',
    commit = '176e85eeb63f1a5970d6b88f1725039d85ca0055'
  })
end)
