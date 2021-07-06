-- Settings for Go

-- vim-go settings ------------------------------------------------------------------ {{{1

-- Disable functionality included by neovim itself
vim.g.go_code_completion_enabled = false
vim.g.go_gopls_enabled = false

-- Disable auto-stuff, neoformat and gopls handles this perfectly well
vim.g.go_fmt_autosave = false
vim.g.go_imports_autosave = false
vim.g.go_mod_fmt_autosave = false
vim.g.go_metalinter_autosave = false

-- Disable misc
vim.g.go_doc_keywordprg_enabled = false
vim.g.go_def_mapping_enabled = false
vim.g.go_auto_type_info = false
vim.g.go_auto_sameids = false
vim.g.go_jump_to_error = true

-- Set golangci-lint as metalinter
vim.g.go_metalinter_command = "golangci-lint"
vim.g.go_metalinter_deadline = "2s"

-- Setup language server ----------------------------------------------------------- {{{1
local lsp_config = require "lspconfig"
local lsp_settings = require "lsp-settings"

lsp_config.gopls.setup {
	on_attach = lsp_settings.on_attach,
	settings = {},
}
