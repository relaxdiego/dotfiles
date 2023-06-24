-- Ensure lazy.nvim is installed and set up
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--commit=c1aad95",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Ensure plugins
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "2c59e0ff3da6514b03d853ebecb6c36c515a5d7d",
    build = ":TSUpdate"
  },
  {
    "relaxdiego/nvim-treesitter-context",
    branch = "fix/capture-test-scenario",
  },
  {
    -- Required by multiple plugins. See below.
    "nvim-lua/plenary.nvim",
    commit = "36aaceb6e93addd20b1b18f94d86aecc552f30c4"
  },
  {
    -- Required by multiple plugins. See below.
    "nvim-tree/nvim-web-devicons",
    commit = "14b3a5ba63b82b60cde98d0a40319d80f25e8301",
  },
  {
    "nvim-telescope/telescope.nvim",
    commit = "991d5db62451ee7a50944b84aaad4b58c3447b60",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    commit = "4c8ebf2e5f2b5ae10cd4347020bb0bb2e7e02384", -- From 1.x branch
    dependencies = {
      -- LSP Support
      {
        "neovim/nvim-lspconfig",
        commit = "08f1f34",
      }, -- Required
      {
        -- Optional
        "williamboman/mason.nvim",
        commit = "4be1226",
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
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "a138b14099e9623832027ea12b4631ddd2a49256",
  },
  {
    "jay-babu/mason-null-ls.nvim",
    commit = "54d702020bf94e4eefd357f0b738317af30217eb",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    commit = "d883632bf8f92f1d5abea4a9c28fb2f90aa795aa", -- v2.x branch
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MunifTanjim/nui.nvim",
        commit = 'f008972'
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    commit = "14a7524a8b259296713d4d77ef3c7f4dec501269",
  },
  {
    "nvim-lualine/lualine.nvim",
    commit = "05d78e9fd0cdfb4545974a5aa14b1be95a86e9c9",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
  },
  {
    "folke/trouble.nvim",
    commit = "2af0dd9767526410c88c628f1cbfcb6cf22dd683",
  },
  {
    "mbbill/undotree",
    commit = "485f01efde4e22cb1ce547b9e8c9238f36566f21",
  },
  {
    "tpope/vim-fugitive",
    commit = "5f0d280b517cacb16f59316659966c7ca5e2bea2",
  },
  {
    "windwp/nvim-autopairs",
    commit = "59df87a84c80a357ca8d8fe86e451b93ac476ccc",
  },
  {
    "kylechui/nvim-surround",
    commit = "10b20ca7d9da1ac8df8339e140ffef94f9ab3b18",
  },
  {
    "simrat39/symbols-outline.nvim",
    commit = "512791925d57a61c545bc303356e8a8f7869763c",
  },
  {
    "ludovicchabant/vim-gutentags",
    commit = "1337b1891b9d98d6f4881982f27aa22b02c80084",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    commit = "7075d7861f7a6bbf0de0298c83f8a13195e6ec01",
  },
  {
    'vim-test/vim-test',
    commit = '08250c56f11cb3460c8a02c8fdb80c8d39c92173',
  },
  {
    'relaxdiego/tslime.vim',
    commit = '28e9eba642a791c6a6b044433dce8e5451b26fb0',
  },
  {
    'github/copilot.vim',
    config = function()
      vim.cmd [[let g:copilot_no_tab_map = v:true]]
      -- Globally disable copilot on startup
      vim.cmd [[execute "Copilot disable"]]
    end,
    cmd = "Copilot"
  },
  {
    'rcarriga/nvim-notify',
    commit = 'ea9c8ce7a37f2238f934e087c255758659948e0f'
  },
  {
    'numToStr/Comment.nvim',
    commit = '176e85eeb63f1a5970d6b88f1725039d85ca0055'
  },
  {
    "folke/which-key.nvim",
    commit = 'd871f2b664afd5aed3dc1d1573bef2fb24ce0484',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      window = {
        border = "single",
      },
      show_help = false,
    }
  },
  {
    'Vimjas/vim-python-pep8-indent',
    commit = '60ba5e11a61618c0344e2db190210145083c91f8',
  }
})
