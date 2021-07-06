-- Settings for Rust.
-- Some Rust settings are left in init.lua

local rust_tools = require "rust-tools"
local lsp_settings = require "lsp-settings"

-- Lsp setup ----------------------------------------------------------------------- {{{1

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
		on_attach = lsp_settings.on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}

-- Rust.vim settings ---------------------------------------------------------------- {{{1

-- Disable functionality included by other plugins
vim.g.rustfmt_autosave = false
vim.g.rustfmt_fail_silently = true
