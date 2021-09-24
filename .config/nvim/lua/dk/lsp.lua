-- Most setup of lsp clients
-- Some clients are configured in ftplugin/<lang>.lua

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
	vim.cmd "autocmd CursorHold <buffer> lua vim.diagnostic.show_position_diagnostics(vim.g.lsp_handler_opts)"

	-- Setup lsp-hover on hold
	-- if client.resolved_capabilities.hover then
	-- 	vim.cmd "autocmd CursorHold <buffer> lua vim.lsp.buf.hover()"
	-- end

	-- Setup signature help on hold
	-- FIXME: STFU when there is no signature help available
	-- if client.resolved_capabilities.signature_help then
	-- 	vim.cmd "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()"
	-- end

	-- Disable formatting for servers with sucky formatters
	if vim.tbl_contains({ "jsonls", "tsserver", "html", "pyright", "gopls" }, client.name) then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end

	-- Only setup format on save for servers that support it
	if client.resolved_capabilities.document_formatting then
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

-- Advertise client capabilities to servers
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Setup null-ls
local null = require "null-ls"
local fmt = null.builtins.formatting
local diag = null.builtins.diagnostics

null.config {
	sources = {
		-- Formatters
		fmt.stylua,
		fmt.black,
		fmt.prettier,
		-- fmt.stylelint,
		fmt.goimports,

		-- Diagnostics
		-- diag.selene,
		-- diag.eslint,
		-- diag.stylelint,
		diag.shellcheck,
		diag.markdownlint,
	},
}

-- List all the servers and any custom configuration
local servers = {
	hls = {
		settings = {
			languageServerHaskell = {
				formattingProvider = "stylish-haskell",
			},
		},
	},
	clangd = {
		cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
	},
	pyright = {},
	vimls = {},
	html = {},
	tsserver = {},
	dockerls = {},
	jsonls = {},
	yamlls = {},
	["null-ls"] = {},
}

local windows_overrides = {
	html = {
		cmd = { "vscode-html-language-server.cmd", "--stdio" },
	},
	tsserver = {
		cmd = { "typescript-language-server.cmd", "--stdio" },
	},
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
	local s = vim.tbl_extend("error", settings, { on_attach = M.on_attach, capabilities = capabilities })
	lsp_config[ls].setup(s)
end

return M
