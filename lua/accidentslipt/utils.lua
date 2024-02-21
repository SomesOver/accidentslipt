local fn = vim.fn
local M = {
	direction = { left = "h", right = "l", up = "k", bottom = "j" },
}

--- Determine if there are neighbors in the direction
---@param direction string
---@return boolean
function M.direction_have(direction)
	local winnum = vim.fn.winnr()
	if vim.fn.winnr(direction) ~= winnum and fn.win_gettype(winnum) ~= "popup" then
		return true
	end
	return false
end

function M.build_vertical_line_symbol(width, start, body, end_)
	local text = { "" }
	for i = 2, width - 1 do
		text[1] = text[1] .. body
	end
	text[1] = start .. text[1] .. end_
	return text
end

function M.build_horizontal_line_symbol(height, start, body, end_)
	text = { "" }
	for i = 2, height - 1 do
		text[i] = body
	end
	text[1] = start
	text[height] = end_
	if not M.direction_have(M.direction.up) then
		text[1] = body
	end
	if not M.direction_have(M.direction.bottom) then
		text[height] = body
	end
	return text
end

function M.calculate_number_windows()
	local win_len = fn.winnr("$")
	for i = 1, win_len do
		if fn.win_gettype(i) == "popup" then
			win_len = win_len - 1
		end
	end
	return win_len
end

return M
