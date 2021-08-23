-- Most setup of lsp clients
-- Some clients are configured in ftplugin/<lang>.lua

local map = vim.api.nvim_set_keymap
local lsp_config = require "lspconfig"

M = {}

-- Run this every time a language server attaches to a buffer
function M.on_attach(client, bufnr)
	-- Override options for lsp handlers
	vim.g.lsp_handler_opts = {
		focusable = false,
		border = "rounded",
	}

	-- Setup completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Setup lightbulb on code_action
	vim.fn.sign_define("LightBulbSign", { text = "", texthl = "LspDiagnosticsDefaultInformation" })
	vim.cmd "autocmd CursorHold,CursorHoldI <buffer> lua require('nvim-lightbulb').update_lightbulb()"

	-- Setup line diagnostic on hover
	vim.cmd "autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics(vim.g.lsp_handler_opts)"

	-- Setup lsp-hover on hold
	if client.resolved_capabilities.hover then
		vim.cmd "autocmd CursorHold <buffer> lua vim.lsp.buf.hover()"
	end

	-- Setup signature help on hold
	-- FIXME: STFU when there is no signature help available
	if client.resolved_capabilities.signature_help then
		vim.cmd "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()"
	end

	-- Only setup format on save for servers that support it
	if client.resolved_capabilities.document_formatting then
		-- Override format keymap
		map("n", "<c-m-L>", [[lua vim.lsp.buf.formatting()]], { noremap = true, silent = true })

		-- Autoformat on save
		vim.cmd [[
			augroup AutoFormat
				autocmd!
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
			augroup END
		]]
	end

	-- Add handler for publishDiagnostics
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = true,
		signs = true,
		update_in_insert = true,
		severity_sort = true,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, vim.g.lsp_handler_opts)

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		vim.g.lsp_handler_opts
	)
end

-- List all the servers and any custom configuration
local servers = {
	hls = {
		settings = {
			languageServerHaskell = {
				formattingProvider = "stylish-haskell",
			},
		},
	},
	clangd = {},
	-- pylsp = {},
	pyright = {},
	vimls = {},
}

local windows_overrides = {
	dockerls = {
		cmd = { "docker-langserver.cmd", "--stdio" },
	},
	jsonls = {
		cmd = { "vscode-json-language-server.cmd", "--stdio" },
	},
	yamlls = {
		cmd = { "yaml-language-server.cmd", "--stdio" },
	},
}

if vim.fn.has "win32" == 1 then
	servers = vim.tbl_extend("force", servers, windows_overrides)
end

-- Setup all the servers with their respective settings
for ls, settings in pairs(servers) do
	local s = vim.tbl_extend("error", settings, { on_attach = M.on_attach })
	lsp_config[ls].setup(s)
end

return M
