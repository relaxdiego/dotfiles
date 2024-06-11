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
vim.opt.smartindent = true

-- The above indentation config messes up terraform. The following
-- fixes that at the expense of no auto indentation on enter.
vim.cmd("autocmd FileType terraform setlocal sts=2 ts=2 sw=2")
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "terraform",
    command = ":set nosmartindent",
})

vim.cmd("autocmd FileType jsonnet setlocal sts=2 ts=2 sw=2")

-- Force neovim to indent yamls properly
vim.cmd("autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab")

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
vim.opt.listchars:append("trail:⇢")

-- Enable folding for markdown files
vim.g.markdown_folding = 1
-- Don't fold on open
vim.opt.foldenable = false

vim.cmd("colorscheme kanagawa-dragon")
-- The Tree Sitter capture "@comment.arrange_act_assert" is defined in queries/python/highlights.scm
-- The highlight group "ArrangeActAssertComment" is defined in plugins/colorscheme-kanagawa.lua
vim.api.nvim_set_hl(0, "@comment.arrange_act_assert", { link = "ArrangeActAssertComment" })
vim.cmd("set cursorline")

-- Disable "Auto-wrap test using 'textwidth'"
vim.opt.formatoptions:remove("t")

-- Set devbox.json filetype to json5 to support comments
vim.cmd("autocmd BufNewFile,BufRead devbox.json setlocal filetype=json5")

-- BEGIN: Automatically set the filetype for *.*.jinja files.
--
-- From `:h ft`
--     When a dot appears in the value then this separates two filetype names
--     (Example: foo.c.jinja), this will use the "c" filetype first, then the
--     "jinja" filetype. This works both for filetype plugins and for syntax
--     files.  More than one dot may appear.

-- Mapping of file extensions to language names
local extension_to_language = {
    py = "python",
    rb = "ruby",
    js = "javascript",
    ts = "typescript",
    cpp = "cpp",
    h = "c_header",
}

local function set_dotted_filetype()
    -- Get the current buffer's name
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Extract the 'XXX.YYY' from filenames like 'foo.XXX.YYY'
    -- It captures the last two extensions before the end of the filename
    local match = bufname:match("%.([^.]+%.[^.]+)$")
    if match then
        local ext1, ext2 = match:match("([^.]+)%.([^.]+)")

        -- Translate extensions using the mapping table
        local lang1 = extension_to_language[ext1] or ext1
        local lang2 = extension_to_language[ext2] or ext2

        -- Set the filetype to 'lang1.lang2'
        vim.bo.filetype = lang1 .. "." .. lang2
    end
end

-- Create an autocommand group for custom filetype settings
vim.api.nvim_create_augroup("DottedFileType", { clear = true })

-- Add an autocommand to this group
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        group = "DottedFileType",
        pattern = "*.*.*",
        callback = set_dotted_filetype,
    }
)
--
-- END: Automatically set the filetype for *.*.jinja files.
--
