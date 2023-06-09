local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

require("telescope").setup({
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
})

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.find_files, {})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>ag", builtin.live_grep, {})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
