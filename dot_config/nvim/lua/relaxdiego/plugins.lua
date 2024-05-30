-- Ensure lazy.nvim is installed and set up
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.fn.system({
    "git",
    "-C",      -- Execute the command in the provided directory
    lazypath,  -- The directory to execute the command in
    "checkout",
    "de0a911", -- v9.25.0
})
vim.opt.rtp:prepend(lazypath)

local plugins = {}
local dir = vim.fn.stdpath("config") .. "/lua/relaxdiego/plugins/"
local files = vim.fn.globpath(dir, "*.lua", false, true)

for _, file in ipairs(files) do
    local module = file:match("([^/]+)%.lua$")
    table.insert(plugins, require("relaxdiego.plugins." .. module))
end

require("lazy").setup(plugins)
