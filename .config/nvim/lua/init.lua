local vim = vim

local M = {}

-- nvim-compe config ------------------------------------------------------------------ {{{1

local compe = require("compe")

-- Setup compe auto completions
compe.setup {
	enable = true,
	autocomplete = true,
	debug = false,
	min_length = 2,
	preselect = "disable",
	documentation = true,
	source = {
		calc = false,
		buffer = true,
		nvim_lsp = true,
		nvim_lua = true,
		omni = false,
		-- tabnine = true,
		tags = false,
		spell = true,
		path = true,
		vsnip = false,
	},
}

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

-- NOTE: This is broken now?
-- Fixes missing .cmd extensions for language servers
-- vim.loop.spawn = (function ()
--   local spawn = vim.loop.spawn
--   return function(path, options, on_exit)
--     local full_path = vim.fn.exepath(path)
--     return spawn(full_path, options, on_exit)
--   end
-- end)()

-- Run this every time a language server attaches to a buffer
local on_attach = function(client, bufnr)
	-- require("completion").on_attach(client, bufnr)
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
	clangd = {},
	gopls = {},
	pyls = {},
	pyright = {},
	vimls = {},
	dockerls = {},
	jsonls = {},
	yamlls = {},
	-- html = {},
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

-- Ripped from tjdevries/nlua
-- Maybe I should just use that plugin?
local get_lua_runtime = function()
	local res = {}

	res[vim.fn.expand("$VIMRUNTIME/lua")] = true
	res[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

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
	on_attach = on_attach,
	capabilities = lsp_status.capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
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
}

-- Treesitter config ---------------------------------------------------------------- {{{1
local ts = require("nvim-treesitter.configs")

ts.setup {
	ensure_installed = {
		"c", "cpp", "go", "rust",
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
				smart_rename = "<leader>r",
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
	context_commentstring = {
		enable = true,
	},
}

-- Setup gitsigns ------------------------------------------------------------------- {{{1

local gitsigns = require("gitsigns")

gitsigns.setup {
	signs = {
		add          = { hl = "GitSignsAdd"   , text = "│", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn" },
		change       = { hl = "GitSignsChange", text = "│", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
		delete       = { hl = "GitSignsDelete", text = "_", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
		topdelete    = { hl = "GitSignsDelete", text = "‾", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
	},
}

-- Setup neoscroll ------------------------------------------------------------------ {{{1

local neoscroll = require("neoscroll")
local neoscroll_config = require("neoscroll.config")

neoscroll.setup {
    mappings = {
		'<C-u>', '<C-d>',
		'<C-b>', '<C-f>',
		'zt', 'zz', 'zb',
		'J', 'K',
	},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
}

-- Setup custom mappings
neoscroll_config.key_to_function["J"] = { "scroll", {  "0.20", "false", "10" } }
neoscroll_config.key_to_function["K"] = { "scroll", { "-0.20", "false", "10" } }
neoscroll_config.set_mappings()

-- Setup colorizer ---------------------------------------------------------------- {{{1

-- local colorizer = require("colorizer")

-- colorizer.setup {
-- 	"css",
-- 	"html",
-- }

-- Setup nvim-autopairs ----------------------------------------------------------- {{{1

local autopairs = require("nvim-autopairs")

autopairs.setup {
	disable_filetype = { "TelescopePrompt" },
}

-- Return module ------------------------------------------------------------------ {{{1

return M

-- vi: foldmethod=marker
