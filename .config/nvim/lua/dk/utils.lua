local M = {}

-- Inspect an element py printing it.
_G.inspect = function(element)
	print(vim.inspect(element))
end

-- Reload entire config.
function M.reload()
	local r = require "plenary.reload"

	-- Reload modules under 'dk' namespace
	r.reload_module("dk", true)

	-- Re-run init.lua
	dofile(vim.fn.stdpath "config" .. "/init.lua")

	print "Config reloaded!"
end

return M
