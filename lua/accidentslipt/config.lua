local M = {
	symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
	no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest" },
	highlight = { fg = "#957CC6", bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"] },
	events = { "WinEnter", "BufEnter", "WinResized", "VimResized", "ColorScheme", "ColorSchemePre" },
	anchor = {
		left = { height = 1, x = -1, y = -1 },
		right = { height = 1, x = -1, y = 0 },
		up = { width = 0, x = -1, y = 0 },
		bottom = { width = 0, x = 1, y = 0 },
	},
	auto_group = vim.api.nvim_create_augroup("accidentslipt", { clear = true }),
}

return M
