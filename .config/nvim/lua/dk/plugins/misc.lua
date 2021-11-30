-- Imports
local map = vim.api.nvim_set_keymap

-- Setup trouble -------------------------------------------------------------------- {{{1

local trouble = require "trouble"

trouble.setup {}

-- Setup todo-comments -------------------------------------------------------------- {{{1

local todo = require "todo-comments"

todo.setup {
	signs = false,
	highlight = {
		comments_only = true,
	},
}

-- Setup which-key ------------------------------------------------------------------ {{{1

local wk = require "which-key"

wk.setup {
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜ ", -- symbol used between a key and it's label
		group = "@", -- symbol prepended to a group
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
	},
	layout = {
		height = { min = 4, max = 30 }, -- min and max height of the columns
		width = { min = 25, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
}

-- Neovim set custom keybinds ------------------------------------------------------- {{{1

wk.register {
	["<leader><leader>"] = { "<cmd>buffer#<cr>", "Switch buffers" },
	["<s-esc>"] = { "<cmd>close<cr>", "Close window" },
	["<c-d>"] = { "*<c-o>cgn", "Change multiple of the same word (use dot to replace next word)" },
}

-- Various language settings -------------------------------------------------------- {{{1

-- Settings for pangloss/vim-javascript
-- vim.g.javascript_plugin_jsdoc = true
-- vim.g.javascript_plugin_ngdoc = false
-- vim.g.javascript_plugin_flow = false

-- Settings for elzr/vim-json
vim.g.vim_json_syntax_conceal = true

-- Settings for plasticboy/vim-markdown
vim.g.vim_markdown_toc_autofit = true
vim.g.vim_markdown_conceal_code_blocks = false
vim.g.vim_markdown_follow_anchor = true
vim.g.vim_markdown_strikethrough = true

-- Create alias for fenced languages with the format: alias=actual
vim.g.vim_markdown_fenced_languages = {
	"c++=cpp",
	"viml=vim",
	"bash=sh",
	"ini=dosini",
}

-- Setup vim-rooter ----------------------------------------------------------------- {{{1

vim.g.rooter_patterns = { "vim.toml", ".git", ".hg", ".bzr", ".svn", "Makefile", "package.json" }

-- Neoformat settings --------------------------------------------------------------- {{{1

vim.g.neoformat_basic_format_align = false
vim.g.neoformat_basic_format_retab = false
vim.g.neoformat_basic_format_trim = true
vim.g.neoformat_enabled_haskell = { "stylishhaskell", "ormolu" }
vim.g.neoformat_enabled_python = { "black" }
vim.g.neoformat_enabled_javascript = { "prettier" }
vim.g.neoformat_enabled_lua = { "stylua" }

-- orgmode settings--- -------------------------------------------------------------- {{{1

local orgmode = require "orgmode"

orgmode.setup {}

-- Bufferline settings -------------------------------------------------------------- {{{1

local bufferline = require "bufferline"

bufferline.setup {
	options = {
		diagnostics = "nvim_lsp",
		sort_by = "directory",
	},
}

-- Diffview.nvim settings ----------------------------------------------------------- {{{1

local diffview = require "diffview"

diffview.setup {
	use_icons = true,
}

-- nvim-cmp config ---------------------------------------------------------------- {{{1

local cmp = require "cmp"
local lspkind = require "lspkind"

lspkind.init {}

cmp.setup {
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			-- TODO: Setup more mappings for vsnip
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<c-n>"] = cmp.mapping.select_next_item(),
		["<c-p>"] = cmp.mapping.select_prev_item(),
		["<c-e>"] = cmp.mapping.close(),
		["<c-y>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "orgmode" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "spell" },
	},
}

-- Setup gitsigns ------------------------------------------------------------------- {{{1

local gitsigns = require "gitsigns"

gitsigns.setup {
	signs = {
		add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 100,
	},
	current_line_blame_formatter = function(name, blame_info, opts)
		if blame_info.author == name then
			blame_info.author = "You"
		end

		local text
		if blame_info.author == "Not Committed Yet" then
			text = blame_info.author
		else
			local date_time

			if opts.relative_time then
				date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
			else
				date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
			end

			text = string.format("%s • %s • %s", blame_info.author, date_time, blame_info.summary)
		end

		return { { " " .. text, "GitSignsCurrentLineBlame" } }
	end,
}

-- Setup neoscroll ------------------------------------------------------------------ {{{1

local neoscroll = require "neoscroll"

neoscroll.setup {
	mappings = {
		"zt",
		"zz",
		"zb",
		"<C-u>",
		"<C-f>",
		"<C-e>",
		"<C-y>",
	},
	hide_cursor = true, -- Hide cursor while scrolling
	stop_eof = true, -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
}

-- Setup colorizer ------------------------------------------------------------------ {{{1

local colorizer = require "colorizer"

colorizer.setup {
	"css",
	"html",
	"lua",
	"vim",
}

-- Setup nvim-autopairs ------------------------------------------------------------- {{{1

local autopairs = require "nvim-autopairs"

autopairs.setup {
	disable_filetype = { "TelescopePrompt" },
	check_ts = true,
}
