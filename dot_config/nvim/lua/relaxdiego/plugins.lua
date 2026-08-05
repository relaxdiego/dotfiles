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
    -- Land the fresh clone on the pinned revision. Only on clone: checking out
    -- on every start would fight `Lazy sync`, and whichever ran last would win.
    -- From here on the plugins/lazy.lua spec is what holds the version.
    vim.fn.system({
        "git",
        "-C",      -- Execute the command in the provided directory
        lazypath,  -- The directory to execute the command in
        "checkout",
        require("relaxdiego.plugins.lazy").commit,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}
local dir = vim.fn.stdpath("config") .. "/lua/relaxdiego/plugins/"
local files = vim.fn.globpath(dir, "*.lua", false, true)

for _, file in ipairs(files) do
    local module = file:match("([^/]+)%.lua$")
    table.insert(plugins, require("relaxdiego.plugins." .. module))
end

require("lazy").setup(plugins, {
    -- Keep the lockfile inside the chezmoi source dir so `:Lazy update` writes
    -- straight into the repo, ready to commit. chezmoi skips source entries
    -- whose name starts with a dot, so .nvim/ is tracked by git but never
    -- installed into $HOME. See docs/nvim-plugins.md.
    lockfile = vim.fn.expand("~/.local/share/chezmoi/.nvim/lazy-lock.json"),
})
