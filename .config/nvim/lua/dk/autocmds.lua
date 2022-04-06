-- Neovim autocmds

-- Automatically start in insert mode in terminals.
-- And turn off the number column in terminal buffers.
local Term = vim.api.nvim_create_augroup("Term", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "*",
	command = "setlocal nonumber | startinsert",
	group = Term,
})

-- Auto-format buffers before writing them using either language server or Neoformat.
local AutoFormat = vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*",
	callback = function()
		require("dk.lsp").format()
	end,
	group = AutoFormat,
})

-- Set language specific local options automatically.
local LanguageOverrides = vim.api.nvim_create_augroup("LanguageOverrides", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "haskell", "cabal", "yaml" },
	command = "setlocal expandtab shiftwidth=2",
	group = LanguageOverrides,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "json",
	command = "setlocal foldmethod=syntax",
	group = LanguageOverrides,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "text", "rst", "org", "norg" },
	command = "setlocal spell wrap textwidth=70 wrapmargin=5 shiftwidth=2",
	group = LanguageOverrides,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "gitsendmail" },
	command = "setlocal spell",
	group = LanguageOverrides,
})
