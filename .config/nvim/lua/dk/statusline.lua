local colors = {
	bg = "#292929",
	fg = "#fbf0c6",
	yellow = "#fabd2e",
	cyan = "#008080",
	darkblue = "#458588",
	green = "#b8ba26",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#83a598",
	red = "#fb4632",
}

-- Mode to mode color mappings
--- @type table<string, string>
local mode_colors = setmetatable({
	n = colors.red,
	i = colors.green,
	v = colors.blue,
	[""] = colors.blue,
	V = colors.blue,
	c = colors.magenta,
	no = colors.red,
	s = colors.orange,
	S = colors.orange,
	[""] = colors.orange,
	ic = colors.yellow,
	R = colors.violet,
	Rv = colors.violet,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	["r?"] = colors.cyan,
	["!"] = colors.red,
	t = colors.red,
}, {
	__index = function()
		return colors.fg
	end,
})

-- Component name to highlight group mapping
--- @type table<string, string>
local hi_groups = {
	mode = "Mode",
	filename = "Normal",
	add = "DiffAdd",
	change = "DiffChange",
	remove = "DiffDelete",
	error = "DiagnosticSignError",
	warning = "DiagnosticSignWarn",
	information = "DiagnosticSignInfo",
	hint = "DiagnosticSignHint",
}

local M = {}

--- Make a statusline component
--- @param group string Highlight group to use
--- @param status string String containing status, can contain formatting groups
--- @vararg string Optional params used for formatting
--- @return string #Statusline component
local function make_component(group, status, ...)
	return string.format("%s%s#%s%s", "%#", group, string.format(status, ...), "%*")
end

--- Mode statusline component displays vim mode
--- @return string
function M:mode()
	if self.flags.mode then
		self.flags.mode = false

		-- Update the highlight group with the color associated with this mode
		local m = vim.api.nvim_get_mode().mode
		vim.api.nvim_set_hl(0, hi_groups.mode, { fg = mode_colors[m], bg = "#504945" })

		self.cache.mode = table.concat {
			make_component("GruvboxBg2", ""),
			make_component(hi_groups.mode, ""),
			make_component("GruvboxBg2", ""),
		}
	end

	return self.cache.mode
end

--- Filename statusline component displays buffer filename
--- @return string
function M:filename()
	return make_component(hi_groups.filename, "%s", "%t")
end

--- Filetype statusline component displays buffer filetype
--- @return string
function M:filetype()
	if self.flags.filetype then
		self.flags.filetype = false -- Unflag

		local filename = vim.fn.expand "%:t"
		local fileext = vim.fn.expand "%:e"

		local has_devicons, devicons = pcall(require, "nvim-web-devicons")
		local icon, group =
			has_devicons and devicons.get_icon(filename, fileext, { default = true }) or "", "GruvboxBg2"

		self.cache.filetype = make_component(group, icon)
	end

	return self.cache.filetype -- Return cached value
end

--- File statusline component displays filename and filetype together
--- @return string
function M:file()
	if vim.bo.filetype == "toggleterm" then
		return ""
	end

	return table.concat {
		self:filename(),
		" ",
		self:filetype(),
	}
end

--- Git statusline component displays git change counts and cheched out branch.
--- Depends on gitsigns.
--- @return string
function M:git()
	if self.flags.git then
		self.flags.git = false

		local signs =
			vim.tbl_extend("keep", vim.b.gitsigns_status_dict or {}, { head = "", added = 0, changed = 0, removed = 0 })

		self.cache.git = table.concat {
			signs.added > 0 and make_component(hi_groups.add, "  %s", signs.added) or "",
			signs.changed > 0 and make_component(hi_groups.change, " 柳%s", signs.changed) or "",
			signs.removed > 0 and make_component(hi_groups.remove, "  %s", signs.removed) or "",
			make_component(hi_groups.filename, "  %s", (signs.head ~= "" and signs.head or "DETACHED")),
		}
	end

	return self.cache.git
end

--- LSP statusline component displays LSP diagnostic counts
--- @return string
function M:lsp()
	if self.flags.lsp then
		self.flags.lsp = false
		local diagnostics = {}
		local levels = {
			errors = vim.diagnostic.severity.ERROR,
			warnings = vim.diagnostic.severity.WARN,
			info = vim.diagnostic.severity.INFO,
			hints = vim.diagnostic.severity.HINT,
		}

		for k, level in pairs(levels) do
			diagnostics[k] = #vim.diagnostic.get(0, { severity = level })
		end

		self.cache.lsp = table.concat {
			diagnostics.errors > 0 and make_component(hi_groups.error, "%s  ", diagnostics.errors) or "",
			diagnostics.warnings > 0 and make_component(hi_groups.warning, "%s  ", diagnostics.warnings) or "",
			diagnostics.info > 0 and make_component(hi_groups.information, "%s  ", diagnostics.info) or "",
			diagnostics.hints > 0 and make_component(hi_groups.hint, "%s  ", diagnostics.hints) or "",
		}
	end

	return self.cache.lsp
end

--- LSP progress statusline component displays LSP progress messages
--- @return string
function M:lsp_progress()
	return vim.lsp.status()
end

--- Treesitter statusline component displays treesitter node,
--- or what function/class we are inside of.
--- @return string
function M:treesitter()
	local has_ts, ts = pcall(require, "nvim-treesitter")
	local status = has_ts and ts.statusline { indicator_size = 40 } or ""
	return make_component(hi_groups.filename, "%s ", status)
end

--- Assemble the statusline
--- @return string
function M:statusline()
	return table.concat {
		" ",
		self:mode(),
		" ",
		self:file(),
		" ",
		self:lsp_progress(),
		self:lsp(),
		"%=",
		self:treesitter(),
		self:git(),
		" ",
	}
end

-- Cache of previously evaluated statusline components
-- Some statusline components are memoized for performance
--- @type table<string, string>
M.cache = {}

-- Flags indicating if a statusline component needs to be updated
--- @type table<string, boolean>
M.flags = {
	mode = true,
	filename = true,
	filetype = true,
	git = true,
	lsp = true,
	lsp_progress = true,
	treesitter = true,
}

--- Setup the statusline
function M:setup()
	-- Setup autocmds for flagging that components need to be updated
	local g = vim.api.nvim_create_augroup("Statusline", {})
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "*",
		callback = function()
			M.flags.mode = true
		end,
		group = g,
	})
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
		pattern = "*",
		callback = function()
			M.flags.filename = true
		end,
		group = g,
	})
	vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
		pattern = "*",
		callback = function()
			M.flags.filetype = true
		end,
		group = g,
	})
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufNewFile", "BufEnter" }, {
		pattern = "*",
		callback = function()
			M.flags.git = true
		end,
		group = g,
	})
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		pattern = "*",
		callback = function()
			M.flags.lsp = true
		end,
		group = g,
	})
	vim.api.nvim_create_autocmd("User", {
		pattern = "LspProgressUpdate",
		callback = function()
			M.flags.lsp_progress = true
		end,
		group = g,
	})

	-- Globally available statusline function with state
	Statusline = setmetatable(M, {
		__call = function(statusline)
			return statusline:statusline()
		end,
	})

	-- Set the statusline globally
	vim.opt.statusline = "%!v:lua.Statusline()"
end

M:setup()

return M
