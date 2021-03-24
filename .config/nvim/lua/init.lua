local vim = vim

local M = {}

-- Neovim lsp status line config ------------------------------------------------------ {{{1

local lsp_status = require("lsp-status")

-- use LSP SymbolKinds themselves as the kind labels
local kind_labels_mt = { __index = function(_, k) return k end }
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

-- setup lsp_status line
lsp_status.register_progress()
lsp_status.config {
	kind_labels = kind_labels,
	indicator_errors = "×",
	indicator_warnings = "!",
	indicator_info = "i",
	indicator_hint = "›",
	-- the default is a wide codepoint which breaks absolute and relative
	-- line counts if placed before airline's Z section
	status_symbol = "",
}

-- Neovim lsp config ----------------------------------------------------------------- {{{1

local lsp_config = require("lspconfig")
local lsp_configs = require("lspconfig/configs")

-- Run this every time a language server attaches to a buffer
local on_attach = function(client, bufnr)
	require("completion").on_attach(client, bufnr)
	lsp_status.on_attach(client, bufnr)

	-- Only setup format on save for servers that support it
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)")
	end

	-- Setup completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Setup lightbulb on code_action
	vim.cmd("autocmd CursorHold,CursorHoldI <buffer> lua require('nvim-lightbulb').update_lightbulb()")

	-- Setup line diagnostic on hover
	-- vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()")

	-- Setup hover? on hover
	-- vim.api.nvim_command("autocmd CursorHold <buffer> lua vim.lsp.buf.hover()")

	-- Setup signature help on hover
	vim.cmd("autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()")
end

-- List all the servers and any custom configuration
local servers = {
	rust_analyzer = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
	hls = {
		languageServerHaskell = {
			formattingProvider = "stylish-haskell",
		},
	},
	pyls = {},
	clangd = {},
	vimls = {},
	gopls = {},
}

-- Setup all the servers with their respective settings
for ls, settings in pairs(servers) do
	lsp_config[ls].setup {
		on_attach = on_attach,
		settings = settings,
		capabilities = vim.tbl_extend("keep", lsp_configs[ls].capabilities or {}, lsp_status.capabilities),
	}
end

-- Find lua language server based on platform
local sumneko_root
local sumneko_bin
if vim.fn.has("win32") == 1 then
	sumneko_root = "C:/Projects/lua-language-server"
	sumneko_bin  = sumneko_root .. "/bin/Windows/lua-language-server.exe"
elseif vim.fn.has("unix") == 1 then
	sumneko_root = vim.fn.expand("$HOME/Projects/lua-language-server")
	sumneko_bin  = sumneko_root .. "/bin/Linux/lua-language-server"
else
	print("Please provide instructions for finding lua-language-server in init.lua")
end

-- Setup lua language server
lsp_config.sumneko_lua.setup {
	cmd = { sumneko_bin, "-E", sumneko_root .. "/main.lua" },
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
		},
		diagnostics = { globals = { "vim" }, },
		workspace = {
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
			},
		},
	},
}

-- Treesitter config ---------------------------------------------------------------- {{{1
local ts = require("nvim-treesitter.configs")

ts.setup {
	ensure_installed = {
		"c", "cpp", "go", "rust", "haskell",
		"javascript", "typescript", "html", "css",
		"python", "lua",
		"bash", "comment",
		"yaml", "toml", "json",
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	refactor = {
		highlight_definitions = {
			enable = true,
		},
		highlight_current_scope = {
			enable = false,
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "<leader+R>",
			},
		},
		navigation = {
			enable = true,
			keymaps = {
				goto_definition = nil,
				goto_definition_lsp_fallback = "gd",
				goto_next_usage = "%%",
				goto_previous_usage = "&&",
				list_definitions = nil,
				list_definitions_toc = "g0",
			},
		},
	},
}

-- Return module -------------------------------------------------------------------- {{{1

return M

-- vi: foldmethod=marker
