return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" },
		},
		lazy = true,
		keys = {
			{ "gr",         function() require("telescope.builtin").lsp_references() end,                                              desc = "LSP: References" },
			{ "gs",         function() require("telescope.builtin").lsp_document_symbols() end,                                        desc = "LSP: Symbols" },
			{ "z=",         function() require("telescope.builtin").spell_suggest() end,                                               desc = "Spelling suggestions" },
			{ "<c-p>",      function() require("telescope.builtin").find_files({ hidden = true }) end,                                 desc = "Find files" },
			{ "<m-p>",      function() require("telescope.builtin").builtin() end,                                                     desc = "Telescope" },
			{ "<d-p>",      function() require("telescope.builtin").builtin() end,                                                     desc = "Telescope" },
			{ "<leader>bb", function() require("telescope.builtin").buffers() end,                                                     desc = "Buffers" },
			{ "<leader>bn", "<cmd>bnext<cr>",                                                                                          desc = "Next buffer" },
			{ "<leader>bp", "<cmd>bprevious<cr>",                                                                                      desc = "Previous buffer" },
			{ "<leader>ff", function() require("telescope.builtin").find_files() end,                                                  desc = "Find files" },
			{ "<leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), hidden = true }) end, desc = "Find config files" },
			{ "<leader>fl", function() require("telescope.builtin").live_grep() end,                                                   desc = "Find lines / grep" },
			{ "<leader>fr", function() require("telescope.builtin").oldfiles() end,                                                    desc = "Find recent files" },
			{ "<leader>fh", function() require("telescope.builtin").help_tags() end,                                                   desc = "Find help" },
			{ "<leader>fp", function() require("telescope").extensions.project.project() end,                                          desc = "Find projects" },
		},
		opts = {
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
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("project")
		end
	},
}
