require("alpha")
require("alpha.term")

local dashboard = require("relaxdiego.theme.dashboard")
dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", "<cmd>ene <CR>"),
	dashboard.button("Ctrl p", "󰈞  Find file"),
	dashboard.button("<leader> ag", "󰑑  Live Grep"),
	dashboard.button("(Sorry, you're stuck)", "󰩈  Quit"),
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
	dashboard.section.terminal.opts.redraw = true
else
	dashboard.section.terminal.height = 1
end

local header = {
	type = "text",
	-- Generated with: https://fsymbols.com/generators/carty/
	val = {
		"█▄░█ █▀▀ █▀█ █░█ █ █▀▄▀█",
		"█░▀█ ██▄ █▄█ ▀▄▀ █ █░▀░█",
	},
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
