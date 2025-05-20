local M = {}

-- Create groups for autocommands
local filetype_group = vim.api.nvim_create_augroup("FiletypeSettings", { clear = true })
local template_group = vim.api.nvim_create_augroup("TemplateFiletypes", { clear = true })

-- Force filetypes for chezmoi templates
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = template_group,
    pattern = "*.sh.tmpl",
    command = "setfiletype sh",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = template_group,
    pattern = "*.py.tmpl",
    command = "setfiletype python",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = template_group,
    pattern = "*.y*ml.tmpl",
    command = "setfiletype yaml",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = template_group,
    pattern = "*.y*ml.template",
    command = "setfiletype yaml",
})

-- Terraform specific settings
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = filetype_group,
    pattern = "terraform",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.smartindent = false
    end,
})

-- Jsonnet specific settings
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = filetype_group,
    pattern = "jsonnet",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Python
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = filetype_group,
    pattern = "python",
    callback = function()
        -- Fix for `Shift >>` not working when the line starts with `#`
        vim.opt_local.cindent = true
        vim.opt_local.cinkeys:remove("0#")
    end,
})

-- YAML specific settings
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = filetype_group,
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

-- Turn off colorcolumn for certain window types
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = filetype_group,
    pattern = { "qf", "Trouble" },
    callback = function()
        vim.opt_local.colorcolumn = ""
    end,
})

-- Set devbox.json filetype to json5 to support comments
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_group,
    pattern = "devbox.json",
    command = "setlocal filetype=json5",
})

-- Setup for *.*.jinja files
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
    -- Check if the current buffer has a filetype set by a modeline
    local current_filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if current_filetype ~= "" then
        return
    end

    -- Get the current buffer's name
    local full_path = vim.api.nvim_buf_get_name(0)
    local filename = full_path:match("^.+/(.+)$") or full_path

    -- Remove templated sections enclosed in {{ }}
    local sanitized_name = filename:gsub("{{.-}}", "")

    -- Extract all extensions from filenames like 'foo.bar.baz.qux'
    local extensions = {}
    for ext in sanitized_name:gmatch("%.([^%.]+)") do
        table.insert(extensions, ext)
    end

    -- Translate each extension to its corresponding language
    local translated_extensions = {}
    for _, ext in ipairs(extensions) do
        local lang = extension_to_language[ext] or ext
        table.insert(translated_extensions, lang)
    end

    -- Set the filetype to the concatenated translated extensions
    vim.bo.filetype = table.concat(translated_extensions, ".")
end

-- Create autocommand for handling dotted filetypes
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("DottedFileType", { clear = true }),
    pattern = "*.*.*",
    callback = set_dotted_filetype,
})

function M.setup()
    -- This function is empty but can be used if you want to
    -- add any additional setup logic in the future
end

-- Auto-setup when the module is required
M.setup()

return M
