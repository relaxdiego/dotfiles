require("alpha")
require("alpha.term")

local dashboard = require("alpha.themes.dashboard")
dashboard.section.buttons.val = {
    dashboard.button("Ctrl p", "󰈞  Find file", "<C-P>"),
    dashboard.button("<leader> ag", "󰑑  Live grep"),
    dashboard.button("<leader> nt", "󰙅  Toggle tree"),
    dashboard.button("e", "  New file", "<cmd>ene <CR>"),
    dashboard.button("(Sorry, you're stuck)", "󰩈  Quit", ":q<CR>"),
}

-- get list of files that match the pattern '*.sh'
local dir = vim.fn.stdpath("config") .. "/lua/relaxdiego/theme/art/"
local files = vim.fn.globpath(dir, "*.sh", false, true)
math.randomseed(os.time())
local art_file = files[math.random(#files)]

-- get the height of the current window
local MIN_HEIGHT_FOR_ART = 30
local win_id = vim.api.nvim_get_current_win()
local height = vim.api.nvim_win_get_height(win_id)

if height > MIN_HEIGHT_FOR_ART then
    dashboard.section.terminal.command = "cat | " .. art_file
    dashboard.section.terminal.width = 25
    dashboard.section.terminal.height = 13
end

local smol = {
    "█▄░█ █▀▀ █▀█ █░█ █ █▀▄▀█",
    "█░▀█ ██▄ █▄█ ▀▄▀ █ █░▀░█",
}

local header = {
    type = "text",
    val = smol,
    opts = {
        position = "center",
        hl = "Type",
    },
}

dashboard.section.header = header

local layout = {
    { type = "padding", val = 1 },
}

if height > MIN_HEIGHT_FOR_ART then
    table.insert(layout, dashboard.section.terminal)
    table.insert(layout, { type = "padding", val = 1 })
end

table.insert(layout, dashboard.section.header)
table.insert(layout, { type = "padding", val = 2 })
table.insert(layout, dashboard.section.buttons)
table.insert(layout, { type = "padding", val = 1 })
table.insert(layout, dashboard.section.footer)

dashboard.config.layout = layout

-- Setup function for dashboard behavior
dashboard.config.opts.setup = function()
    -- Close alpha buffer when another buffer is opened in a normal window
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local buftype = vim.api.nvim_buf_get_option(buf, "filetype")
            local win = vim.api.nvim_get_current_win()
            local win_config = vim.api.nvim_win_get_config(win)

            -- Check if we're entering a real file buffer in a normal (non-floating) window
            if buftype ~= "alpha" and buftype ~= "neo-tree" and win_config.relative == "" then
                -- Close all terminal windows associated with alpha first
                for _, w in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_is_valid(w) then
                        local win_buf = vim.api.nvim_win_get_buf(w)
                        if vim.api.nvim_buf_is_valid(win_buf) then
                            local term_buftype = vim.api.nvim_buf_get_option(win_buf, "buftype")
                            -- Close terminal windows that are part of alpha
                            if term_buftype == "terminal" then
                                pcall(vim.api.nvim_win_close, w, true)
                            end
                        end
                    end
                end

                -- Find and delete the alpha buffer
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "filetype") == "alpha" then
                        vim.api.nvim_buf_delete(b, { force = true })
                    end
                end
            end
        end,
    })
end

return dashboard
