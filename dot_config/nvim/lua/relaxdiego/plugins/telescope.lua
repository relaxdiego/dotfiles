return {
	"nvim-telescope/telescope.nvim",
	commit = "991d5db62451ee7a50944b84aaad4b58c3447b60",
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
		})

		vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		vim.keymap.set("n", "<leader>ag", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>c", builtin.buffers, { desc = "Find buffer" })
		-- Others:
		-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	end,
}
