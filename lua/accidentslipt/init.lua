local M = {}
local config = require("accidentslipt.config")
local view = require("accidentslipt.view")

function M.setup(opts)
	view:init(opts)
end

return M
