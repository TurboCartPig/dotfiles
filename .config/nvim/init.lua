-- Source config modules
require "dk.options"
require "dk.colorscheme"
-- require "dk.plugins"
require "dk.lsp"
require "dk.dap"

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
		autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 
	augroup END

	" Format on save
	augroup AutoFormat
		autocmd!
		autocmd BufWritePre * lua require("dk.lsp").format()
	augroup END

	" Override fold methods per language
	augroup FoldingSettings
		autocmd!
		autocmd FileType json setlocal foldmethod=syntax
	augroup END

	" Plaintext editing
	augroup Plaintext
		autocmd!
		autocmd FileType markdown,org,text,rst setl spell wrap textwidth=70 wrapmargin=5
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

-- Neovim set custom keymappings ---------------------------------------------------- {{{1

local map = vim.api.nvim_set_keymap
local opts = {
	noremap = true,
}

-- Strong left/right
map("n", "H", "0", opts)
map("n", "L", "$", opts)
map("v", "H", "0", opts)
map("v", "L", "$", opts)

-- Move between windows easier in normal mode
map("n", "<leader>w", "<c-w>", opts)

-- Neovim set custom keybinds ------------------------------------------------------- {{{1

local wk = require "which-key"

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

-- Goyo settings -------------------------------------------------------------------- {{{1

vim.g.goyo_width = 100
vim.g.goyo_height = 80

-- Prevent loading of default plugins ----------------------------------------------- {{{1

-- NOTE: Could be useful for goto definition into archives
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

-- NOTE: I need these to download norwegian 'spell' dictionaries
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- vi: foldmethod=marker
