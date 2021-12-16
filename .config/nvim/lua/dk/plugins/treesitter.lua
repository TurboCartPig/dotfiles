-- Treesitter config ---------------------------------------------------------------- {{{1

local parsers = require("nvim-treesitter.parsers").get_parser_configs()
local ts = require "nvim-treesitter.configs"

-- Add install source for org parser
parsers.org = {
	filetype = "org",
	install_info = {
		url = "https://github.com/milisims/tree-sitter-org",
		revision = "main",
		files = { "src/parser.c", "src/scanner.cc" },
	},
}

-- Setup treesitters and treesitters plugins' settings
ts.setup {
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
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "json" },
	},
	indent = {
		enable = true,
		disable = { "yaml" },
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
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
			enable = false,
		},
		highlight_current_scope = {
			enable = false,
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "R",
			},
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
	playground = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
}
