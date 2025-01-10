-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Import your plugins
		{ import = "dk.plugins" },

		{ "tpope/vim-surround",             lazy = false },
		{ "tpope/vim-commentary",           lazy = false },
		{ "tpope/vim-repeat",               lazy = false },
		{ "airblade/vim-rooter",            lazy = false },
		{ "wellle/targets.vim",             lazy = false },
		{ "christoomey/vim-tmux-navigator", lazy = false },

		{ "ryanoasis/vim-devicons",         lazy = false },
		{ "kyazdani42/nvim-web-devicons",   lazy = false },
		{ "akinsho/org-bullets.nvim" },
		{ "lukas-reineke/headlines.nvim" },
		{ "akinsho/nvim-bufferline.lua",    lazy = false },
		{ "ellisonleao/gruvbox.nvim",       lazy = false, config = true },
		{ "stevearc/dressing.nvim",         config = true },
		{
			"chentoast/marks.nvim",
			opts = {
				default_mappings = true,
				refresh_interval = 500,
			}
		},
		{
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require "notify"
			end,
		},

		{
			"eraserhd/parinfer-rust",
			ft = { "lisp", "clojure", "fennel" },
			build = "cargo build --release",
			enabled = false,
		},
		{
			"kristijanhusak/orgmode.nvim",
			enabled = false,
		},
		{
			"fatih/vim-go",
			ft = { "go", "gomod", "gosum", "godoc" },
			enabled = false,
		},
		{
			"rust-lang/rust.vim",
			cmd = { "Cargo" },
			ft = { "rust" },
			enabled = false,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- Colorscheme that will be used when installing plugins.
	install = { colorscheme = { "gruvbox" } },
	-- Automatically check for plugin updates
	checker = { enabled = false },
})
