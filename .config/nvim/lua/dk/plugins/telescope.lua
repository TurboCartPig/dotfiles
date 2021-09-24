-- Telescope config ----------------------------------------------------------------- {{{1

local telescope = require "telescope"
local wk = require "which-key"

telescope.setup {
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
}

telescope.load_extension "fzf"

-- Telescope keymappings
local tb = require "telescope.builtin"

wk.register {
	["gr"] = {
		function()
			tb.lsp_references()
		end,
		"LSP References",
	},
	["gs"] = {
		function()
			tb.lsp_document_symbols()
		end,
		"LSP Symbols",
	},
	["gll"] = {
		function()
			tb.lsp_document_diagnostics()
		end,
		"LSP Diagnostics",
	},
	["<m-cr>"] = {
		function()
			tb.lsp_code_actions()
		end,
		"LSP Code Actions",
	},
	["<c-cr>"] = {
		function()
			tb.spell_suggest()
		end,
		"Spelling suggestions",
	},
	["<c-b>"] = {
		function()
			tb.buffers()
		end,
		"Buffers",
	},
	["<c-p>"] = {
		function()
			tb.find_files()
		end,
		"Find files",
	},
	["<m-p>"] = {
		"<cmd>Telescope<cr>",
		"Telescope",
	},
}
