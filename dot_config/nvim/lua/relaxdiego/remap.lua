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

-- Keep cursor in the middle when jumping through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Don't lose what's in the register after pasting
vim.keymap.set("x", "p", "pgvy")

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')

-- Search and replace live
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Recursively unfold the block where the cursor is, fold everything else
--   zM - fold everything
--   zv - unfold just enough so that the line under the cursor is visible
--   zc - fold block where the cursor is (we need this so that zO has an effect)
--   zO - recursively unfold the block where the cursor is
--   z. - Redraw curosor line to center of window, cursor on first non-blank
-- See: :help z
vim.keymap.set("n", "zz", "<Esc>zMzvzczOz.")

-- See: https://github.com/vim-test/vim-test
-- See: https://github.com/relaxdiego/tslime.vim
vim.keymap.set("n", "<leader>s", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>t", ":TestFile<CR>")
vim.keymap.set("n", "<leader>a", ":TestSuite<CR>")
vim.keymap.set("n", "<leader>l", ":TestLast<CR>")
vim.keymap.set("n", "<leader>g", ":TestVisit<CR>")
-- Run the tests in a tmux pane you specify
vim.cmd [[let test#strategy = "tslime"]]
