return {
    "github/copilot.vim",
    commit = "1a28401",
    config = function()
        vim.cmd([[let g:copilot_no_tab_map = v:true]])
        vim.cmd([[execute "Copilot setup"]])
        vim.cmd([[execute "Copilot enable"]])

        vim.cmd([[imap <silent><script><expr> <C-H> copilot#Suggest()]])
        vim.cmd([[imap <silent><script><expr> <C-J> copilot#Next()]])
        vim.cmd([[imap <silent><script><expr> <C-K> copilot#Previous()]])
        vim.cmd([[imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")]])
    end,
}
