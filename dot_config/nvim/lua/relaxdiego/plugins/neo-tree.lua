-- Disable netrw completely
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

return {
    "nvim-neo-tree/neo-tree.nvim",
    commit = "4adbc1371713a65888c483487fa642983c1d9080",
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
        -- Adapted from: https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
        local function getTelescopeOpts(state, path)
            return {
                cwd = path,
                search_dirs = { path },
                attach_mappings = function(prompt_bufnr, map)
                    local actions = require("telescope.actions")
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local action_state = require("telescope.actions.state")
                        local selection = action_state.get_selected_entry()
                        local filename = selection.filename
                        if filename == nil then
                            filename = selection[1]
                        end
                        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
                    end)
                    return true
                end,
            }
        end

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
                    width = 28,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["v"] = "open_vsplit",
                        ["<C-v>"] = "open_vsplit",
                        ["x"] = "open_split",
                        ["<C-x>"] = "open_split",
                        ["<C-f>"] = function(state)
                            vim.cmd("normal! \x06") -- <C-f> in normal mode
                        end,
                        ["<C-b>"] = function(state)
                            vim.cmd("normal! \x02") -- <C-b> in normal mode
                        end,
                        -- Don't map `f` so that we can use that for parrot.nvim
                        ["f"] = false,
                        -- Override the default / key map
                        ["/"] = "find_and_jump_to_file",
                        ["tf"] = "find_file_in_current_node_and_jump_to_it",
                        ["tg"] = "live_grep_files_in_current_node_and_jump_to_it",
                    },
                    fuzzy_finder_mappings = {
                        ["<C-j>"] = "move_cursor_down",
                        ["<C-k>"] = "move_cursor_up",
                    },
                },
            },
            commands = {
                -- Adapted from: https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
                find_and_jump_to_file = function(state)
                    -- state.path refers to the root node
                    require("telescope.builtin").find_files(getTelescopeOpts(state, state.path))
                end,
                find_file_in_current_node_and_jump_to_it = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    require("telescope.builtin").find_files(getTelescopeOpts(state, path))
                end,
                live_grep_files_in_current_node_and_jump_to_it = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
                end,
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
                            { "name", zindex = 10 },
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
                            { "clipboard", zindex = 10 },
                            { "bufnr", zindex = 10 },
                            { "modified", zindex = 20, align = "right" },
                            { "diagnostics", zindex = 20, align = "right" },
                            { "git_status", zindex = 20, align = "right" },
                        },
                    },
                },
                message = {
                    { "indent", with_markers = false },
                    { "name", highlight = "NeoTreeMessage" },
                },
                terminal = {
                    { "indent" },
                    { "icon" },
                    { "name" },
                    { "bufnr" },
                },
            },
        })

        local reveal_current_file_in_neotree = function()
            local neotree_bufnr = vim.fn.bufnr("NeoTree")
            if neotree_bufnr ~= -1 then
                require("neo-tree").refresh()
            else
                vim.cmd("Neotree reveal_file=" .. vim.fn.expand("%:p"))
            end
        end

        -- remaps
        vim.keymap.set("n", "<leader>nt", ":Neotree toggle<cr>", {
            desc = "Toggle Neotree",
        })

        vim.cmd([[:hi link NeoTreeSymbolicLinkTarget NeoTreeDotFile]])

        vim.keymap.set("n", "gt", reveal_current_file_in_neotree, {
            desc = "Go to current file in neo-tree",
        })
    end,
}
