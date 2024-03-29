local M = {} -- Module

-- Setup trouble -------------------------------------------------------------------- {{{1

function M.trouble()
	local trouble = require "trouble"
	local wk = require "which-key"

	trouble.setup {}

	wk.register {
		["<leader>tt"] = {
			"<cmd>TroubleToggle<cr>",
			"Toggle Trouble",
		},
	}
end

-- Setup todo-comments -------------------------------------------------------------- {{{1

function M.todo()
	local todo = require "todo-comments"

	todo.setup {
		signs = false,
		highlight = {
			comments_only = true,
		},
	}
end

-- Setup which-key ------------------------------------------------------------------ {{{1

function M.which_key()
	local wk = require "which-key"

	wk.setup {
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜ ", -- symbol used between a key and it's label
			group = "@", -- symbol prepended to a group
		},
		window = {
			border = "none", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		},
		layout = {
			height = { min = 4, max = 30 }, -- min and max height of the columns
			width = { min = 25, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "center", -- align columns left, center or right
		},
	}
end

-- orgmode settings--- -------------------------------------------------------------- {{{1

function M.orgmode()
	local orgmode = require "orgmode"

	orgmode.setup {
		org_agenda_files = { "~/Dropbox/org/*" },
		org_default_notes_file = "~/Dropbox/org/notes.org",
		org_indent_mode = "noindent",
	}
end

-- Bufferline settings -------------------------------------------------------------- {{{1

function M.bufferline()
	local bufferline = require "bufferline"

	bufferline.setup {
		options = {
			diagnostics = "nvim_lsp",
			sort_by = "directory",
		},
	}
end

-- Diffview.nvim settings ----------------------------------------------------------- {{{1

function M.diffview()
	local diffview = require "diffview"

	diffview.setup {
		use_icons = true,
	}
end

-- nvim-cmp config ---------------------------------------------------------------- {{{1

function M.cmp()
	local cmp = require "cmp"
	local lspkind = require "lspkind"
	local luasnip = require "luasnip"

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
	end

	cmp.setup {
		formatting = {
			format = lspkind.cmp_format(),
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = {
			["<c-n>"] = cmp.mapping.select_next_item(),
			["<c-p>"] = cmp.mapping.select_prev_item(),
			["<c-e>"] = cmp.mapping.close(),
			["<c-y>"] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			["<cr>"] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			["<tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<s-tab>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { "i", "s" }),
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "orgmode" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "spell" },
		},
	}

	-- FIXME: cmdline is broken somehow

	-- Setup cmp in cmdline
	-- cmp.setup.cmdline(":", {
	-- 	sources = {
	-- 		{ name = "cmdline" },
	-- 	},
	-- })

	-- Setup cmp in search
	-- cmp.setup.cmdline("/", {
	-- 	sources = {
	-- 		{ name = "buffer" },
	-- 	},
	-- })
end

-- Setup lsp_signature -------------------------------------------------------------- {{{1

function M.lsp_signature()
	local lsp_signature = require "lsp_signature"

	lsp_signature.setup {
		floating_window = false,
		hint_enable = true,
		hint_prefix = "",
	}
end

-- Setup gitsigns ------------------------------------------------------------------- {{{1

function M.gitsigns()
	local gitsigns = require "gitsigns"

	gitsigns.setup {
		signs = {
			add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		diff_opts = {
			internal = vim.fn.has "win32" ~= 1,
		},
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 100,
		},
		current_line_blame_formatter = function(name, blame_info, opts)
			if blame_info.author == name then
				blame_info.author = "You"
			end

			local text
			if blame_info.author == "Not Committed Yet" then
				text = blame_info.author
			else
				local date_time

				if opts.relative_time then
					date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
				else
					date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
				end

				text = string.format("%s • %s • %s", blame_info.author, date_time, blame_info.summary)
			end

			return { { " " .. text, "GitSignsCurrentLineBlame" } }
		end,
	}
end

-- Setup neoscroll ------------------------------------------------------------------ {{{1

function M.neoscroll()
	local neoscroll = require "neoscroll"

	neoscroll.setup {
		mappings = {
			"zt",
			"zz",
			"zb",
			"<C-u>",
			"<C-f>",
			"<C-e>",
			"<C-y>",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	}
end

-- Setup colorizer ------------------------------------------------------------------ {{{1

function M.colorizer()
	local colorizer = require "colorizer"

	colorizer.setup {
		"css",
		"html",
		"lua",
		"vim",
	}
end

-- Setup nvim-autopairs ------------------------------------------------------------- {{{1

function M.autopairs()
	local autopairs = require "nvim-autopairs"

	autopairs.setup {
		disable_filetype = { "TelescopePrompt", "lisp", "lisp_vlime", "clojure", "fennel" },
		check_ts = true,
	}
end

-- Setup spellsitter.nvim ----------------------------------------------------------- {{{1

function M.spellsitter()
	local spellsitter = require "spellsitter"

	spellsitter.setup {
		enable = true,
		hl = "SpellBad",
		spellchecker = "vimfn",
	}
end

-- Setup toggle-term ---------------------------------------------------------------- {{{1

function M.toggleterm()
	local toggleterm = require "toggleterm"
	local wk = require "which-key"

	local function set_keymappings(terminal)
		-- Only bind these for normal shell terminals, not lazygit for example.
		if terminal.cmd ~= nil then
			return
		end

		-- Make it easier to escape the terminal buffer
		vim.keymap.set("t", "<c-t>", [[<cmd>ToggleTerm<cr>]], { buffer = true })
		vim.keymap.set("t", "<esc>", [[<c-\><c-n>]], { buffer = true })
		vim.keymap.set("t", "<c-w>h", [[<c-\><c-n><c-w>h]], { buffer = true })
		vim.keymap.set("t", "<c-w>j", [[<c-\><c-n><c-w>j]], { buffer = true })
		vim.keymap.set("t", "<c-w>k", [[<c-\><c-n><c-w>k]], { buffer = true })
		vim.keymap.set("t", "<c-w>l", [[<c-\><c-n><c-w>l]], { buffer = true })
		vim.keymap.set("t", "<c-w><c-w>", [[<c-\><c-n><c-w><c-w>]], { buffer = true })
	end

	toggleterm.setup {
		shade_terminals = false,
		on_open = set_keymappings,
	}

	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new { cmd = "lazygit", hidden = true, direction = "float" }

	wk.register {
		["<leader>t"] = {
			name = "ToggleTerm",
			f = {
				"<cmd>ToggleTerm direction=float<cr>",
				"Toggle floating terminal",
			},
			s = {
				"<cmd>ToggleTerm direction=horizontal<cr>",
				"Toggle split terminal",
			},
			g = {
				function()
					lazygit:toggle()
				end,
				"Toggle lazygit terminal",
			},
		},
		["<c-t>"] = {
			"<cmd>ToggleTerm direction=horizontal<cr>",
			"Toggle split terminal",
		},
	}
end

-- Setup null-ls -------------------------------------------------------------------- {{{1

function M.null()
	local null = require "null-ls"
	local fmt = null.builtins.formatting
	local diag = null.builtins.diagnostics
	local ca = null.builtins.code_actions

	null.setup {
		sources = {
			-- Formatters
			fmt.stylua,
			fmt.black,
			fmt.isort,
			fmt.prettierd,
			fmt.goimports,
			fmt.latexindent,
			-- fmt.prettier,
			-- fmt.stylelint,
			-- fmt.statix,

			-- Diagnostics
			diag.gitlint,
			diag.pylint,
			diag.pydocstyle,
			diag.shellcheck,
			diag.markdownlint,
			diag.hadolint,
			diag.golangci_lint,
			diag.actionlint,
			-- diag.statix,
			-- diag.stylelint,
			-- diag.selene,

			-- Code Actions
			ca.shellcheck,
			-- ca.gitsigns,
		},
		on_attach = require("dk.lsp").on_attach,
	}
end

-- Setup marks.nvim ----------------------------------------------------------------- {{{1

function M.marks()
	local marks = require "marks"

	marks.setup {
		default_mappings = true,
		refresh_interval = 500,
	}
end

-- Setup dressing.nvim ------------------------------------------------------------- {{{1

function M.dressing()
	local dressing = require "dressing"

	dressing.setup()
end

-- Return the module
return M
