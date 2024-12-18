return {
    "lukas-reineke/indent-blankline.nvim",
    commit = "3fe94b8", -- v3.7.2
    config = function()
        -- See: https://github.com/lukas-reineke/indent-blankline.nvim
        -- Adds indentation guides to all lines (including empty lines).

        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { fg = "#2f2f2f", nocombine = true })
        end)

        require("ibl").setup({
            indent = {
                highlight = {
                    "IndentBlanklineIndent",
                }
            },

            -- Show the scope of the variable under the cursor
            scope = {
                show_start = false,
                show_end = false
            },
        })
    end,
}
