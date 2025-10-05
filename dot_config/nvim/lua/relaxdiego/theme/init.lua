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

-- Auto-open Neo-tree when Alpha dashboard is displayed
dashboard.config.opts.setup = function()
    vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
            -- Longer delay to let Alpha finish all initialization
            vim.defer_fn(function()
                vim.cmd("Neotree show")
                -- Use vim.schedule to run after all pending operations
                vim.schedule(function()
                    vim.defer_fn(function()
                        -- Find and focus the Neo-tree window
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            local buf_name = vim.api.nvim_buf_get_name(buf)
                            if string.match(buf_name, "neo%-tree") then
                                vim.api.nvim_set_current_win(win)
                                break
                            end
                        end
                    end, 100)
                end)
            end, 200)
        end,
    })
end

return dashboard
