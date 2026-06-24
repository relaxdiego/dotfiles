return {
    "smjonas/inc-rename.nvim",
    commit = "0074b551a17338ccdcd299bd86687cc651bcb33d",
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
