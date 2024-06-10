return {
    "f-person/git-blame.nvim",
    commit = "408d5487d908dfe5d48e5645d8b27ddcc16b11e0",
    config = function()
        require("gitblame").setup({
            -- See: Config options <https://github.com/f-person/git-blame.nvim?tab=readme-ov-file#configuration>

            -- Have the blame message start, at a minimum, on the given column.
            -- If the line is longer than the given value, the blame message will
            -- start at EOL.
            virtual_text_column = 40
        })
    end,
}
