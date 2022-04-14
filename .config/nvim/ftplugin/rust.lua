-- Settings for Rust.
-- Some Rust settings are left in init.lua

local rust_tools = require "rust-tools"
local lsp_settings = require "dk.lsp"

-- Lsp setup ----------------------------------------------------------------------- {{{1

-- Use rust-analyzer from rustup if rustup is installed
local cmd = "rust-analyzer"
if vim.fn.executable "rustup" == 1 then
	cmd = { "rustup", "run", "nightly", "rust-analyzer" }
end

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
		cmd = cmd,
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
