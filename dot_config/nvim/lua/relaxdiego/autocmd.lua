-- Force filetypes for chezmoi templates
vim.api.nvim_command('autocmd BufNewFile,BufRead *.sh.tmpl setfiletype sh')
vim.api.nvim_command('autocmd BufNewFile,BufRead *.py.tmpl setfiletype python')
