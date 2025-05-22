-- FIXME: This plugin has been archived by the author and is no longer maintained.
--        We will need to replace it with https://github.com/nvimtools/none-ls.nvim
--        once it is on par with null-ls and stable.
return {
    "relaxdiego/null-ls.nvim",
    commit = "4f1cfc1", -- Uses ruff format correctly
    event = "VeryLazy",
    -- Configured by lsp/null_ls.lua
}
