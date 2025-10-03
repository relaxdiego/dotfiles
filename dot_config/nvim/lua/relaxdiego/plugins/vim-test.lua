return {
    "relaxdiego/vim-test",
    commit = "c63b94c1e5089807f4532e05f087351ddb5a207c",
    config = function()
        -- See: https://github.com/vim-test/vim-test
        vim.keymap.set("n", "<leader>s", ":TestNearest<CR>", { desc = "Run nearest test" })
        vim.keymap.set("n", "<leader>t", ":TestFile<CR>", { desc = "Run tests from current buffer" })
        vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", { desc = "Run all tests" })
        vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { desc = "Run last test" })
        vim.keymap.set("n", "<leader>v", ":TestVisit<CR>", { desc = "Go to last executed test" })

        -- Run the tests in a tmux pane you specify
        -- See: https://github.com/jgdavey/tslime.vim
        vim.g["test#strategy"] = "tslime"

        -- Check for either pytest.ini or pyproject.toml with pytest configuration
        local function has_pytest_config()
            if vim.fn.filereadable("pytest.ini") == 1 then
                return true
            end

            if vim.fn.filereadable("pyproject.toml") == 1 then
                -- Read the pyproject.toml file
                local lines = vim.fn.readfile("pyproject.toml")
                -- Look for tool.pytest.ini_options stanza
                for _, line in ipairs(lines) do
                    if line:match("^%[tool%.pytest%.ini_options%]") then
                        return true
                    end
                end
            end
            return false
        end

        -- Check if current file is a file in tests/bdd/features
        local function is_pytest_bdd_test()
            local current_file = vim.fn.expand("%:p")
            return current_file:match("/tests/bdd/features/") ~= nil
        end

        -- Set pytest as runner if any condition is met
        if has_pytest_config() then
            vim.g["test#python#runner"] = "pytest"
        end

        -- Set up an autocmd to check for BDD tests and set appropriate options
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            pattern = "*",
            callback = function()
                if is_pytest_bdd_test() then
                    vim.g["test#python#pytest#options"] = "-m bdd -vv --gherkin-terminal-reporter"
                else
                    vim.g["test#python#pytest#options"] = ""
                end
            end,
        })

        vim.g["test#shell#bats#options"] = "--recursive"
    end,
}
