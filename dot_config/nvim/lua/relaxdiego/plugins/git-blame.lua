return {
    "f-person/git-blame.nvim",
    commit = "408d5487d908dfe5d48e5645d8b27ddcc16b11e0",
    -- Named for the same reason as in treesitter.lua: an old clone reports the
    -- pre-rename branch and rewrites the lockfile on every apply.
    branch = "main",
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
