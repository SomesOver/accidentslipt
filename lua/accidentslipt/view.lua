local utils = require("accidentslipt.utils")
local direction = require("accidentslipt.utils").direction
local LINE = require("accidentslipt.line")
local symbols = require("accidentslipt.config").symbols
local anchor = require("accidentslipt.config").anchor
local auto_group = require("accidentslipt.config").auto_group
local config = require("accidentslipt.config")

local M = {
	wins = {
		[direction.left] = LINE:create_horizontal_line(0),
		[direction.right] = LINE:create_horizontal_line(0),
		[direction.up] = LINE:create_vertical_line(0),
		[direction.bottom] = LINE:create_vertical_line(0),
	},
}

function M:init()
	self.wins[direction.left].start_symbol = symbols[3]
	self.wins[direction.left].body_symbol = symbols[2]
	self.wins[direction.left].end_symbol = symbols[5]

	self.wins[direction.right].start_symbol = symbols[4]
	self.wins[direction.right].body_symbol = symbols[2]
	self.wins[direction.right].end_symbol = symbols[6]

	self.wins[direction.up].start_symbol = symbols[1]
	self.wins[direction.up].body_symbol = symbols[1]
	self.wins[direction.up].end_symbol = symbols[1]

	self.wins[direction.bottom].start_symbol = symbols[1]
	self.wins[direction.bottom].body_symbol = symbols[1]
	self.wins[direction.bottom].end_symbol = symbols[1]

	M.highlight()
	vim.api.nvim_create_autocmd(config.events, {
		group = auto_group,
		callback = function(opts)
			if utils.check_by_no_execfiles() then
				return
			end
			self:dividing_split_line()
		end,
	})
end

function M:dividing_split_line()
	local c_win_pos = vim.api.nvim_win_get_position(0)
	local c_win_width = vim.fn.winwidth(0)
	local c_win_height = vim.fn.winheight(0)

	local win_count = utils.calculate_number_windows()
	--vim.notify(
	--	"height: " .. c_win_height .. "\nwidth: " .. c_win_width .. "\nx: " .. c_win_pos[1] .. "\ny:" .. c_win_pos[2]
	--)
	if utils.direction_have(direction.left) then
		local win = self.wins[direction.left]
		local anchor_height = anchor.left.height
		local anchor_x = anchor.left.x
		local anchor_y = anchor.left.y

		if win_count == 2 then
			local height = c_win_height + anchor_height
			anchor_height = anchor_height - (height - math.ceil(height / 2))
		end
		win:set_height(c_win_height + anchor_height)
		if not utils.direction_have(utils.direction.up) then
			anchor_x = anchor_x + 1
		end

		if not win:is_show() then
			win:move(c_win_pos[1] + anchor_x, c_win_pos[2] + anchor_y)
			win:show()
		else
			win:smooth_move_x(win:x(), c_win_pos[1] + anchor_x)
			win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y)
		end
	else
		self.wins[direction.left]:hide()
	end

	if utils.direction_have(direction.right) then
		local win = self.wins[direction.right]
		local anchor_height = anchor.right.height
		local anchor_x = anchor.right.x
		local anchor_y = anchor.right.y

		if win_count == 2 then
			local height = c_win_height + anchor_height
			anchor_height = anchor_height - (height - math.ceil(height / 2))
			anchor_x = anchor_x - anchor_height + 1
		end
		win:set_height(c_win_height + anchor_height)

		if not utils.direction_have(utils.direction.up) then
			anchor_x = anchor_x + 1
		end
		--win:smooth_move_x(win:x(), c_win_pos[1] + anchor_x)
		--win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y + c_win_width)
		if not win:is_show() then
			win:move(c_win_pos[1] + anchor_x, c_win_pos[2] + anchor_y + c_win_width)
			win:show()
		else
			win:smooth_move_x(win:x(), c_win_pos[1] + anchor_x)
			win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y + c_win_width)
		end
	else
		self.wins[direction.right]:hide()
	end

	if utils.direction_have(direction.up) then
		local win = self.wins[direction.up]
		local anchor_width = anchor.up.width
		local anchor_x = anchor.up.x
		local anchor_y = anchor.up.y

		if win_count == 2 then
			local width = c_win_width + anchor_width
			anchor_width = anchor_width - (width - math.ceil(width / 2))
		end
		win:set_width(c_win_width + anchor_width)

		if not win:is_show() then
			win:move(c_win_pos[1] + anchor_x, c_win_pos[2] + anchor_y)
			win:show()
		else
			win:smooth_move_x(win:x(), c_win_pos[1] + anchor_x)
			win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y)
		end
	else
		self.wins[direction.up]:hide()
	end

	if utils.direction_have(direction.bottom) then
		local win = self.wins[direction.bottom]
		local anchor_width = anchor.bottom.width
		local anchor_x = anchor.bottom.x
		local anchor_y = anchor.bottom.y

		if win_count == 2 then
			local width = c_win_width + anchor_width
			anchor_width = anchor_width - (width - math.ceil(width / 2))
			anchor_y = anchor_y - anchor_width + 1
		end
		win:set_width(c_win_width + anchor_width)

		if not win:is_show() then
			win:move(c_win_pos[1] + c_win_height + anchor_x, c_win_pos[2] + anchor_y)
			win:show()
		else
			win:smooth_move_x(win:x(), c_win_pos[1] + c_win_height + anchor_x)
			win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y)
		end
	else
		self.wins[direction.bottom]:hide()
	end
end

function M.highlight()
	local opts = config.highlight

	if utils.check_version(0, 9, 0) then
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
