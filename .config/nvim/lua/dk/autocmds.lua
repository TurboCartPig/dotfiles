-- Neovim autocmds

-- Automatically start in insert mode in terminals.
-- And turn off the number column in terminal buffers.
-- TODO: Remove in nvim 0.11
local Term = vim.api.nvim_create_augroup("Term", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "*",
	command = "setlocal nonumber | startinsert",
	group = Term,
})

-- Set language specific local options automatically.
local LanguageOverrides = vim.api.nvim_create_augroup("LanguageOverrides", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "haskell", "cabal", "yaml", "gleam", "elixir" },
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

-- Auto-create folder when saving file
local MkDir = vim.api.nvim_create_augroup("MkDir", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*",
	callback = function()
		local dir = vim.fn.expand "<afile>:p:h"
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
	group = MkDir,
})

-- Setup line diagnostic on hover
local Diag = vim.api.nvim_create_augroup("Diag", {})
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false, border = "rounded", scope = "cursor" })
	end,
	group = Diag,
})

-- Fix CursorHold and CursorHoldI by decoupling them from 'updatetime'
local cursorhold_updatetime = 200
local cursorhold_timer = nil

local function cursorhold(event)
	-- Stop previous timer
	if cursorhold_timer ~= nil then
		cursorhold_timer:stop()
	end

	-- Register defered callback that invokes autocmds
	cursorhold_timer = vim.defer_fn(function()
		-- Cancel if vim is exiting
		if vim.v.exiting ~= vim.NIL then
			return
		end

		vim.opt.eventignore:remove(event)
		vim.cmd("doautocmd <nomodeline> " .. event)
		vim.opt.eventignore:append(event)
	end, cursorhold_updatetime)
end

local function register_cursorhold()
	-- Ignore ordinary CursorHold and CursorHoldI events
	vim.opt.eventignore:append { "CursorHold", "CursorHoldI" }

	-- Regiser autocmds for starting timers
	local CursorHoldFix = vim.api.nvim_create_augroup("CursorHoldFix", {})
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		pattern = "*",
		callback = function()
			if vim.fn.mode() ~= "n" then
				return
			end
			cursorhold "CursorHold"
		end,
		group = CursorHoldFix,
	})
	vim.api.nvim_create_autocmd({ "CursorMovedI" }, {
		pattern = "*",
		callback = function()
			cursorhold "CursorHoldI"
		end,
		group = CursorHoldFix,
	})
end

register_cursorhold()
