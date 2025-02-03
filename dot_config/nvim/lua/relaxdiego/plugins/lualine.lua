return {
    "nvim-lualine/lualine.nvim",
    commit = "05d78e9fd0cdfb4545974a5aa14b1be95a86e9c9",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
        local function parrot_status()
            if vim.bo.filetype == "neo-tree" then
                return ""
            end
            local status_info = require("parrot.config").get_status_info()
            return string.format("󰚩 %s", status_info.model)
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { { "branch", icon = "" }, "filename" },
                lualine_c = { "diagnostics" },
                lualine_x = {},
                lualine_y = { parrot_status, "encoding", "filetype" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = {},
                lualine_y = { parrot_status },
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
        -- We don't need the extra vim mode info now that lualine is in use
        vim.cmd("set noshowmode")
    end,
}
