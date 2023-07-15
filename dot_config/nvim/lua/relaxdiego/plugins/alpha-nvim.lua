return {
    "relaxdiego/alpha-nvim",
    commit = "b0f1744",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local theme = require("relaxdiego.theme")
        return theme.config
    end,
}
