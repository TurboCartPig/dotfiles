-- Leader
vim.g.mapleader = " "

-- Set shell to powershell core on windows
if vim.fn.has "win32" == 1 and vim.fn.exists "pwsh.exe" == 1 then
	vim.opt.shell = "pwsh.exe"
elseif vim.fn.has "unix" == 1 and vim.fn.exists "/opt/homebrew/bin/zsh" == 1 then
	vim.opt.shell = "/opt/homebrew/bin/zsh"
elseif vim.fn.has "unix" == 1 and vim.fn.exists "/usr/bin/zsh" == 1 then
	vim.opt.shell = "/usr/bin/zsh"
end

vim.cmd [[filetype plugin indent on]]

-- Defaults to Norwegian on Windows for some reason
if vim.fn.has "win32" == 1 then
	vim.cmd [[language en_US.utf8]]
else
	-- macOS
	vim.cmd [[language en_US.UTF-8]]
end

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
vim.opt.formatoptions:remove { "o" }

-- Wrapping and line limits
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.textwidth = 120
vim.opt.wrapmargin = 5

-- Scrolloff
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.virtualedit = "block"

-- Columns and lines
vim.opt.numberwidth = 4
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.showmode = false -- Redundant by statusline
vim.opt.showcmd = false
vim.opt.laststatus = 3 -- Global statusline

-- Visual stuff
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor"
vim.opt.guifont = "FiraCode NF:h14"

-- spellchecking
-- NOTE: spell is only set for some filetypes
vim.opt.spelllang = "en"
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = ""

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
vim.opt.winwidth = 80
vim.opt.winminheight = 3
vim.opt.winminwidth = 8

-- Menus
vim.opt.wildmenu = true
vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.shortmess = "filoOTcF"

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:3,hor:0"

-- Misc
vim.opt.clipboard = "unnamed,unnamedplus"
-- vim.opt.updatetime = 200
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.sessionoptions = "curdir,folds,help,resize,tabpages,winsize"
