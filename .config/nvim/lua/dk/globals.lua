-- Prevent loading of default plugins ----------------------------------------------- {{{1

-- NOTE: Could be useful for goto definition into archives
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

-- NOTE: I need to load these to download norwegian 'spell' dictionaries
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Use filetype.lua
vim.g.do_filetype_lua = 1

-- Termdebug settings --------------------------------------------------------------- {{{1
vim.g.termdebug_popup = 0
vim.g.termdebug_wide = 163

-- Various language settings -------------------------------------------------------- {{{1

-- Settings for pangloss/vim-javascript
-- vim.g.javascript_plugin_jsdoc = true
-- vim.g.javascript_plugin_ngdoc = false
-- vim.g.javascript_plugin_flow = false

-- Settings for elzr/vim-json
vim.g.vim_json_syntax_conceal = true

-- Settings for plasticboy/vim-markdown
vim.g.vim_markdown_toc_autofit = true
vim.g.vim_markdown_conceal_code_blocks = false
vim.g.vim_markdown_follow_anchor = true
vim.g.vim_markdown_strikethrough = true

-- Create alias for fenced languages with the format: alias=actual
vim.g.vim_markdown_fenced_languages = {
	"c++=cpp",
	"viml=vim",
	"bash=sh",
	"ini=dosini",
}

-- vim-rooter settings ------------------------------------------------------------- {{{1

vim.g.rooter_patterns = { "vim.toml", ".git", ".hg", ".bzr", ".svn", "Makefile", "package.json" }

-- Neoformat settings --------------------------------------------------------------- {{{1

vim.g.neoformat_basic_format_align = false
vim.g.neoformat_basic_format_retab = false
vim.g.neoformat_basic_format_trim = true
vim.g.neoformat_enabled_haskell = { "stylishhaskell", "ormolu" }
vim.g.neoformat_enabled_python = { "black" }
vim.g.neoformat_enabled_javascript = { "prettier" }
vim.g.neoformat_enabled_lua = { "stylua" }

-- Goyo settings -------------------------------------------------------------------- {{{1

vim.g.goyo_width = 100
vim.g.goyo_height = 80

-- Vlime settings ------------------------------------------------------------------- {{{1

vim.g.vlime_cl_use_terminal = true
vim.g.vlime_enable_autodoc = true
vim.g.vlime_window_settings = {
	sldb = {
		pos = "topright",
		size = 20,
		vertical = true,
	},
	repl = {
		pos = "topright",
		size = 20,
		vertical = true,
	},
	server = {
		pos = "botright",
		size = 5,
		vertical = true,
	},
}
