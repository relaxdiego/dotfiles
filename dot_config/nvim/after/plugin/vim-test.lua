-- See: https://github.com/vim-test/vim-test
vim.keymap.set("n", "<leader>s", ":TestNearest<CR>", { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>t", ":TestFile<CR>", { desc = "Run tests from current buffer" })
vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", { desc = "Run all tests" })
vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { desc = "Run last test" })
vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", { desc = "Go to last executed test" })

-- Run the tests in a tmux pane you specify
-- See: https://github.com/jgdavey/tslime.vim
vim.g["test#strategy"] = "tslime"

if vim.fn.filereadable("pytest.ini") == 1 then
  vim.g["test#python#runner"] = 'pytest'
end

vim.g["test#shell#bats#options"] = "--recursive"
