local gl = require "galaxyline"
local condition = require "galaxyline.condition"

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

gl.short_line_list = { "NvimTree", "packer" }

gl.section.short_line_left = {
	{
		Sep = {
			provider = function()
				return string.rep("━", vim.o.columns)
			end,
		},
	},
}

gl.section.left = {
	{
		Padding = {
			provider = function()
				return " "
			end,
			highlight = { colors.red, colors.bg, "bold" },
		},
	},
	{
		ViMode = {
			provider = function()
				-- Auto change color according the vim mode
				local mode_color = {
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
				}
				vim.cmd("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()])

				return "  "
			end,
			highlight = { colors.red, colors.bg, "bold" },
		},
	},
	{
		DiagnosticError = {
			provider = "DiagnosticError",
			icon = "  ",
			highlight = { colors.red, colors.bg },
		},
	},
	{
		DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = "  ",
			highlight = { colors.yellow, colors.bg },
		},
	},
	{
		DiagnosticHint = {
			provider = "DiagnosticHint",
			icon = "  ",
			highlight = { colors.cyan, colors.bg },
		},
	},
	{
		DiagnosticInfo = {
			provider = "DiagnosticInfo",
			icon = "  ",
			highlight = { colors.blue, colors.bg },
		},
	},
}

gl.section.mid = {
	{
		FileIcon = {
			provider = "FileIcon",
			condition = condition.buffer_not_empty,
			highlight = { require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg },
		},
	},
	{
		FileName = {
			provider = "FileName",
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.bg, "bold" },
		},
	},
}

gl.section.right = {
	{
		DiffAdd = {
			provider = "DiffAdd",
			condition = condition.hide_in_width,
			icon = "  ",
			highlight = { colors.green, colors.bg },
		},
	},
	{
		DiffModified = {
			provider = "DiffModified",
			condition = condition.hide_in_width,
			icon = " 柳",
			highlight = { colors.orange, colors.bg },
		},
	},
	{
		DiffRemove = {
			provider = "DiffRemove",
			condition = condition.hide_in_width,
			icon = "  ",
			highlight = { colors.red, colors.bg },
		},
	},
	{
		GitIcon = {
			provider = function()
				return "  "
			end,
			condition = condition.check_git_workspace,
			highlight = { colors.white, colors.bg, "bold" },
		},
	},
	{
		GitBranch = {
			provider = "GitBranch",
			condition = condition.check_git_workspace,
			highlight = { colors.white, colors.bg, "bold" },
		},
	},
	{
		Padding = {
			provider = function()
				return " "
			end,
			highlight = { colors.red, colors.bg, "bold" },
		},
	},
}
