vim.filetype.add {
	extensions = {
		graphqlrc = "yaml",
		babelrc = "json",
		cppm = "cpp",
	},
	filename = {
		[".babelrc"] = "json",
		[".eslintrc"] = "json",
		[".prettierrc"] = "json",
		[".stylelintrc"] = "json",
		zprofile = "zsh",
	},
	pattern = {
		["*/.config/git/config"] = "gitconfig",
		["*/.config/git/ignore"] = "gitignore",
		[".env*"] = "sh",
		["Dockerfile*"] = "dockerfile",
	},
}
