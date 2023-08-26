return {
    "relaxdiego/alpha-nvim",
    commit = "150c518",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local theme = require("relaxdiego.theme")
        return theme.config
    end,
}
