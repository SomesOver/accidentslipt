local M = {
	symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
	no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest" },
	highlight = { fg = "#957CC6", bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"] },
	events = { "WinEnter", "BufEnter", "WinResized", "VimResized" },
	anchor = {
		left = { height = 1, x = -1, y = -1 },
		right = { height = 1, x = -1, y = 0 },
		up = { width = 0, x = -1, y = 0 },
		bottom = { width = 0, x = 1, y = 0 },
	},
	auto_group = vim.api.nvim_create_augroup("accidentslipt", { clear = true }),
}

function M:merge_options(opts)
	if type(opts) == "table" and opts ~= {} then
		M = vim.tbl_deep_extend("force", M, opts)
	end
end

function M.highlight()
	local opts = M.highlight

	function check_version(major, minor, patch)
		return major >= vim.version()["major"] and minor >= vim.version()["minor"] and patch >= vim.version()["patch"]
	end

	if check_version(0, 9, 0) then
		-- `nvim_get_hl` is added in 0.9.0
		if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "NvimSeparator" })) then
			vim.api.nvim_set_hl(0, "NvimSeparator", opts)
		end
	else
		-- if name is not existed, `nvim_get_hl_by_name` return an error
		local ok, _ = pcall(vim.api.nvim_get_hl_by_name, "NvimSeparator", false)
		if not ok then
			vim.api.nvim_set_hl(0, "NvimSeparator", opts)
		end
	end
end

return M
