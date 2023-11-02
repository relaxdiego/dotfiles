return {
    "windwp/nvim-autopairs",
    commit = "59df87a84c80a357ca8d8fe86e451b93ac476ccc",
    config = function()
        -- See: https://github.com/windwp/nvim-autopairs
        require("nvim-autopairs").setup({
            disable_filetype = { "TelescopePrompt", "vim" },
            -- Use treesitter to check for a pair
            check_ts = true,
            -- Don't add pairs if it already has a close pair in the same line
            enable_check_bracket_line = true,
        })
    end,
}
