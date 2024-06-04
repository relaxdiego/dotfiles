return {
    "nvim-focus/focus.nvim",
    commit = "2c2c91d0bdb8ec9f67655c0e125953e27f5798c9",
    config = function()
        local ignore_filetypes = { 'neo-tree' }
        local ignore_buftypes = { 'nofile', 'prompt', 'popup' }
        local diffmode = vim.opt.diff:get()

        local augroup = vim.api.nvim_create_augroup('MaximizeFocusedWindowHeight', { clear = true })

        vim.api.nvim_create_autocmd('WinEnter', {
            group = augroup,
            callback = function(_)
                if not vim.tbl_contains(ignore_buftypes, vim.bo.buftype) and
                    not vim.tbl_contains(ignore_filetypes, vim.bo.filetype) and
                    not diffmode then
                    vim.cmd('wincmd _')
                end
            end,
        })

        -- See: Options <https://github.com/nvim-focus/focus.nvim/blob/master/lua/focus/init.lua>
        require("focus").setup({
            autoresize = {
                enable = false, -- Let the above autocmd handle resizing
            },
            ui = {
                cursorline = false, -- Always display cursorline in all buffers
                signcolumn = false, -- Always display the signcolumn in all buffers
            },
        })
    end,
}
