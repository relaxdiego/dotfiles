return {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    config = function()
        local sysname = vim.loop.os_uname().sysname
        local browser_cmd
        if sysname == "Darwin" then
            browser_cmd = "open"
        elseif sysname == "Linux" then
            browser_cmd = "xdg-open"
        elseif sysname == "Windows_NT" then
            browser_cmd = "start"
        end

        if browser_cmd then
            vim.api.nvim_create_user_command("Browse", function(opts)
                local result = vim.fn.system({ browser_cmd, opts.fargs[1] })
                if vim.v.shell_error ~= 0 then
                    vim.notify("Failed to open URL with " .. browser_cmd .. ": " .. opts.fargs[1], vim.log.levels.ERROR)
                end
            end, { nargs = 1 })
        else
            vim.api.nvim_create_user_command("Browse", function(opts)
                vim.notify("Unsupported OS: " .. sysname, vim.log.levels.WARN)
            end, { nargs = 1 })
        end
    end,
    keys = {
        { "gh", ":GBrowse<CR>",      mode = "n", desc = "Open GitHub URL for current line" },
        { "gh", ":'<,'>GBrowse<CR>", mode = "v", desc = "Open GitHub URL for selected lines" },
    },
}
