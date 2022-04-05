-- Telescope config ----------------------------------------------------------------- {{{1

local telescope = require "telescope"
local wk = require "which-key"

telescope.setup {
	defaults = {
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
		file_ignore_patterns = { ".git[\\/]" },
	},
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
		"LSP: References",
	},
	["gs"] = {
		function()
			tb.lsp_document_symbols()
		end,
		"LSP: Symbols",
	},
	["gh"] = {
		function()
			vim.lsp.buf.hover()
		end,
		"LSP: Hover",
	},
	["<leader>c"] = {
		function()
			tb.lsp_code_actions()
		end,
		"LSP: Code Actions",
	},
	["<c-.>"] = {
		function()
			tb.lsp_code_actions()
		end,
		"LSP: Code Actions",
	},
	["z="] = {
		function()
			tb.spell_suggest()
		end,
		"Spelling suggestions",
	},
	["<c-p>"] = {
		function()
			tb.find_files { hidden = true }
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
			tb.live_grep()
		end,
		"Live Grep",
	},
	["<m-p>"] = {
		function()
			tb.builtin()
		end,
		"Telescope",
	},
	["<leader>b"] = {
		name = "Buffer",
		b = {
			function()
				tb.buffers()
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
				tb.find_files { cwd = vim.fn.stdpath "config", hidden = true }
			end,
			"config files",
		},
		f = {
			function()
				tb.find_files { hidden = true }
			end,
			"files",
		},
		r = {
			function()
				tb.oldfiles()
			end,
			"recent files",
		},
		h = {
			function()
				tb.help_tags()
			end,
			"help",
		},
	},
	["<leader>p"] = {
		name = "Plugins",
		p = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerSync]]
			end,
			"Update",
		},
		s = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerStatus]]
			end,
			"Status",
		},
		i = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerCompile]]
				vim.cmd [[PackerInstall]]
			end,
			"Install",
		},
		c = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerCompile]]
				vim.cmd [[PackerClean]]
			end,
			"Clean",
		},
	},
}

-- NOTE: Remember to config the terminal to interpret the keybindings correctly.
-- Example for Alacritty:
-- key_bindings:
--   - {key: F5, mods: Control|Shift, chars: "\x1b[15;6;5~"}
--   - {key: F5, mods: Control, chars: "\x1b[>15;5~"}
--   - {key: F5, mods: Shift, chars: "\x1b[15;4~"}
--   - {key: F5, mods: Alt, chars: "\x1b[15;6~"}
--   - {key: B, mods: Control|Shift, chars: "\x1b[66;5u"}
--   - {key: Plus, mods: Control|Shift, chars: "\x1b[43;5u"}
--   - {key: Equals, mods: Control, chars: "\x1b[61;5u"}
--   - {key: Period, mods: Control, chars: "\x1b[46;5u"}
