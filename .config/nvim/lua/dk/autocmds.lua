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
