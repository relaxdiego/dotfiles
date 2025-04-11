return {
    "smjonas/inc-rename.nvim",
    config = function()
        -- Setup inc-rename.nvim
        require("inc_rename").setup({
            show_message = true, -- Shows "Renaming..." status
        })
        vim.keymap.set(
            "n",
            "<leader>rn",
            ":IncRename ",
            { desc = "Rename all instances of symbol...", noremap = true, silent = true }
        )
    end,
}
