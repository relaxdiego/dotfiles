--
-- Find other remaps for respective plugins at .config/nvim/after/plugin/*.lua
--

vim.g.mapleader = ","

-- Toggle soft wrap
vim.keymap.set("n", "<leader>sw", ":set wrap!<CR>")

-- Easier split movement
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
