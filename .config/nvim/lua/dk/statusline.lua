local devicons = require "nvim-web-devicons"
local dap = require "dap"

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
M.mode = function()
	-- Update the highlight group with the color associated with this mode
	local m = vim.api.nvim_get_mode().mode
	vim.api.nvim_set_hl(0, hi_groups.mode, { fg = mode_colors[m] })

	return make_component(hi_groups.mode, "")
end

-- Get the name of the file attached to this buffer
M.filename = function()
	return make_component(hi_groups.filename, "%s", "%t")
end

-- Get an icon representing the filetype
M.filetype = function()
	local filename = vim.fn.expand "%:t"
	local fileext = vim.fn.expand "%:e"
	local icon, group = devicons.get_icon(filename, fileext, { default = true })

	return make_component(group, icon)
end

-- Get change counts from git
M.git = function()
	local signs = vim.tbl_extend(
		"keep",
		vim.b.gitsigns_status_dict or {},
		{ head = "", added = 0, changed = 0, removed = 0 }
	)

	return string.format(
		"%s%s%s%s",
		signs.added > 0 and make_component(hi_groups.add, "  %s", signs.added) or "",
		signs.changed > 0 and make_component(hi_groups.change, " 柳%s", signs.changed) or "",
		signs.removed > 0 and make_component(hi_groups.remove, "  %s", signs.removed) or "",
		make_component(hi_groups.filename, "  %s", (signs.head ~= "" and signs.head or "DETACHED"))
	)
end

-- Get LSP diagnostic counts
M.lsp = function()
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

	return string.format(
		"%s%s%s%s",
		diagnostics.errors > 0 and make_component(hi_groups.error, " %s ", diagnostics.errors) or "",
		diagnostics.warnings > 0 and make_component(hi_groups.warning, " %s ", diagnostics.warnings) or "",
		diagnostics.info > 0 and make_component(hi_groups.information, " %s ", diagnostics.info) or "",
		diagnostics.hints > 0 and make_component(hi_groups.hint, " %s ", diagnostics.hints) or ""
	)
end

-- local hello = " Hello "

-- Get LSP progress
M.lsp_progress = function()
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

	return ""
end

-- Get DAP status
M.dap = function()
	local status = dap.status()
	return status ~= "" and make_component(hi_groups.filename, "DAP: %s", status) or ""
end

-- Assemble the statusline
--
-- TODO: Fix centering of filename
-- I should calculate where the filename component should start and add paddingto
-- the components before that to fill out the distance, but no more.
M.statusline = function(self)
	return table.concat {
		" ",
		self.mode(),
		" ",
		self.lsp_progress(),
		self.lsp(),
		self.dap(),
		"%=",
		self.filetype(),
		" ",
		self.filename(),
		"%=",
		self.git(),
		" ",
	}
end

Statusline = setmetatable(M, {
	__call = function(statusline)
		return statusline:statusline()
	end,
})

vim.opt.statusline = "%!v:lua.Statusline()"

return M
