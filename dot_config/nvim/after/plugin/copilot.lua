vim.cmd [[imap <silent><script><expr> <C-H> copilot#Suggest()]]
vim.cmd [[imap <silent><script><expr> <C-J> copilot#Next()]]
vim.cmd [[imap <silent><script><expr> <C-K> copilot#Previous()]]
vim.cmd [[imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")]]
vim.cmd [[let g:copilot_no_tab_map = v:true]]
-- Globally disable copilot on startup
vim.cmd [[execute "Copilot disable"]]
