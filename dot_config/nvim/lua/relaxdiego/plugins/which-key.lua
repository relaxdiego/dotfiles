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
	},
}
