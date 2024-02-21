local M = {}
local view = require("accidentslipt.view")
local config = require("accidentslipt.config")

function M:setup(opts)
	config:merge_options(opts)
	view:init()
end

return M
