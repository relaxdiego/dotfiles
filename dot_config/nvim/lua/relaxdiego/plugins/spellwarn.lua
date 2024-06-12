return {
    "ravibrock/spellwarn.nvim",
    commit = "bff398d623eafab49f2019e95660ec0a07421855",
    event = "VeryLazy",
    -- If you re-enable this plugin, you should also uncomment the spelling
    -- vim options in optionas.lua.
    enable = false,
    config = function()
        require("spellwarn").setup(
            {
                event = { -- event(s) to refresh diagnostics on
                    "CursorHold",
                    "InsertLeave",
                    "TextChanged",
                    "TextChangedI",
                    "TextChangedP",
                    "TextChangedT",
                },
                ft_config = {
                    -- spellcheck method: "cursor", "iter", or boolean
                    alpha   = false,
                    help    = false,
                    lazy    = false,
                    lspinfo = false,
                    mason   = false,
                    python  = "iter",
                    lua     = "iter"
                },
                ft_default = true,   -- default option for unspecified filetypes
                max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
                severity = {
                    -- severity for each spelling error type (false to disable diagnostics for that type)
                    spellbad   = "WARN",
                    spellcap   = false,
                    spelllocal = "HINT",
                    spellrare  = "INFO",
                },
                prefix = "possible misspelling(s): ", -- prefix for each diagnostic message
            }
        )
    end,
}
