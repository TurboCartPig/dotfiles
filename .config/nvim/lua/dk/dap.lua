local dap = require "dap"
local dap_vt = require "nvim-dap-virtual-text"

dap_vt.setup {
	enabled_commands = false,
}

-- Go delve config ------------------------------------------------------------------ {{{1

--[=[

dap.adapters.go = function(callback, config)
	local handle
	local pid_or_err
	local port = 38697

	handle, pid_or_err = vim.loop.spawn("dlv", {
		args = { "dap", "-l", "127.0.0.1:" .. port },
		detached = true,
	}, function(code)
		handle:close()
		print("Delve exited with exit code: " .. code)
	end)

	-- Wait 100ms for delve to start
	vim.defer_fn(function()
		--dap.repl.open()
		callback { type = "server", host = "127.0.0.1", port = port }
	end, 100)

	--callback({type = "server", host = "127.0.0.1", port = port})
end

 https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
 dap.configurations.go = {
 	{
 		type = "go",
 		name = "Debug",
 		request = "launch",
 		program = "${file}",
 	},
 }

--]=]

-- Node config ------------------------------------------------------------------ {{{1

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = { "C:/Projects/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
	{
		name = "Launch",
		type = "node2",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	{
		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		name = "Attach to process",
		type = "node2",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
}

-- LLDB config ------------------------------------------------------------------ {{{1

dap.adapters.lldb = {
	type = "executable",
	command = "C:/Users/dennk/scoop/apps/llvm/current/bin/lldb-vscode.exe",
	name = "lldb",
}
