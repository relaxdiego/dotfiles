return {
    "nvim-treesitter/nvim-treesitter",
    commit = "v0.9.3",
    build = ":TSUpdate",
    config = function()
        -- Register the Caddyfile tree-sitter parser
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.caddyfile = {
            install_info = {
                url = "https://github.com/matthewpi/tree-sitter-caddyfile",
                files = { "src/parser.c" },
                branch = "master",
                revision = "2c74f94ca43748e01f336b774324b98f93aa0de4",
            },
            filetype = "caddyfile",
        }

        require("nvim-treesitter.configs").setup {
            -- A list of parser names, or "all"
            ensure_installed = {
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "hcl",
                "json",
                "lua",
                "python",
                "terraform",
                "toml",
                "vimdoc",
                "yaml",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },

            autotag = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        }
        -- Enable treesitter-based folding
        -- See: https://github.com/nvim-treesitter/nvim-treesitter#folding
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false
    end,
}
