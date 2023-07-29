require("alpha")
require("alpha.term")

local dashboard = require("alpha.themes.dashboard")
dashboard.section.buttons.val = {
	dashboard.button("Ctrl p", "󰈞  Find file", "<C-P>"),
	dashboard.button("<leader> ag", "󰑑  Live Grep"),
	dashboard.button("<leader> nt", "󰙅  Tree view"),
	dashboard.button("e", "  New file", "<cmd>ene <CR>"),
	dashboard.button("(Sorry, you're stuck)", "󰩈  Quit", ":q<CR>"),
}

-- get list of files that match the pattern '*.sh'
local dir = vim.fn.stdpath("config") .. "/lua/relaxdiego/theme/art/"
local files = vim.fn.globpath(dir, "*.sh", false, true)
math.randomseed(os.time())
local art_file = files[math.random(#files)]

-- get the height of the current window
local win_id = vim.api.nvim_get_current_win()
local height = vim.api.nvim_win_get_height(win_id)

if height > 30 then
	dashboard.section.terminal.command = "cat | " .. art_file
	dashboard.section.terminal.width = 25
	dashboard.section.terminal.height = 13
else
	dashboard.section.terminal.height = 1
end

local smol = {
	"█▄░█ █▀▀ █▀█ █░█ █ █▀▄▀█",
	"█░▀█ ██▄ █▄█ ▀▄▀ █ █░▀░█",
}

local header = {
	type = "text",
	val = smol,
	opts = {
		position = "center",
		hl = "Type",
	},
}

dashboard.section.header = header

dashboard.config.layout = {
	{ type = "padding", val = 1 },
	dashboard.section.terminal,
	{ type = "padding", val = 1 },
	dashboard.section.header,
	{ type = "padding", val = 2 },
	dashboard.section.buttons,
	{ type = "padding", val = 1 },
	dashboard.section.footer,
}

return dashboard
