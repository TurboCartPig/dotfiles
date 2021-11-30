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
	["<c-[>"] = {
		function()
			vim.lsp.buf.declaration()
		end,
		"LSP: Goto declaration",
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
	["gh"] = {
		function()
			vim.lsp.buf.hover()
		end,
		"LSP: Hover",
	},
	["<leader>c"] = {
		function()
			tb.lsp_code_actions(theme)
		end,
		"LSP Code Actions",
	},
	["z="] = {
		function()
			tb.spell_suggest(theme)
		end,
		"Spelling suggestions",
	},
	["<c-p>"] = {
		function()
			tb.find_files(vim.tbl_extend("error", { hidden = true }, theme))
		end,
		"Find files",
	},
	["<leader>r"] = {
		function()
			vim.lsp.buf.rename()
		end,
		"LSP: Rename symbol",
	},
	["<leader>g"] = {
		function()
			tb.live_grep(theme)
		end,
		"Live Grep",
	},
	["<m-p>"] = {
		function()
			tb.builtin(theme)
		end,
		"Telescope",
	},
	["<leader>b"] = {
		name = "Buffer",
		b = {
			function()
				tb.buffers(theme)
			end,
			"Buffers",
		},
		n = {
			"<cmd>bnext<cr>",
			"Next buffer",
		},
		p = {
			"<cmd>bprevious<cr>",
			"Previous buffer",
		},
	},
	["<leader>f"] = {
		name = "Find",
		p = {
			function()
				tb.find_files(vim.tbl_extend("keep", { cwd = vim.fn.stdpath "config", hidden = true }, theme))
			end,
			"Config files",
		},
	},
}
