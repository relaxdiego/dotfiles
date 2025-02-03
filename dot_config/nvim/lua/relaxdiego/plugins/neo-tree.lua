-- Disable netrw completely
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

return {
    "nvim-neo-tree/neo-tree.nvim",
    commit = "e6645ecfcba3e064446a6def1c10d788c9873f51", -- From v3.x branch
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "MunifTanjim/nui.nvim",
            commit = "f008972",
        },
    },
    event = "VeryLazy",
    config = function()
        -- See: https://github.com/nvim-neo-tree/neo-tree.nvim
        -- Run for more info: :lua require("neo-tree").paste_default_config()
        require("neo-tree").setup({
            default_component_configs = {
                name = {
                    trailing_slash = false,
                },
                icon = {
                    folder_empty = "",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "✚",
                        modified = "",
                        deleted = "✖", -- this can only be used in the git_status source
                        renamed = "", -- this can only be used in the git_status source
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "",
                        staged = "",
                        conflict = "",
                    },
                },
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                },
                hijack_netrw_behavior = "open_default",
                use_libuv_file_watcher = true,
                window = {
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["v"] = "open_vsplit",
                        ["<C-v>"] = "open_vsplit",
                        ["x"] = "open_split",
                        ["<C-x>"] = "open_split",
                        -- Don't map `f` so that we can use that for parrot.nvim
                        ["f"] = false,
                    },
                    fuzzy_finder_mappings = {
                        ["<C-j>"] = "move_cursor_down",
                        ["<C-k>"] = "move_cursor_up",
                    },
                },
            },
            buffers = {
                -- This needs to be commented out to disable since
                -- enabled = false still enables the feature!
                -- follow_current_file = {
                --     enabled = false,
                -- },
            },
            renderers = {
                directory = {
                    { "indent" },
                    { "icon" },
                    { "current_filter" },
                    {
                        "container",
                        content = {
                            { "name",      zindex = 10 },
                            {
                                "symlink_target",
                                zindex = 10,
                                highlight = "NeoTreeSymbolicLinkTarget",
                            },
                            { "clipboard", zindex = 10 },
                            {
                                "diagnostics",
                                errors_only = true,
                                zindex = 20,
                                align = "right",
                                hide_when_expanded = true,
                            },
                            { "git_status", zindex = 20, align = "right", hide_when_expanded = true },
                        },
                    },
                },
                file = {
                    { "indent" },
                    { "icon" },
                    {
                        "container",
                        content = {
                            {
                                "name",
                                zindex = 10,
                            },
                            {
                                "symlink_target",
                                zindex = 10,
                                highlight = "NeoTreeSymbolicLinkTarget",
                            },
                            { "clipboard",   zindex = 10 },
                            { "bufnr",       zindex = 10 },
                            { "modified",    zindex = 20, align = "right" },
                            { "diagnostics", zindex = 20, align = "right" },
                            { "git_status",  zindex = 20, align = "right" },
                        },
                    },
                },
                message = {
                    { "indent", with_markers = false },
                    { "name",   highlight = "NeoTreeMessage" },
                },
                terminal = {
                    { "indent" },
                    { "icon" },
                    { "name" },
                    { "bufnr" },
                },
            },
        })

        -- remaps
        vim.cmd([[nnoremap <leader>nt :Neotree toggle<cr>]])

        vim.cmd([[:hi link NeoTreeSymbolicLinkTarget NeoTreeDotFile]])
    end,
}
