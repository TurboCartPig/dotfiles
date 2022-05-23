-- Treesitter config ---------------------------------------------------------------- {{{1

local parsers = require "nvim-treesitter.parsers"
local ts = require "nvim-treesitter.configs"
local orgmode = require "orgmode"
local context = require "treesitter-context"

-- Inverse a list of enabled parsers into a list of disabled parsers.
local function inverse_enabled(enabled_list)
	return vim.tbl_filter(function(p)
		return not vim.tbl_contains(enabled_list, p)
	end, parsers.available_parsers())
end

-- Add install source for org parser
orgmode.setup_ts_grammar()

-- Enable ts context
context.setup {
	enable = true,
	max_lines = 2,
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
	highlight = {
		enable = true,
		disable = { "org" },
		-- additional_vim_regex_highlighting = { "json", "org" },
		additional_vim_regex_highlighting = true,
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
			enable = true,
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
	rainbow = {
		enable = true,
		disable = inverse_enabled { "commonlisp", "clojure", "fennel" },
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
