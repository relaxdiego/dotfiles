return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
        local function compute_width()
            return math.floor(vim.o.columns * 0.9)
        end

        local function compute_height()
            return math.floor(vim.o.lines - 6)
        end

        local function compute_row()
            return math.floor((vim.o.lines - compute_height()) / 2)
        end

        local function compute_col()
            return math.floor((vim.o.columns - compute_width()) / 2)
        end

        local function get_win_config()
            return {
                relative = "editor",
                width = compute_width(),
                height = compute_height(),
                row = compute_row(),
                col = compute_col(),
            }
        end

        require("toggleterm").setup({
            -- General default settings
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                width = compute_width,
                height = compute_height,
                row = compute_row,
                col = compute_col,
            },
            -- Workaround for window size bug on initial open.
            -- Without this, ToggleTerm will occupy the entire height
            -- until you resize the terminal.
            on_open = function(term)
                vim.api.nvim_win_set_config(term.window, get_win_config())
            end,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        --
        -- BEGIN: Pop-up Lazygit config
        --

        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            on_close = function()
                require("neo-tree.events").fire_event("git_event")
            end,
        })

        local function toggle_lazygit()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>g", toggle_lazygit, { desc = "Toggle LazyGit", noremap = true, silent = true })

        --
        -- END: Pop-up Lazygit config
        --
    end,
}
