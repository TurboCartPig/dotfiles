-- Source config modules
require "dk.options"
require "dk.colorscheme"
require "dk.plugins"
require "dk.plugins.misc"
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
		autocmd BufWritePre <buffer> lua require("dk.lsp").format()
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

-- vi: foldmethod=marker
