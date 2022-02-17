-- Settings for lua

local lsp_config = require "lspconfig"
local lsp_settings = require "dk.lsp"

-- Find lua language server based on platform
local sumneko_root
local sumneko_bin
if vim.fn.has "win32" == 1 then
	sumneko_root = "C:/Projects/lua-language-server"
	sumneko_bin = sumneko_root .. "/bin/lua-language-server.exe"
elseif vim.fn.has "unix" == 1 then
	sumneko_root = vim.fn.expand "$HOME/Projects/lua-language-server"
	sumneko_bin = sumneko_root .. "/bin/lua-language-server"
end

-- Ripped from tjdevries/nlua
-- Maybe I should just use that plugin?
local get_lua_runtime = function()
	local res = {}

	res[vim.fn.expand "$VIMRUNTIME/lua"] = true
	res[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true

	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. "/lua/"
		if vim.fn.isdirectory(lua_path) then
			res[lua_path] = true
		end
	end

	return res
end

-- Setup lua language server
lsp_config.sumneko_lua.setup {
	cmd = { sumneko_bin, "-E", sumneko_root .. "/main.lua" },
	on_attach = lsp_settings.on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			completion = {
				keywordSnippet = "Disable",
			},
			diagnostics = {
				enable = true,
				globals = { "vim" },
			},
			workspace = {
				library = get_lua_runtime(),
				maxPreload = 1000,
				preloadFileSize = 1000,
			},
		},
	},
}
