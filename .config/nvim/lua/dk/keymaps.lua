local wk = require "which-key"
local dap = require "dap"
local ts = require "telescope"
local tb = require "telescope.builtin"

-- Strong left/right
vim.keymap.set("n", "H", "0")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "0")
vim.keymap.set("v", "L", "$")

-- Move between windows easier in normal mode
vim.keymap.set("n", "<leader>w", "<c-w>")

-- Register keymaps with which-key for completion and descriptions
wk.register {
	["<leader><leader>"] = { "<cmd>buffer#<cr>", "Switch buffers" },
	["<s-esc>"] = { "<cmd>close<cr>", "Close window" },
	["<c-d>"] = { "*<c-o>cgn", "Change multiple of the same word (use dot to replace next word)" },
	["<leader>ss"] = {
		function()
			require("dk.utils").reload()
		end,
		"Reload config in-place",
	},
	["<leader>s."] = {
		function()
			vim.cmd [[luafile %]]
			print "File reloaded!"
		end,
		"Reload this config file in-place",
	},
}

-- DAP keymappings
wk.register {
	["<leader>"] = {
		name = "DAP",
		["dd"] = {
			function()
				dap.toggle_breakpoint()
			end,
			"DAP: Toggle breakpoint",
		},
		["dc"] = {
			function()
				dap.continue()
			end,
			"DAP: Continue",
		},
		["di"] = {
			function()
				dap.step_into()
			end,
			"DAP: Step into",
		},
		["ds"] = {
			function()
				dap.step_over()
			end,
			"DAP: Step over",
		},
		["dr"] = {
			function()
				dap.repl.open()
			end,
			"DAP: Open repl",
		},
	},
}

-- Telescope and LSP keymappings
wk.register {
	["gr"] = {
		function()
			tb.lsp_references()
		end,
		"LSP: References",
	},
	["gs"] = {
		function()
			tb.lsp_dynamic_workspace_symbols()
		end,
		"LSP: Symbols",
	},
	["gh"] = {
		function()
			vim.lsp.buf.hover()
		end,
		"LSP: Hover",
	},
	["<leader>c"] = {
		function()
			vim.lsp.buf.code_action()
		end,
		"LSP: Code Actions",
	},
	["<c-.>"] = {
		function()
			vim.lsp.buf.code_action()
		end,
		"LSP: Code Actions",
	},
	["z="] = {
		function()
			tb.spell_suggest()
		end,
		"Spelling suggestions",
	},
	["<c-p>"] = {
		function()
			tb.find_files { hidden = true }
		end,
		"Find files",
	},
	R = {
		function()
			require("dk.lsp").rename()
		end,
		"Rename symbol",
	},
	["<m-p>"] = {
		function()
			tb.builtin()
		end,
		"Telescope",
	},
	["<leader>b"] = {
		name = "Buffer",
		b = {
			function()
				tb.buffers()
			end,
			"Buffers",
		},
		n = {
			"<cmd>bnext<cr>",
			"Next buffer",
		},
		p = {
			"<cmd>bprevious<cr>",
			"Previous buffer",
		},
	},
	["<leader>f"] = {
		name = "Find",
		c = {
			function()
				tb.find_files { cwd = vim.fn.stdpath "config", hidden = true }
			end,
			"config files",
		},
		f = {
			function()
				tb.find_files { hidden = true }
			end,
			"files",
		},
		l = {
			function()
				tb.live_grep()
			end,
			"lines (grep)",
		},
		r = {
			function()
				tb.oldfiles()
			end,
			"recent files",
		},
		h = {
			function()
				tb.help_tags()
			end,
			"help",
		},
		p = {
			function()
				ts.extensions.project.project {}
			end,
			"project",
		},
	},
	["<leader>p"] = {
		name = "Plugins",
		p = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerSync]]
			end,
			"Update",
		},
		s = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerStatus]]
			end,
			"Status",
		},
		i = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerCompile]]
				vim.cmd [[PackerInstall]]
			end,
			"Install",
		},
		c = {
			function()
				require "dk.plugins"
				vim.cmd [[PackerCompile]]
				vim.cmd [[PackerClean]]
			end,
			"Clean",
		},
	},
}

-- NOTE: Remember to config the terminal to interpret the keybindings correctly.
-- Example for Alacritty:
-- key_bindings:
--   - {key: F5, mods: Control|Shift, chars: "\x1b[15;6;5~"}
--   - {key: F5, mods: Control, chars: "\x1b[>15;5~"}
--   - {key: F5, mods: Shift, chars: "\x1b[15;4~"}
--   - {key: F5, mods: Alt, chars: "\x1b[15;6~"}
--   - {key: B, mods: Control|Shift, chars: "\x1b[66;5u"}
--   - {key: Plus, mods: Control|Shift, chars: "\x1b[43;5u"}
--   - {key: Equals, mods: Control, chars: "\x1b[61;5u"}
--   - {key: Period, mods: Control, chars: "\x1b[46;5u"}
