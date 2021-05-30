local vim = vim
local map = vim.api.nvim_set_keymap

require("plugins")

-- Neovim set options -------------------------------------------------------------------- {{{1

-- Leader
vim.g.mapleader = " "

-- Set shell to powershell core on windows
if vim.fn.has("win32") == 1 and vim.fn.exists("pwsh.exe") == 1 then
	vim.opt.shell = "pwsh.exe"
elseif vim.fn.has("unix") == 1 and vim.fn.exists("/usr/bin/zsh") == 1 then
	vim.opt.shell = "/usr/bin/zsh"
end

vim.cmd [[filetype plugin indent on]]

-- Needed for some plugins to work properly
vim.opt.hidden = true
vim.opt.swapfile = false

-- Keep undo file
vim.opt.undofile = true

-- Search
vim.opt.incsearch = true
vim.opt.showmatch = true

-- Formatting
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0

-- Visual stuff
vim.opt.numberwidth = 3
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cmdheight = 2
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.termguicolors = true
vim.opt.guifont = "FiraCode NF:h15"

-- TODO: Find a way to cycle through predefined listchars
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", nbsp = "␣", lead = "·", trail = "·", precedes = "«", extends = "»" }
-- Alternative: eol:¬

-- Folds
-- 'foldmethod' and 'foldlevel' are set by autocmds for various filetypes
vim.opt.foldlevelstart=99

-- Conceals
vim.opt.concealcursor = "nc"
vim.opt.conceallevel = 2

-- Sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Menus
vim.opt.wildmenu = true
vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.shortmess = "filoOTcF"

-- Misc
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.updatetime = 200
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.printoptions = { syntax = "y", number = "y", left = 0, right = 2, top = 2, bottom = 2 }

-- Neovim set abbreviations -------------------------------------------------------------- {{{1

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

-- Neovim autocmds ----------------------------------------------------------------------- {{{1

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

		" Use manually placed markers in all vimscript files
		autocmd FileType vi,vim setlocal foldlevel=0 foldmethod=marker

		autocmd FileType json setlocal foldmethod=syntax
	augroup END

	" Spell checking
	augroup SpellChecking
		autocmd!
		autocmd FileType markdown,text,rst setlocal spell spelllang=en_us
	augroup END

	augroup Term
		autocmd!
		autocmd TermOpen * startinsert
	augroup END
]]

-- Neovim set custom commands ------------------------------------------------------------ {{{1

vim.cmd [[command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"]]

-- Neovim set custom keybinds ------------------------------------------------------------ {{{1

-- Switch between two buffers easily
map("n", "<leader><leader>", "<cmd>b#<cr>", { noremap = true, silent = true })

-- Move around easier in insert mode
map("i", "<c-h>", "<left>",  { noremap = true })
map("i", "<c-j>", "<down>",  { noremap = true })
map("i", "<c-k>", "<up>",    { noremap = true })
map("i", "<c-l>", "<right>", { noremap = true })

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

-- Fix broken AlrGr keys with neovide
-- NOTE: This is just a hack and should be fixed properly in
-- neovide by figuring out the whole windows backend issue they have.
map("i", "<C-M-[>", "[", { noremap = true })
map("i", "<C-M-]>", "]", { noremap = true })
map("i", "<C-M-{>", "{", { noremap = true })
map("i", "<C-M-}>", "}", { noremap = true })
map("i", "<C-M-@>", "@", { noremap = true })
map("i", "<C-M-`>", "`", { noremap = true })
map("i", "<C-M-´>", "´", { noremap = true })

-- vim-polyglot settings ------------------------------------------------------------ {{{1
vim.g.polyglot_disabled = { "go", "rust", "json", "autoindent", "sensible" }

-- Settings for elzr/vim-json
vim.g.vim_json_syntax_conceal = true

-- Settings for plasticboy/vim-markdown
vim.g.vim_markdown_toc_autofit         = true
vim.g.vim_markdown_conceal_code_blocks = false
vim.g.vim_markdown_follow_anchor       = true
vim.g.vim_markdown_strikethrough       = true

-- Create alias for fenced languages with the format: alias=actual
vim.g.vim_markdown_fenced_languages = {
	"c++=cpp",
	"viml=vim",
	"bash=sh",
	"ini=dosini",
}

-- Explicitly load plugin after setting polyglot_disabled
vim.cmd [[packadd vim-polyglot]]

-- vim-go settings ------------------------------------------------------------------ {{{1
-- Disable functionality included by neovim itself
vim.g.go_code_completion_enabled = false
vim.g.go_gopls_enabled           = false

-- Disable auto-stuff, neoformat and gopls handles this perfectly well
vim.g.go_fmt_autosave            = false
vim.g.go_imports_autosave        = false
vim.g.go_mod_fmt_autosave        = false
vim.g.go_metalinter_autosave     = false

-- Disable misc
vim.g.go_doc_keywordprg_enabled  = false
vim.g.go_def_mapping_enabled	 = false
vim.g.go_auto_type_info			 = false
vim.g.go_auto_sameids			 = false
vim.g.go_jump_to_error			 = true

-- Set golangci-lint as metalinter
vim.g.go_metalinter_command      = "golangci-lint"
vim.g.go_metalinter_deadline     = "2s"

-- Termdebug settings --------------------------------------------------------------- {{{1
vim.g.termdebug_popup = 0
vim.g.termdebug_wide  = 163

-- git-blame.nvim settings ---------------------------------------------------------- {{{1
vim.g.gitblame_enabled          = false
vim.g.gitblame_message_template = "<author> • <summary> • <date>"

-- Neoformat settings --------------------------------------------------------------- {{{1
vim.g.neoformat_basic_format_align = false
vim.g.neoformat_basic_format_retab = true
vim.g.neoformat_basic_format_trim  = true
vim.g.neoformat_enabled_haskell    = { "stylish-haskell", "ormolu" }
vim.g.neoformat_enabled_python     = { "black"}

map("n", "<c-m-L>", [[<cmd>Neoformat<cr>]], { noremap = true, silent = true })

-- Airline settings ----------------------------------------------------------------- {{{1

vim.g.airline_theme = "minimalist"
vim.g.airline_skip_empty_sections = true
vim.g.airline_powerline_fonts = true
vim.g.airline_highlighting_cache = true
vim.g.airline_extensions = { "branch", "quickfix", "term", "wordcount" }
vim.g["airline#extensions#default#layout"] = {
	{ "a", "b", "c" },
	{ "warning", "error", "z" },
}

-- Add the lsp status line component to the airline
vim.cmd [[
	" Create a status line part from lsp status
	function! LspStatus() abort
		let status = luaeval('require("lsp-status").status()')
		return trim(status)
	endfunction

	" Define lsp status part
	call airline#parts#define_function('lsp_status', 'LspStatus')
	call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
	let g:airline_section_warning = airline#section#create_right(['lsp_status'])
]]

-- Bufferline settings -------------------------------------------------------------- {{{1

local bufferline = require("bufferline")

bufferline.setup {
	options = {
		diagnostics = "nvim_lsp",
		sort_by = "directory",
	},
}

-- nvim-tree settings --------------------------------------------------------------- {{{1

-- Setup ignores
vim.g.nvim_tree_gitignore = false
vim.g.nvim_tree_ignore = {
	".git", "node_modules", ".idea", "__pycache__"
}

-- Toggle file tree
map("n", "<m-1>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })

-- nvim-compe config ---------------------------------------------------------------- {{{1

local compe = require("compe")

-- Setup compe auto completions
compe.setup {
	enable = true,
	autocomplete = true,
	debug = false,
	min_length = 2,
	preselect = "disable",
	documentation = true,
	source = {
		calc = false,
		buffer = true,
		nvim_lsp = true,
		nvim_lua = true,
		omni = false,
		-- tabnine = true,
		tags = false,
		spell = true,
		path = true,
		vsnip = false,
	},
}

map("i", "<c-y>", [[compe#confirm("<cr>")]], { expr = true, noremap = true, silent = true })
map("i", "<c-e>", [[compe#close("<c-e>")]],  { expr = true, noremap = true, silent = true })

-- Neovim lsp status line config ------------------------------------------------------ {{{1

local lsp_status = require("lsp-status")

-- use LSP SymbolKinds themselves as the kind labels
local kind_labels_mt = { __index = function(_, k) return k end }
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

-- setup lsp_status line
lsp_status.register_progress()
lsp_status.config {
	kind_labels = kind_labels,
	indicator_errors = "×",
	indicator_warnings = "!",
	indicator_info = "i",
	indicator_hint = "›",
	-- the default is a wide codepoint which breaks absolute and relative
	-- line counts if placed before airline's Z section
	status_symbol = "",
}

-- Neovim lsp config ----------------------------------------------------------------- {{{1

local lsp_config = require("lspconfig")
local lsp_configs = require("lspconfig/configs")

-- NOTE: This is broken now?
-- Fixes missing .cmd extensions for language servers
-- vim.loop.spawn = (function ()
--   local spawn = vim.loop.spawn
--   return function(path, options, on_exit)
--     local full_path = vim.fn.exepath(path)
--     return spawn(full_path, options, on_exit)
--   end
-- end)()

-- Run this every time a language server attaches to a buffer
local on_attach = function(client, bufnr)
	-- require("completion").on_attach(client, bufnr)
	lsp_status.on_attach(client, bufnr)

	-- Setup completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Setup lightbulb on code_action
	vim.cmd("autocmd CursorHold,CursorHoldI <buffer> lua require('nvim-lightbulb').update_lightbulb()")

	-- Setup line diagnostic on hover
	vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()")

	-- Setup hover? on hover
	-- if client.resolved_capabilities.hover then
	-- 	vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.buf.hover()")
	-- end

	-- Setup signature help on hover
	-- FIXME: STFU when there are no signature help available
	-- if client.resolved_capabilities.signature_help then
	-- 	vim.cmd("autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()")
	-- end

	-- Only setup format on save for servers that support it
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)")
	end
end

-- List all the servers and any custom configuration
local servers = {
	hls = {
		languageServerHaskell = {
			formattingProvider = "stylish-haskell",
		},
	},
	clangd = {},
	gopls = {},
	pyls = {},
	pyright = {},
	vimls = {},
	dockerls = {},
	jsonls = {},
	yamlls = {},
	-- html = {},
}

-- Setup all the servers with their respective settings
for ls, settings in pairs(servers) do
	lsp_config[ls].setup {
		on_attach = on_attach,
		settings = settings,
		capabilities = vim.tbl_extend("keep", lsp_configs[ls].capabilities or {}, lsp_status.capabilities),
	}
end

-- Find lua language server based on platform
local sumneko_root
local sumneko_bin
if vim.fn.has("win32") == 1 then
	sumneko_root = "C:/Projects/lua-language-server"
	sumneko_bin  = sumneko_root .. "/bin/Windows/lua-language-server.exe"
elseif vim.fn.has("unix") == 1 then
	sumneko_root = vim.fn.expand("$HOME/Projects/lua-language-server")
	sumneko_bin  = sumneko_root .. "/bin/Linux/lua-language-server"
end

-- Ripped from tjdevries/nlua
-- Maybe I should just use that plugin?
local get_lua_runtime = function()
	local res = {}

	res[vim.fn.expand("$VIMRUNTIME/lua")] = true
	res[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. "/lua/"
		if vim.fn.isdirectory(lua_path) then
			res[lua_path] = true
		end
	end

	return res
end

-- Setup lua language server
lsp_config.sumneko_lua.setup {
	cmd = { sumneko_bin, "-E", sumneko_root .. "/main.lua" },
	on_attach = on_attach,
	capabilities = lsp_status.capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
		},
		completion = {
			keywordSnippet = "Disable",
		},
		diagnostics = {
			enable = true,
			globals = { "vim" },
		},
		workspace = {
			library = get_lua_runtime(),
			maxPreload = 1000,
			preloadFileSize = 1000,
		},
	},
}

-- Rust tools config ---------------------------------------------------------------- {{{1

local rust_tools = require("rust-tools")

rust_tools.setup {
	tools = {
		autoSetHints = true,
		hover_with_actions = false,
		inlay_hints = {
			show_parameter_hints = true,
			parameter_hints_prefix = "« ",
			other_hints_prefix = "» ",
		},
	},
	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}

-- Telescope config ----------------------------------------------------------------- {{{1
map("n", "gr",     [[<cmd>lua require("telescope.builtin").lsp_references()<cr>]],
	{ noremap = true, silent = true })
map("n", "gs",     [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>]],
	{ noremap = true, silent = true })
map("n", "gll",    [[<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>]],
	{ noremap = true, silent = true })
map("n", "<m-cr>", [[<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>]],
	{ noremap = true, silent = true })
map("n", "<c-cr>", [[<cmd>lua require("telescope.builtin").spell_suggest()<cr>]],
	{ noremap = true, silent = true })
map("n", "<c-p>",  [[<cmd>lua require("telescope.builtin").git_files()<cr>]],
	{ noremap = true, silent = true })
map("n", "<c-t>",  [[<cmd>lua vim.lsp.buf.hover()<cr>]],
	{ noremap = true, silent = true })
map("n", "R",      [[<cmd>lua vim.lsp.buf.rename()<cr>]],
	{ noremap = true, silent = true })
map("n", "<c-q>",  [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>]],
	{ noremap = true, silent = true })

-- Treesitter config ---------------------------------------------------------------- {{{1
local ts = require("nvim-treesitter.configs")

ts.setup {
	ensure_installed = {
		"c", "cpp", "go", "rust",
		"javascript", "typescript", "html", "css",
		"python", "lua",
		"bash", "comment",
		"yaml", "toml", "json",
	},
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
				["<leader><C-j>"] = "@function.outer"
			},
			swap_previous = {
				["<leader><C-h>"] = "@parameter.inner",
				["<leader><C-k>"] = "@function.outer"
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["<leader>J"] = "@function.outer",
			},
			goto_previous_start = {
				["<leader>K"] = "@function.outer",
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
				smart_rename = "<leader>r",
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
}

-- Setup gitsigns ------------------------------------------------------------------- {{{1

local gitsigns = require("gitsigns")

gitsigns.setup {
	signs = {
		add          = { hl = "GitSignsAdd"   , text = "│", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn" },
		change       = { hl = "GitSignsChange", text = "│", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
		delete       = { hl = "GitSignsDelete", text = "_", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
		topdelete    = { hl = "GitSignsDelete", text = "‾", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
	},
}

-- Setup neoscroll ------------------------------------------------------------------ {{{1

local neoscroll = require("neoscroll")
local neoscroll_config = require("neoscroll.config")

neoscroll.setup {
    mappings = {
		'<C-u>', '<C-d>',
		'<C-b>', '<C-f>',
		'zt', 'zz', 'zb',
		'J', 'K',
	},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
}

-- Setup custom mappings
local mappings = {}
mappings["J"] = { "scroll", {  "0.20", "false", "10" } }
mappings["K"] = { "scroll", { "-0.20", "false", "10" } }
neoscroll_config.set_mappings(mappings)

-- Setup colorizer ---------------------------------------------------------------- {{{1

-- local colorizer = require("colorizer")

-- colorizer.setup {
-- 	"css",
-- 	"html",
-- }

-- Setup nvim-autopairs ----------------------------------------------------------- {{{1

local autopairs = require("nvim-autopairs")

autopairs.setup {
	disable_filetype = { "TelescopePrompt" },
}

-- highlights and colorscheme ----------------------------------------------------- {{{1

-- Clear annoying colors
vim.cmd [[
	augroup ColorSchemeOverrides
		autocmd!
		autocmd ColorScheme *       highlight SignColumn        guibg=none
		autocmd ColorScheme *       highlight Folded            guibg=none
		autocmd ColorScheme *       highlight FoldColumn        guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxAquaSign   guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxBlueSign   guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxGreenSign  guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxOrangeSign guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxPurpleSign guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxRedSign    guibg=none
		autocmd ColorScheme gruvbox highlight GruvboxYellowSign guibg=none
	augroup end
]]

vim.opt.background = "dark"
vim.cmd [[colorscheme gruvbox]]

-- vi: foldmethod=marker foldlevel=0
