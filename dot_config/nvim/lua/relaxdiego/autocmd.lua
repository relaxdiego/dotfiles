vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
    pattern = "*.sh.tmpl",
    command = "setfiletype sh"
})
