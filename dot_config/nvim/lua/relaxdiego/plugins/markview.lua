return {
    "OXY2DEV/markview.nvim",
    commit = "3537eb2a9251cad5d7718253768f3772c62233fc", -- v28.3.0
    -- Load when a markdown buffer opens, but start with the preview OFF.
    -- Turn it on per buffer with <leader>mt (:Markview toggle).
    ft = "markdown",
    config = function()
        require("markview").setup({
            preview = {
                enable = false,
            },
        })
        -- When markview loads it attaches to already-open buffers using its
        -- default (preview on), BEFORE the setup above runs. That renders the
        -- buffer that triggered the load. Disable every buffer it auto-attached
        -- so nothing previews until <leader>mt.
        pcall(vim.cmd, "Markview Disable")
    end,
    keys = {
        {
            "<leader>mt",
            "<cmd>Markview toggle<cr>",
            desc = "Markview: toggle preview (buffer)",
        },
        {
            "<leader>ms",
            "<cmd>Markview splitToggle<cr>",
            desc = "Markview: toggle split preview",
        },
    },
}
