-- Force filetypes for chezmoi templates
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
  pattern = "*.sh.tmpl",
  command = "setfiletype sh",
})
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
  pattern = "*.py.tmpl",
  command = "setfiletype python",
})
