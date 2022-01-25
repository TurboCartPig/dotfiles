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

		autocmd ColorScheme gruvbox highlight  link Operator       GruvboxRed
		autocmd ColorScheme gruvbox highlight  link NormalFloat    GruvboxFg0

		autocmd ColorScheme gruvbox highlight! link DiffAdd        GruvboxGreenSign
		autocmd ColorScheme gruvbox highlight! link DiffChange     GruvboxPurpleSign
		autocmd ColorScheme gruvbox highlight! link DiffDelete     GruvboxRedSign
		autocmd ColorScheme gruvbox highlight! link GitsignsAdd    DiffAdd
		autocmd ColorScheme gruvbox highlight! link GitsignsDelete DiffDelete
		autocmd ColorScheme gruvbox highlight! link GitsignsChange DiffChange

		autocmd ColorScheme gruvbox highlight! link WhichKeyGroup  Identifier

		autocmd ColorScheme gruvbox highlight! link DiagnosticSignError DiagnosticError
		autocmd ColorScheme gruvbox highlight! link DiagnosticSignHint  DiagnosticHint
		autocmd ColorScheme gruvbox highlight! link DiagnosticSignWarn  DiagnosticWarn
		autocmd ColorScheme gruvbox highlight! link DiagnosticSignInfo  DiagnosticInfo
		autocmd ColorScheme gruvbox highlight! link DiagnosticSignOther DiagnosticOther
	augroup END
]]

vim.cmd [[colorscheme gruvbox]]
