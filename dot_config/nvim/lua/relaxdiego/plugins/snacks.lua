return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true,
        },
        indent = {
            enabled = true,
        },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        quickfile = {
            enabled = true,
        },
        scope = {
            enabled = true,
        },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
    },
    config = function(_, opts)
        local snacks = require("snacks")   -- Load the plugin module
        snacks.setup(opts)                 -- Explicitly call setup with the opts table
        vim.api.nvim_create_user_command("NotificationsHistory", function()
            snacks.notifier.show_history() -- Use the local module table
        end, {})
    end,
}
