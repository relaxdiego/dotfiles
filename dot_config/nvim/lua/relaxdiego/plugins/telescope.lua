return {
    "nvim-telescope/telescope.nvim",
    commit = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026", -- v0.1.8
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
        -- See: https://github.com/nvim-telescope/telescope.nvim
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        require("telescope").setup({
            defaults = {
                -- Default configuration for telescope goes here:
                -- config_key = value,
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
        })

        vim.keymap.set("n", "<C-p>", builtin.find_files, {})
        vim.keymap.set("n", "<leader>ag", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>c", builtin.buffers, { desc = "Find buffer" })
        vim.keymap.set("n", "<leader>m", builtin.resume, { desc = "Resume last Telescope search" })
        vim.keymap.set("n", "<leader>p", builtin.pickers, { desc = "Telescope history" })
        vim.keymap.set("n", "<C-[>", builtin.lsp_references, { desc = "Lists LSP references for word under the cursor" })
        vim.keymap.set("n", "<C-]>", builtin.lsp_definitions,
            { desc =
            "Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope" })
        -- Others:
        -- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
}
