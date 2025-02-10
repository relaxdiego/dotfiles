return {
    "nvim-telescope/telescope.nvim",
    commit = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026", -- v0.1.8
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
        -- See: https://github.com/nvim-telescope/telescope.nvim
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        require("telescope").setup({
            defaults = {
                -- Default configuration for telescope goes here:
                -- config_key = value,
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
            pickers = {
                find_files = {
                    find_command = {
                        "rg",
                        "--files",
                        "--hidden",
                        "--glob=!.git",
                        "--glob=!.serverless",
                        "--glob=!node_modules",
                        "--glob=!.venv",
                        "--glob=!tags",
                        "--glob=!tags.*",
                    },
                },
            },
        })

        vim.keymap.set("n", "<C-p>", builtin.find_files, {})
        vim.keymap.set("n", "<leader>ag", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>c", builtin.buffers, { desc = "Find buffer" })
        vim.keymap.set("n", "<leader>m", builtin.resume, { desc = "Resume last Telescope search" })
        vim.keymap.set("n", "<leader>p", builtin.pickers, { desc = "Telescope history" })
        vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "List references for word under the cursor" })
        vim.keymap.set("n", "<C-]>", builtin.lsp_definitions, {})
        vim.keymap.set("n", "<C-i>", ":Telescope treesitter<CR>", {})
        -- See which-key.lua for the description for the prefix 'gd'
        vim.keymap.set("n", "gdv", "<Esc><C-w>v<C-]>", { desc = "Goto definition in a vsplit" })
        vim.keymap.set("n", "gdh", "<Esc><C-w>s<C-]>", { desc = "Goto definition in a split" })
        vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "List implementations of symbol under cursor" })
        -- Others:
        -- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

        -- Same as above but using <leader>f as prefix
        -- See which-key.lua for the description for the prefix '<leader>f'
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {
            desc = "Find buffer",
        })

        vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, {
            desc = "Find definitions or jump if only 1 found",
        })

        vim.keymap.set("n", "<leader>ff", builtin.find_files, {
            desc = "Find files",
        })

        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
            desc = "Live grep",
        })

        vim.keymap.set("n", "<leader>fh", builtin.pickers, {
            desc = "Telescope history",
        })

        vim.keymap.set("n", "<leader>fp", builtin.resume, {
            desc = "Resume last Telescope search",
        })

        vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {
            desc = "List references for word under the cursor",
        })

        vim.keymap.set("n", "<leader>ft", builtin.help_tags, {
            desc = "List help tags",
        })
    end,
}
