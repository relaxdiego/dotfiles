-- Find more keymaps in ../mappings.lua
return {
    "mrjones2014/smart-splits.nvim",
    commit = "2c61c95a4eabdba7cd91f229fbd43103a188b992",
    event = "VeryLazy",
    config = function()
        require("smart-splits").setup({
            ignored_filetypes = { "Neotree" },
            at_edge = "stop",
        })

        -- From: https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file#usage

        -- resizing splits
        -- these keymaps will also accept a range,
        -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
        -- In iTerm2 you'll need to go to Preferences > Profile > Keys > Key Mappings
        -- and map Command-{h,j,k,l} as Escape sequence {h,j,k,l} respectively
        vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
        vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
        vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
        vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)

        -- moving between splits
        vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
        vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
        vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
        vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
        vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

        -- swapping buffers between windows
        vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left, { desc = "Swap buffer left" })
        vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down, { desc = "Swap buffer down" })
        vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up, { desc = "Swap buffer up" })
        vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right, { desc = "Swap buffer right" })
    end,
}
