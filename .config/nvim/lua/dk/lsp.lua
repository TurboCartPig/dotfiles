-- Most setup of lsp clients
-- Some clients are configured in ftplugin/<lang>.lua

local lsp_config = require "lspconfig"

-- Override diagnostic signs
-- FIXME: This can propbably be moved into init.lua
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	local opts = { text = icon, texthl = hl, numhl = hl }
	vim.fn.sign_define(hl, opts)
end

-- Setup look of diagnostics
vim.diagnostic.config {
	underline = true,
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
}

-- Advertise client capabilities to servers
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Override options for lsp handlers
local handler_opts = {
	focusable = false,
	border = "rounded",
}

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = true, border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, handler_opts),
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
	elmls = {},
	tsserver = {
		settings = {
			completions = {
				completeFunctionCalls = true,
			},
		},
	},
	dockerls = {},
	html = {},
	cssls = {},
	eslint = {},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {},
}

local M = {}

local sucky_servers = { "jsonls", "tsserver", "html", "pyright", "gopls" }

-- Format the buffer using either LSP or Neoformat
function M.format()
	-- local fmt_servers = vim.tbl_filter(function(client)
	-- 	return client.supports_method "textDocument/formatting"
	-- end, vim.lsp.get_active_clients())
	-- if vim.tbl_isempty(fmt_servers) then
	-- 	vim.cmd [[Neoformat]]
	-- 	return
	-- end

	vim.lsp.buf.formatting_seq_sync({}, 1000, {})
end

-- Rename symbol under cursor, either with LSP or Treesitter
function M.rename()
	for _, client in pairs(vim.lsp.get_active_clients()) do
		if client.supports_method "textDocument/rename" and not vim.tbl_contains(sucky_servers, client.name) then
			vim.lsp.buf.rename()
			return
		end
	end

	-- TODO: Check if treesitter supports rename
	require("nvim-treesitter-refactor.smart_rename").smart_rename(0)
end

-- Run this every time a language server attaches to a buffer
function M.on_attach(client, bufnr)
	-- Auto-clearing autocmd group. Unique for this client and buffer
	local augroup = vim.api.nvim_create_augroup("LspAttach" .. bufnr, { clear = true })

	-- Setup completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Setup lightbulb on code_action
	vim.fn.sign_define("LightBulbSign", { text = "", texthl = "DiagnosticsSignInfo" })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		callback = function()
			require("nvim-lightbulb").update_lightbulb()
		end,
		group = augroup,
	})

	-- Setup line diagnostic on hover
	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float(nil, vim.tbl_extend("error", handler_opts, { scope = "cursor" }))
		end,
		group = augroup,
	})

	-- Disable formatting with sucky servers
	if vim.tbl_contains(sucky_servers, client.name) then
		client.server_capabilities.document_formatting = false -- For <=0.7
		client.server_capabilities.documentFormattingProvider = false -- For >=0.8
	end

	-- TODO : Rewrite with client.supports_method() api
	-- Setup lsp-hover on hold
	-- if client.resolved_capabilities.hover then
	-- 	vim.cmd "autocmd CursorHold <buffer> lua vim.lsp.buf.hover()"
	-- end

	-- Setup signature help on hold
	-- FIXME: STFU when there is no signature help available
	-- if client.resolved_capabilities.signature_help then
	-- 	vim.cmd "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()"
	-- end
end

-- Setup all the servers with their respective settings
for ls, settings in pairs(servers) do
	local s = vim.tbl_extend(
		"error",
		settings,
		{ on_attach = M.on_attach, capabilities = capabilities, handlers = handlers }
	)
	lsp_config[ls].setup(s)
end

return M
