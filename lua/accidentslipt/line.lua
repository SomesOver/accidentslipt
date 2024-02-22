local M = {}
local api = vim.api
local utils = require("accidentslipt.utils")

function M:create_line()
	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(buf, "buftype", "nofile")
	api.nvim_buf_set_option(buf, "filetype", "NvimSeparator")
	local line = {
		start_symbol = "",
		body_symbol = "",
		end_symbol = "",
		loop = nil,
		buffer = buf,
		window = nil,
		opts = {
			style = "minimal",
			relative = "editor",
			zindex = 10,
			focusable = false,
			height = 1,
			width = 1,
			row = 0,
			col = 0,
		},
		_show = false,
	}

	function line:is_show()
		return self._show
	end

	function line:set_parrent(parrent)
		self.parrent = parrent
	end

	function line:height()
		return self.opts.height
	end

	function line:width()
		return self.opts.width
	end

	function line:smooth_height(start_height, end_height)
		local timer = vim.loop.new_timer()
		local _line = self
		local cu = math.abs(start_height - end_height)
		timer:start(
			0,
			30,
			vim.schedule_wrap(function()
				if start_height > end_height then
					start_height = start_height - 1
				elseif start_height < end_height then
					start_height = start_height + 1
				end

				cu = cu - 1
				_line:set_height(start_height)
				if cu < 0 then
					timer:stop()
					--timer:close()
				end
			end)
		)
	end

	function line:smooth_width(start_width, end_width)
		local timer = vim.loop.new_timer()
		local _line = self
		local cu = math.abs(start_width - end_width)
		timer:start(
			0,
			10,
			vim.schedule_wrap(function()
				if start_width > end_width then
					start_width = start_width - 1
				elseif start_width < end_width then
					start_width = start_width + 1
				end
				cu = cu - 1
				_line:set_width(start_width)
				if cu < 0 then
					timer:stop()
					--timer:close()
				end
			end)
		)
	end

	function line:smooth_move_x(start_x, end_x)
		local timer = vim.loop.new_timer()
		local _line = self
		local cu = math.abs(start_x - end_x)
		timer:start(
			0,
			10,
			vim.schedule_wrap(function()
				if start_x > end_x then
					start_x = start_x - 1
				elseif start_x < end_x then
					start_x = start_x + 1
				end
				cu = cu - 1
				_line:move(start_x, _line:y())
				if cu < 0 then
					timer:stop()
					--timer:close()
				end
			end)
		)
	end

	function line:smooth_move_y(start_y, end_y)
		local timer = vim.loop.new_timer()
		local _line = self
		local cu = math.abs(start_y - end_y)
		timer:start(
			0,
			3,
			vim.schedule_wrap(function()
				if start_y > end_y then
					start_y = start_y - 1
				elseif start_y < end_y then
					start_y = start_y + 1
				end
				_line:move(_line:x(), start_y)
				cu = cu - 1
				if cu < 0 then
					timer:stop()
					--timer:close()
				end
			end)
		)
	end

	function line:hide()
		if self.window ~= nil then
			vim.api.nvim_win_close(self.window, false)
			self.window = nil
			self._show = false
		end
	end

	function line:show()
		win = api.nvim_open_win(self.buffer, false, self.opts)
		api.nvim_win_set_option(win, "winhl", "Normal:NvimSeparator")
		self.window = win
		self._show = true
	end

	function line:x()
		return self.opts.row
	end

	function line:y()
		return self.opts.col
	end

	function line:move(x, y)
		self:movecorrection()
		self.opts.row = x
		self.opts.col = y
		self:load_opts(self.opts)
	end

	function line:load_opts(opts)
		if self.window ~= nil and api.nvim_win_is_valid(self.window) then
			api.nvim_win_set_config(self.window, opts)
		end
	end

	function line:movecorrection() end
	function line:hcorrection(height) end
	function line:vcorrection(width) end

	function line:set_width(width)
		self:vcorrection(width)
		self.opts.width = width
		self:load_opts(self.opts)
	end

	function line:set_height(height)
		if utils.direction_have(utils.direction.up) then
			height = height + 1
		end

		if utils.direction_have(utils.direction.bottom) then
			height = height + 1
		end
		self:hcorrection(height)
		self.opts.height = height
		self:load_opts(self.opts)
	end
	return line
end

-- create vertical line
function M:create_vertical_line(width, start_symbol, body_symbol, end_symbol)
	local line = M:create_line()
	line.start_symbol = start_symbol
	line.body_symbol = body_symbol
	line.end_symbol = end_symbol

	line:set_width(width)
	line:set_height(1)
	function line:vcorrection(width)
		local line = utils.build_vertical_line_symbol(width, self.start_symbol, self.body_symbol, self.end_symbol)
		vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, line)
	end
	return line
end

-- create horizontal line
function M:create_horizontal_line(height, start_symbol, body_symbol, end_symbol)
	local line = M:create_line()
	line.start_symbol = start_symbol
	line.body_symbol = body_symbol
	line.end_symbol = end_symbol

	line:set_width(1)
	line:set_height(height)
	function line:hcorrection(height)
		local line = utils.build_horizontal_line_symbol(height, self.start_symbol, self.body_symbol, self.end_symbol)
		vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, line)
	end
	return line
end

return M
