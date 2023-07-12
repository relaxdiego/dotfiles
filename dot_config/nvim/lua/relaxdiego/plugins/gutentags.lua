return {
	"ludovicchabant/vim-gutentags",
	commit = "1337b1891b9d98d6f4881982f27aa22b02c80084",
	config = function()
		vim.g.gutentags_enabled = 1
		vim.g.gutentags_ctags_executable = "ctags"
	end,
}
