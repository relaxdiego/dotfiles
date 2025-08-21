return {
    "relaxdiego/alpha-nvim",
    commit = "150c518",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local theme = require "relaxdiego.theme"
        return theme.config
    end,
    config = function(_, opts)
        local alpha = require "alpha"

        -- Patch the problematic function before setup
        local term = require "alpha.term"
        local original_reposition = term.reposition
        term.reposition = function(parent_id, el, state, line)
            -- Check if el.wininfo exists before proceeding
            if not el or not el.wininfo or not el.wininfo[2] then
                return
            end
            return original_reposition(parent_id, el, state, line)
        end

        alpha.setup(opts)

        -- Additional safety: wrap the redraw autocmd
        vim.api.nvim_create_autocmd("WinResized", {
            group = vim.api.nvim_create_augroup("AlphaNvimSafety", { clear = true }),
            callback = function()
                -- Only trigger alpha redraw if buffer exists and is valid
                local alpha_buf = vim.fn.bufnr "*Alpha*"
                if alpha_buf ~= -1 and vim.api.nvim_buf_is_valid(alpha_buf) then
                    local ok, _ = pcall(function()
                        require("alpha").redraw()
                    end)
                    if not ok then
                        -- If redraw fails, don't propagate the error
                        return
                    end
                end
            end,
        })
    end,
}
