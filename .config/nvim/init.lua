local map = vim.api.nvim_set_keymap

require "dk.plugins"
require "dk.lsp"
require "dk.dap"

if vim.g.neovide then
	vim.g.neovide_refresh_rate = 120
end

-- Neovim set options --------------------------------------------------------------- {{{1

-- Leader
vim.g.mapleader = " "

-- Set shell to powershell core on windows
if vim.fn.has "win32" == 1 and vim.fn.exists "pwsh.exe" == 1 then
	vim.opt.shell = "pwsh.exe"
elseif vim.fn.has "unix" == 1 and vim.fn.exists "/usr/bin/zsh" == 1 then
	vim.opt.shell = "/usr/bin/zsh"
end

vim.cmd [[filetype plugin indent on]]

-- Needed for some plugins to work properly
vim.opt.hidden = true

vim.opt.autowrite = true
vim.opt.swapfile = false

-- Keep undo file
vim.opt.undofile = true

-- Search
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = false

-- Formatting
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0

-- Wrapping and line limits
vim.opt.wrap = false
vim.opt.textwidth = 120
vim.opt.wrapmargin = 5

-- Gutters/Scrolloffs and stuff
vim.opt.numberwidth = 3
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
-- vim.opt.cmdheight = 2 -- Maybe I don't need this?
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.virtualedit = "block"

-- Visual stuff
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor"
vim.opt.guifont = "Hasklug NF:h14"

-- spellchecking
-- NOTE: spell is only set for some filetypes
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = "camel"

-- TODO: Find a way to cycle through predefined listchars
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", nbsp = "␣", lead = "·", trail = "·", precedes = "«", extends = "»" }
-- Alternative: eol:¬

-- Folds
-- 'foldmethod' and 'foldlevel' are set by autocmds for various filetypes
vim.opt.foldlevelstart = 99

-- Conceals
vim.opt.concealcursor = "nc"
vim.opt.conceallevel = 2

-- Sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Window settings
vim.opt.winheight = 12
vim.opt.winwidth = 110
vim.opt.winminheight = 3
vim.opt.winminwidth = 8

-- Menus
vim.opt.wildmenu = true
vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.shortmess = "filoOTcF"

-- Misc
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.updatetime = 200
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.sessionoptions = "curdir,folds,help,resize,tabpages,winsize"
vim.opt.printoptions = { syntax = "y", number = "y", left = 0, right = 2, top = 2, bottom = 2 }

-- Neovim set abbreviations --------------------------------------------------------- {{{1

-- Command abbreviations
vim.cmd [[
	cnoreabbrev Q q
	cnoreabbrev Q! q!
	cnoreabbrev Qa qa
	cnoreabbrev W w
	cnoreabbrev W! w!
	cnoreabbrev Wa wa
	cnoreabbrev WA wa
	cnoreabbrev Wq wq
	cnoreabbrev WQ wq
	cnoreabbrev WQ! wq!
]]

-- Abbreviations
vim.cmd [[
	noreabbrev lenght length
	noreabbrev widht width
	noreabbrev higth height
	noreabbrev nigthly nightly
]]

-- Neovim autocmds ------------------------------------------------------------------ {{{1

vim.cmd [[
	" Formatting overrides
	augroup FormattingOverrides
		autocmd!
		autocmd FileType haskell,cabal setlocal expandtab shiftwidth=2
	augroup END

	" Override fold methods per language
	augroup FoldingSettings
		autocmd!

		" Use treesitter to automatically create folds
		autocmd FileType c,cpp,go,rust,lua setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

		autocmd FileType json setlocal foldmethod=syntax
	augroup END

	" Plaintext editing
	augroup Plaintext
		autocmd!
		autocmd FileType markdown,org,text,rst setl spell textwidth=70 wrapmargin=5
	augroup END

	augroup Term
		autocmd!
		autocmd TermOpen * startinsert
	augroup END

	augroup DashboardTabline
		autocmd!
		autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2
	augroup END
]]

-- Termdebug settings --------------------------------------------------------------- {{{1
vim.g.termdebug_popup = 0
vim.g.termdebug_wide = 163

-- Neovim set custom commands ------------------------------------------------------- {{{1

vim.cmd [[command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"]]

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

-- Neovim LSP keymappings ----------------------------------------------------------- {{{1

wk.register {
	["gh"] = {
		function()
			vim.lsp.buf.hover()
		end,
		"LSP: Hover",
	},
	["gi"] = {
		function()
			vim.diagnostic.show_line_diagnostics()
		end,
		"LSP: Show Line Diagnostics",
	},
	["<leader>r"] = {
		function()
			vim.lsp.buf.rename()
		end,
		"LSP: Rename symbol",
	},
	["<leader>f"] = {
		function()
			vim.lsp.buf.formatting()
		end,
		"LSP: Format buffer",
	},
}

-- Neovim set custom keybinds ------------------------------------------------------- {{{1

wk.register {
	["<leader><leader>"] = { "<cmd>buffer#<cr>", "Switch buffers" },
	["<s-esc>"] = { "<cmd>close<cr>", "Close window" },
	["<c-d>"] = { "*<c-o>cgn", "Change multiple of the same word (use dot to replace next word)" },
}

-- String left/right
map("n", "H", "0", { noremap = true })
map("n", "L", "$", { noremap = true })
map("v", "H", "0", { noremap = true })
map("v", "L", "$", { noremap = true })

-- Move between windows easier in normal mode
map("n", "<c-h>", "<c-w>h", { noremap = true })
map("n", "<c-j>", "<c-w>j", { noremap = true })
map("n", "<c-k>", "<c-w>k", { noremap = true })
map("n", "<c-l>", "<c-w>l", { noremap = true })

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

-- Setup dashboard ------------------------------------------------------------------ {{{1
vim.g.dashboard_default_executive = "telescope"

vim.g.dashboard_custom_header = {
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

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

-- nvim-tree settings --------------------------------------------------------------- {{{1

vim.g.nvim_tree_width = 20
vim.g.nvim_tree_gitignore = false
vim.g.nvim_tree_ignore = {
	".git",
	"node_modules",
	".idea",
	"__pycache__",
}

-- Toggle file tree
wk.register {
	["<m-1>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle nvim-tree" },
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

-- Telescope config ----------------------------------------------------------------- {{{1

local telescope = require "telescope"

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

-- Treesitter config ---------------------------------------------------------------- {{{1

local ts = require "nvim-treesitter.configs"

ts.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
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
	context_commentstring = {
		enable = true,
	},
	autotag = {
		enable = true,
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

-- Only use neoscroll in terminal
if vim.g.neovide then
	map("n", "J", "10j", { noremap = true })
	map("n", "K", "10k", { noremap = true })
else
	local neoscroll = require "neoscroll"
	local neoscroll_config = require "neoscroll.config"

	neoscroll.setup {
		mappings = {
			"zt",
			"zz",
			"zb",
			"J",
			"K",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	}

	-- Setup custom mappings
	local mappings = {}
	mappings["J"] = { "scroll", { "0.20", "false", "10" } }
	mappings["K"] = { "scroll", { "-0.20", "false", "10" } }
	neoscroll_config.set_mappings(mappings)
end

-- Setup colorizer ------------------------------------------------------------------ {{{1

local colorizer = require "colorizer"

colorizer.setup {
	"css",
	"html",
	"lua",
}

-- Setup nvim-autopairs ------------------------------------------------------------- {{{1

local autopairs = require "nvim-autopairs"

autopairs.setup {
	disable_filetype = { "TelescopePrompt" },
}

-- highlights and colorscheme ------------------------------------------------------- {{{1

-- Setup auto commands for overriding highlight when gruvbox is set as the colorscheme.
-- This fixes issues with the colorscheme plugin I use.
-- And it makes it so I can flip between different colorschemes, while my gruvbox overrides only effect gruvbox.

-- 1. Clear annoying colors
-- 2. Override some poor defaults and correct omissions from colorscheme
vim.cmd [[
	augroup ColorOverrides
		autocmd!
		autocmd ColorScheme gruvbox highlight  Cursor            gui=NONE   guibg=#FB4632 guifg=NONE
		autocmd ColorScheme gruvbox highlight  SignColumn        guibg=none
		autocmd ColorScheme gruvbox highlight  Folded            guibg=none
		autocmd ColorScheme gruvbox highlight  FoldColumn        guibg=none
		autocmd ColorScheme gruvbox highlight  StatusLine        guibg=none guifg=#292929
		autocmd ColorScheme gruvbox highlight  StatusLineNC      guibg=none guifg=#292929
		autocmd ColorScheme gruvbox highlight  GruvboxAquaSign   guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxBlueSign   guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxGreenSign  guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxOrangeSign guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxPurpleSign guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxRedSign    guibg=none
		autocmd ColorScheme gruvbox highlight  GruvboxYellowSign guibg=none

		autocmd ColorScheme gruvbox highlight  link Operator     GruvboxRed
		autocmd ColorScheme gruvbox highlight  link NormalFloat  GruvboxFg0
		autocmd ColorScheme gruvbox highlight! link DiffAdd      GruvboxGreenSign
		autocmd ColorScheme gruvbox highlight! link DiffChange   GruvboxPurpleSign
		autocmd ColorScheme gruvbox highlight! link DiffDelete   GruvboxRedSign
		autocmd ColorScheme gruvbox highlight! link WhichKeyGroup Identifier
	augroup END
]]

vim.cmd [[colorscheme gruvbox]]

-- vi: foldmethod=marker
