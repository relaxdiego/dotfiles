return {
	"goolord/alpha-nvim",
	commit = "9e33db324b8bb7a147bce9ea5496686ee859461d",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local theme = require("relaxdiego.theme")
		return theme.config
	end,
}
