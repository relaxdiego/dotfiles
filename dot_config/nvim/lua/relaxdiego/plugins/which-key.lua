return {
    "folke/which-key.nvim",
    commit = "d871f2b664afd5aed3dc1d1573bef2fb24ce0484",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        window = {
            border = "single",
        },
        show_help = false,
        defaults = {
            ["<leader>f"] = { name = "Telescope to..." },
            ["gd"] = { name = "Goto definition..." },
            ["f"] = { name = "AI...", mode = { "n", "v" } },
            ["fc"] = { name = "Complete...", mode = { "n", "v", "x" } },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end,
}
