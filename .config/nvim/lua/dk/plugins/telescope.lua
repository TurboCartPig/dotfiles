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

local theme = {
	theme = "ivy-dropdown",
	results_title = false,
	preview_title = "",
	sorting_strategy = "ascending",
	layout_strategy = "bottom_pane",
	layout_config = {
		preview_cutoff = 1,
		height = function(_, _, max_lines)
			return math.min(max_lines, 25)
		end,
	},
	border = true,
	borderchars = {
		prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
		results = { " ", "│", " ", " ", " ", " ", " ", " " },
		preview = { " " },
	},
}

-- Telescope keymappings
local tb = require "telescope.builtin"

wk.register {
	["gr"] = {
		function()
			tb.lsp_references(theme)
		end,
		"LSP References",
	},
	["gs"] = {
		function()
			tb.lsp_document_symbols(theme)
		end,
		"LSP Symbols",
	},
	["gll"] = {
		function()
			tb.lsp_document_diagnostics(theme)
		end,
		"LSP Diagnostics",
	},
	["<m-cr>"] = {
		function()
			tb.lsp_code_actions(theme)
		end,
		"LSP Code Actions",
	},
	["<c-cr>"] = {
		function()
			tb.spell_suggest(theme)
		end,
		"Spelling suggestions",
	},
	["<c-b>"] = {
		function()
			tb.buffers(theme)
		end,
		"Buffers",
	},
	["<c-p>"] = {
		function()
			tb.find_files(theme)
		end,
		"Find files",
	},
	["<leader>g"] = {
		function()
			tb.live_grep(theme)
		end,
	},
	["<m-p>"] = {
		function()
			tb.builtin(theme)
		end,
		"Telescope",
	},
}
