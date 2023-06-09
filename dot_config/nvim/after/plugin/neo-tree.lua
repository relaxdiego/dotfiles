-- Run for more info: :lua require("neo-tree").paste_default_config()
require("neo-tree").setup({
    default_component_configs = {
        name = {
            trailing_slash = true
        },
        icon = {
            folder_empty = ""
        },
        git_status = {
            symbols = {
                -- Change type
                added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted   = "✖",-- this can only be used in the git_status source
                renamed   = "",-- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "",
                staged    = "",
                conflict  = "",
            }
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_by_name = {
              "node_modules"
            },
        },
        hijack_netrw_behavior = "open_default",
    },
})

-- remaps
vim.cmd([[nnoremap <leader>nt :Neotree toggle<cr>]])
