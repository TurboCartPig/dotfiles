local devicons = require "nvim-web-devicons"
local dap = require "dap"
local ts = require "nvim-treesitter"

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

-- Make a statusline component
local function make_component(group, status, ...)
	return string.format("%s%s#%s%s", "%#", group, string.format(status, ...), "%*")
end

-- Get the current vim mode
M.mode = function(self)
	if self.flags.mode then
		self.flags.mode = false

		-- Update the highlight group with the color associated with this mode
		local m = vim.api.nvim_get_mode().mode
		vim.api.nvim_set_hl(0, hi_groups.mode, { fg = mode_colors[m], bg = "#504945" })

		self.cache.mode = table.concat {
			make_component("GruvboxBg2", " "),
			make_component(hi_groups.mode, ""),
			make_component("GruvboxBg2", " "),
		}
	end

	return self.cache.mode
end

-- Get the name of the file attached to this buffer
M.filename = function()
	return make_component(hi_groups.filename, "%s", "%t")
end

-- Get an icon representing the filetype
M.filetype = function(self)
	if self.flags.filetype then
		self.flags.filetype = false -- Unflag

		local filename = vim.fn.expand "%:t"
		local fileext = vim.fn.expand "%:e"
		local icon, group = devicons.get_icon(filename, fileext, { default = true })

		self.cache.filetype = make_component(group, icon)
	end

	return self.cache.filetype -- Return cached value
end

-- Get change counts from git
M.git = function(self)
	if self.flags.git then
		self.flags.git = false

		local signs = vim.tbl_extend(
			"keep",
			vim.b.gitsigns_status_dict or {},
			{ head = "", added = 0, changed = 0, removed = 0 }
		)

		self.cache.git = table.concat {
			signs.added > 0 and make_component(hi_groups.add, "  %s", signs.added) or "",
			signs.changed > 0 and make_component(hi_groups.change, " 柳%s", signs.changed) or "",
			signs.removed > 0 and make_component(hi_groups.remove, "  %s", signs.removed) or "",
			make_component(hi_groups.filename, "  %s", (signs.head ~= "" and signs.head or "DETACHED")),
		}
	end

	return self.cache.git
end

-- Get LSP diagnostic counts
M.lsp = function(self)
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

-- Get LSP progress
M.lsp_progress = function(self)
	if self.flags.lsp_progress then
		local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		local ms = vim.loop.hrtime() / 1000000
		local frame = (math.floor(ms / 240) % #spinners) + 1

		local msgs = vim.lsp.util.get_progress_messages()

		for _, msg in pairs(msgs) do
			if msg.percentage or 0 < 100 then
				return make_component(
					hi_groups.filename,
					"%s %s: %d%%%% ",
					spinners[frame],
					msg.title or "LSP",
					msg.percentage or 0
				)
			end
		end

		self.flags.lsp_progress = false
	end

	return ""
end

-- Get DAP status
M.dap = function()
	local status = dap.status()
	return status ~= "" and make_component(hi_groups.filename, "DAP: %s", status) or ""
end

-- Assemble the statusline
M.statusline = function(self)
	local ignore = false
	if vim.bo.filetype == "toggleterm" then
		ignore = true
	end
--- Treesitter statusline component displays treesitter node,
--- or what function/class we are inside of.
--- @return string
function M:treesitter()
	local status = ts.statusline { indicator_size = 40 } or ""
	return make_component(hi_groups.filename, "%s ", status)
end

	return table.concat {
		self:mode(),
		not ignore and self.filename() or "",
		not ignore and " " or "",
		not ignore and self:filetype() or "",
		" ",
		self:lsp_progress(),
		self:lsp(),
		self.dap(),
		"%=",
		-- self.treesitter(),
		self:git(),
		" ",
	}
end

-- Cache of previously evaluated statusline components
-- Some statusline components are memoized for performance
M.cache = {}

-- Flags indicating if a statusline component needs to be updated
M.flags = {
	mode = true,
	filename = true,
	filetype = true,
	git = true,
	lsp = false,
	lsp_progress = false,
	dap = false,
	treesitter = true,
}

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

return M
