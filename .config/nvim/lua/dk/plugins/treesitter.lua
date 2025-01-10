return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
			"romgrk/nvim-treesitter-context",
			"https://github.com/HiPhish/rainbow-delimiters.nvim",
		},
		lazy = false,
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"clojure",
				"cmake",
				"comment",
				"commonlisp",
				"cpp",
				"css",
				"cuda",
				"dockerfile",
				"dot",
				"elm",
				"fennel",
				"fish",
				"glsl",
				"go",
				"gomod",
				"graphql",
				"hjson",
				"html",
				"http",
				"java",
				"javascript",
				"jsdoc",
				"json",
				"json5",
				"jsonc",
				"kotlin",
				"latex",
				"llvm",
				"lua",
				"nix",
				"markdown",
				"ocaml",
				"perl",
				"php",
				"python",
				"regex",
				"rst",
				"ruby",
				"rust",
				"scala",
				"scss",
				"svelte",
				"tlaplus",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml",
				"zig",
				"org",
				"teal",
				"query",
			},
			auto_install = false,
			highlight = {
				enable = true,
				disable = { "org" },
				additional_vim_regex_highlighting = true,
			},
			indent = {
				enable = true,
				disable = { "yaml" },
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "grn",
					node_incremental = "grn",
					node_decremental = "grm",
				},
			},
			textobjects = {
				swap = {
					enable = true,
					swap_next = {
						["<leader><C-l>"] = "@parameter.inner",
						["<leader><C-j>"] = "@function.outer",
					},
					swap_previous = {
						["<leader><C-h>"] = "@parameter.inner",
						["<leader><C-k>"] = "@function.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},
			refactor = {
				highlight_definitions = {
					enable = true,
				},
				highlight_current_scope = {
					enable = false,
				},
				navigation = {
					enable = true,
					keymaps = {
						goto_definition_lsp_fallback = "gd",
						goto_next_usage = "%%",
						goto_previous_usage = "&&",
						list_definitions_toc = "g0",
					},
				},
			},
		},
		config = function(_, opts)
			local ts = require "nvim-treesitter.configs"
			local context = require "treesitter-context"
			local rainbow = require "rainbow-delimiters.setup"
			local autotag = require "nvim-ts-autotag"

			-- Enable ts context
			context.setup {
				enable = true,
				max_lines = 2,
			}

			rainbow.setup()

			autotag.setup()

			ts.setup(opts)
		end,
	},
}
