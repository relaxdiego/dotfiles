-- Run for more info: :lua require("neo-tree").paste_default_config()
require("neo-tree").setup({
    default_component_configs = {
        name = {
            trailing_slash = true
        },
    },
})
vim.cmd([[nnoremap <leader>nt :Neotree toggle<cr>]])
