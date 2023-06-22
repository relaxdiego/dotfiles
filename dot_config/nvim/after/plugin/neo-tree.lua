-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
-- Run for more info: :lua require("neo-tree").paste_default_config()
require("neo-tree").setup({
  default_component_configs = {
    name = {
      trailing_slash = true,
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
      visible = true,
      hide_by_name = {
        "node_modules",
      },
    },
    hijack_netrw_behavior = "open_default",
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
      }
    }
  },
  buffers = {
    follow_current_file = true,
  },
})

-- remaps
vim.cmd([[nnoremap <leader>nt :Neotree toggle<cr>]])

if vim.fn.argc() == 0 then
  vim.cmd [[:NeoTreeShow]]
end
