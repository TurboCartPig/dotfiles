local map = vim.api.nvim_set_keymap

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
vim.opt.spelllang = "en,nb"
vim.opt.spelloptions = "camel"

-- TODO: Find a way to cycle through predefined listchars
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", nbsp = "␣", lead = "·", trail = "·", precedes = "«", extends = "»" }
-- Alternative: eol:¬

-- Folds
-- 'foldmethod' and 'foldlevel' are set by autocmds for various filetypes
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 3
vim.opt.foldminlines = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.fillchars = "fold: "
vim.opt.foldtext =
	[[substitute(getline(v:foldstart), '\t', repeat('\ ', &tabstop), 'g').'...'.trim(getline(v:foldend))]]

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

-- Source the rest of the configs
require "dk.plugins"
require "dk.plugins.misc"
require "dk.lsp"
-- require "dk.dap"

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
