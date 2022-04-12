-- Telescope config ----------------------------------------------------------------- {{{1

local telescope = require "telescope"

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
		project = {
			base_dirs = { { "~/Projects", max_depth = 2 } },
			hidden_files = false,
		},
	},
}

telescope.load_extension "fzf"
telescope.load_extension "project"
