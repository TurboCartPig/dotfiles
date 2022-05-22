-- Source config modules
require "dk.options"
require "dk.colorscheme"
-- require "dk.plugins"
require "dk.lsp"
require "dk.dap"
require "dk.globals"
require "dk.autocmds"
require "dk.keymaps"
require "dk.statusline"

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

-- Neovim set custom commands ------------------------------------------------------- {{{1

vim.api.nvim_create_user_command("Pdf", [[hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"]], {})

-- vi: foldmethod=marker
