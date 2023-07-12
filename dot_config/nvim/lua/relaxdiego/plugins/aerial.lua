return {
	"stevearc/aerial.nvim",
	commit = "79644dbedc189d79573b2a60e247989bbd8f16e7",
	event = "VeryLazy",
	config = function()
		require("aerial").setup({
			-- optionally use on_attach to set keymaps when aerial has attached to a buffer
			on_attach = function(bufnr)
				-- Jump forwards/backwards with '{' and '}'
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
			end,
			close_on_select = true,
			show_guides = true,
			autojump = true,
		})
		-- You probably also want to set a keymap to toggle aerial
		vim.keymap.set("n", "<leader>tb", "<cmd>AerialToggle<CR>")
	end,
}
