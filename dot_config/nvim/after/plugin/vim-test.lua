-- Run the tests in a tmux pane you specify
vim.cmd [[let test#strategy = "tslime"]]

if vim.fn.filereadable("pytest.ini") == 1 then
  vim.g["test#python#runner"] = 'pytest'
end

vim.g["test#shell#bats#options"] = "--recursive"
