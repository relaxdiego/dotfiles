vim.cmd [[imap <silent><script><expr> <C-H> copilot#Suggest()]]
vim.cmd [[imap <silent><script><expr> <C-J> copilot#Next()]]
vim.cmd [[imap <silent><script><expr> <C-K> copilot#Previous()]]
vim.cmd [[imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")]]
