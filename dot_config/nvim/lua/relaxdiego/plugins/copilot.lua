return {
    "github/copilot.vim",
    commit = "1dcaf72099b436b5832d6117d9cd7a4a098a8d77", -- 1.35.0
    config = function()
        -- Set global variables
        vim.g.copilot_node_command = "~/.asdf/installs/nodejs/21.6.2/bin/node"
        vim.g.copilot_no_tab_map = true

        -- Key mappings
        vim.api.nvim_set_keymap('i', '<C-H>', 'copilot#Suggest()', {silent = true, script = true, expr = true})
        vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Next()', {silent = true, script = true, expr = true})
        vim.api.nvim_set_keymap('i', '<C-K>', 'copilot#Previous()', {silent = true, script = true, expr = true})
        vim.api.nvim_set_keymap('i', '<C-L>', 'copilot#Accept("\\<CR>")', {silent = true, script = true, expr = true})

        vim.keymap.set("n", "<leader>o", ":Copilot setup enable<CR>", { desc = "Start Github Copilot", silent = true })
    end,
}
