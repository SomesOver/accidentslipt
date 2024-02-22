local utils = require("accidentslipt.utils")
local direction = require("accidentslipt.utils").direction
local LINE = require("accidentslipt.line")
local auto_group = require("accidentslipt.config").auto_group
local config = require("accidentslipt.config")

local M = {}

function M:init(opts)
	M.config = config:merge_options(opts)
	symbols = M.config.symbols

	self.wins = {
		[direction.left] = LINE:create_horizontal_line(0, symbols[3], symbols[2], symbols[5]),
		[direction.right] = LINE:create_horizontal_line(0, symbols[4], symbols[2], symbols[6]),
		[direction.up] = LINE:create_vertical_line(0, symbols[1], symbols[1], symbols[1]),
		[direction.bottom] = LINE:create_vertical_line(0, symbols[1], symbols[1], symbols[1]),
	}

	config.highlight()
	vim.api.nvim_create_autocmd(M.config.events, {
		group = auto_group,
		callback = function()
			if utils.check_by_no_execfiles(M.config.no_exec_files) then
				return
			end
			self:dividing_split_line()
		end,
	})

	vim.api.nvim_create_autocmd({ "ColorScheme", "ColorSchemePre" }, {
		group = auto_group,
		callback = function()
			config.highlight()
		end,
	})
end

function M:dividing_split_line()
	local anchor = M.config.anchor
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

		local x = c_win_pos[1] + anchor_x
		local y = c_win_pos[2] + anchor_y

		if not win:is_show() then
			win:move(x, y)
			win:show()
		elseif y == win:y() then
			win:smooth_move_x(win:x(), x)
		else
			win:move(x, y)
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
			anchor_x = anchor_x - anchor_height
			if vim.opt.winbar ~= "" then
				anchor_x = anchor_x + 1
			end
		end
		win:set_height(c_win_height + anchor_height)

		if not utils.direction_have(utils.direction.up) then
			anchor_x = anchor_x + 1
		end
		--win:smooth_move_x(win:x(), c_win_pos[1] + anchor_x)
		--win:smooth_move_y(win:y(), c_win_pos[2] + anchor_y + c_win_width)
		local x = c_win_pos[1] + anchor_x
		local y = c_win_pos[2] + anchor_y + c_win_width
		if not win:is_show() then
			win:move(x, y)
			win:show()
		elseif win:y() == y then
			win:smooth_move_x(win:x(), x)
		else
			win:move(x, y)
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

		local x = c_win_pos[1] + anchor_x
		local y = c_win_pos[2] + anchor_y
		if not win:is_show() then
			win:move(x, y)
			win:show()
		elseif x == win:x() then
			win:smooth_move_y(win:y(), y)
		else
			win:move(x, y)
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

		local x = c_win_pos[1] + c_win_height + anchor_x
		local y = c_win_pos[2] + anchor_y
		if not win:is_show() then
			win:move(x, y)
			win:show()
		elseif x == win:x() then
			win:smooth_move_y(win:y(), y)
		else
			win:move(x, y)
		end
	else
		self.wins[direction.bottom]:hide()
	end
end

return M
