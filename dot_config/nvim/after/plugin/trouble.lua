-- See: https://github.com/folke/trouble.nvim
-- List all linting errors
vim.keymap.set("n", "<leader>xx", vim.cmd.TroubleToggle)
require("trouble").setup({
  icons = false,
})
