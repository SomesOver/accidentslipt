local M = {}
local config = require("accidentslipt.config")
local view = require("accidentslipt.view")

function M.setup(opts)
	config:merge_options(opts)
	view:init()
end

return M
