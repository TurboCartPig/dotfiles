-- Servers I don't want to use for something specific
local sucky_servers = { "jsonls", "html", "pyright", "gopls" }

-- Rename symbol under cursor, either with LSP or Treesitter
local function rename()
	for _, client in pairs(vim.lsp.get_clients()) do
		if client.supports_method "textDocument/rename" and not vim.tbl_contains(sucky_servers, client.name) then
			vim.lsp.buf.rename()
			return
		end
	end

	-- TODO: Check if treesitter supports rename
	require("nvim-treesitter-refactor.smart_rename").smart_rename()
end

-- Run this every time a language server attaches to a buffer
local function on_attach(_, bufnr)
	-- Auto-clearing autocmd group. Unique for this buffer
	local augroup = vim.api.nvim_create_augroup("LspAttach" .. bufnr, { clear = true })

	-- Setup completion
	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Setup lightbulb on code_action
	vim.fn.sign_define("LightBulbSign", { text = "", texthl = "DiagnosticsSignInfo" })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		callback = function()
			require("nvim-lightbulb").update_lightbulb()
		end,
		group = augroup,
	})
end

-- Setup lsp_signature -------------------------------------------------------------- {{{1

local function setup_lsp_signature()
	local lsp_signature = require "lsp_signature"

	lsp_signature.setup {
		floating_window = false,
		hint_enable = true,
		hint_prefix = "",
	}
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"onsails/lspkind-nvim",
		"kosayoda/nvim-lightbulb",
		"b0o/schemastore.nvim",
		"ray-x/lsp_signature.nvim",
	},
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	keys = {
		{ "<C-.>", vim.lsp.buf.code_action, desc = "LSP: Code Actions" },
		{ "<D-.>", vim.lsp.buf.code_action, desc = "LSP: Code Actions" },
		{ "R",     rename,                  desc = "LSP: Rename" },
		{ "gh",    vim.lsp.buf.hover,       desc = "LSP: Hover" },
	},
	config = function()
		local lsp_config = require "lspconfig"

		-- Override diagnostic signs
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
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Override options for lsp handlers
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = true, border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				{ focusable = false, border = "rounded" }
			),
		}

		-- All the servers I want to use and any custom configuration
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
			elmls = {},
			gleam = {},
			elixirls = {
				cmd = {
					vim.fs.joinpath(
						string.gsub(vim.fn.system { "brew", "--prefix", "elixir-ls" }, "%s+", ""),
						"libexec",
						"language_server.sh"
					)
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
			lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						codeLens = {
							enable = true,
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
					},
				},
			},
			rust_analyzer = {},
			gopls = {
				analyses = {
					staticcheck = true,
					vulncheck = true,
				},
				hoverKind = "Structured",
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = false,
					constantValues = true,
					parameterNames = true,
					rangeVariableTypes = true,
				}
			},
		}

		-- Setup all the servers with their respective settings
		for ls, settings in pairs(servers) do
			local s = vim.tbl_extend(
				"error",
				settings,
				{ on_attach = on_attach, capabilities = capabilities, handlers = handlers }
			)
			lsp_config[ls].setup(s)
		end

		setup_lsp_signature()
	end,
}
