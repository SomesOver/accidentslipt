-- @author      : denstiny (2254228017@qq.com)
-- @file        : init
-- @created     : 星期三 2月 21, 2024 12:00:59 CST
-- @github      : https://github.com/denstiny
-- @blog        : https://denstiny.github.io

local M = {}
local api = vim.api
local view = require("colorful-winsep.view")
local config = require("colorful-winsep.config")

function M:setup()
	view:init()
	api.nvim_create_autocmd(config.events, {
		group = M.auto_group,
		callback = function(opts)
			view:dividing_split_line()
		end,
	})
	vim.cmd([[
        hi NvimSeparator guibg=None guifg=yellow
    ]])
end

return M
