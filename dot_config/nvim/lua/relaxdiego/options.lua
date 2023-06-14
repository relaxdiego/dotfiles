vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = false

-- Don't wrap to the beginning of the buffer when searching
vim.opt.wrapscan = false

-- Always open new vsplits to the right
vim.opt.splitright = true
-- Always open new hsplits to the bottom
vim.opt.splitbelow = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Turn on column rulers
vim.opt.colorcolumn = "72,80,88"
-- ...except for certain window types
vim.cmd("autocmd FileType qf setlocal colorcolumn=")
vim.cmd("autocmd FileType Trouble setlocal colorcolumn=")

vim.opt.list = true
vim.opt.listchars:append "trail:⇢"

-- Force filetypes for chezmoi templates
vim.cmd("autocmd BufNewFile,BufRead *.sh.tmpl setfiletype sh")
vim.cmd("autocmd BufNewFile,BufRead *.py.tmpl setfiletype python")
