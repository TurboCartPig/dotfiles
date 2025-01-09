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

-- Termdebug settings --------------------------------------------------------------- {{{1
vim.g.termdebug_popup = 0
vim.g.termdebug_wide = 163

-- vim-rooter settings ------------------------------------------------------------- {{{1

vim.g.rooter_patterns = { "vim.toml", ".git", ".hg", ".bzr", ".svn", "Makefile", "package.json" }
