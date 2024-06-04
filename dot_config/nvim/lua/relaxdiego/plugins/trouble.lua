return {
    "folke/trouble.nvim",
    commit = "46a19388d3507f4c4bebb9994bf821a79b3bc342", -- v3.1.0
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "All Diagnostics (Trouble)",
        },
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },

}
