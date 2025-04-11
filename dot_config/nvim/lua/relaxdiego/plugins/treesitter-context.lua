return {
    "relaxdiego/nvim-treesitter-context",
    commit = "f6c99b64111ab1424c8fde3d9a6f3cd08234f8cb",
    config = function()
        require("treesitter-context").setup({
            max_lines = 3,
            min_window_height = 30,
        })
    end,
}
