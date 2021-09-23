-- Setup packer {{{1

-- Install packer if not already installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

-- Load the packer pack
vim.cmd [[packadd packer.nvim]]

-- Compile pluins on change
vim.cmd [[
 	augroup Packer
 		autocmd!
		autocmd BufWritePost plugins.lua luafile <afile>
 		autocmd BufWritePost plugins.lua PackerCompile
 		autocmd BufWritePost plugins.lua PackerInstall
 	augroup end
 ]]

-- Define plugins {{{1

local packer = require "packer"

packer.startup(function(use)
	-- Let packer manage itself
	use { "wbthomason/packer.nvim", opt = true }

	-- Misc
	use "sbdchd/neoformat"
	use "editorconfig/editorconfig-vim"
	use "kristijanhusak/orgmode.nvim"

	-- Git
	use "lewis6991/gitsigns.nvim"

	-- This isn't default?
	use "tpope/vim-surround"
	use "tpope/vim-commentary"
	use "tpope/vim-endwise"
	use "tpope/vim-repeat"
	use "tpope/vim-sleuth"
	use "kana/vim-operator-user"
	use "airblade/vim-rooter"
	use "windwp/nvim-autopairs"

	-- Motion(s)
	use "wellle/targets.vim"
	use "karb94/neoscroll.nvim"
	use "christoomey/vim-tmux-navigator"

	-- Language support
	use { "tpope/vim-git" }
	use { "tikhomirov/vim-glsl", ft = { "glsl" } }
	use { "plasticboy/vim-markdown", ft = { "markdown" } }
	use { "elzr/vim-json", ft = { "json" } }
	use {
		"fatih/vim-go",
		ft = { "go", "gomod", "gosum", "godoc" },
	}
	use {
		"rust-lang/rust.vim",
		cmd = { "Cargo" },
		ft = { "rust" },
	}

	-- LSP and autocompletions
	use "neovim/nvim-lspconfig"
	use "onsails/lspkind-nvim"
	use "kosayoda/nvim-lightbulb"
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"f3fora/cmp-spell",
			"hrsh7th/vim-vsnip",
		},
	}
	use "simrat39/rust-tools.nvim"
	use "jose-elias-alvarez/null-ls.nvim"

	-- Treesitter
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/nvim-treesitter-refactor"
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "windwp/nvim-ts-autotag"
	-- NOTE: This is buggy for some reason
	-- use "romgrk/nvim-treesitter-context"

	-- Dap (Debugging)
	use "mfussenegger/nvim-dap"
	use "theHamsta/nvim-dap-virtual-text"

	-- Themes
	use "ryanoasis/vim-devicons"
	use {
		"glepnir/galaxyline.nvim",
		branch = "main",
		config = function()
			require "statusline"
		end,
		requires = "kyazdani42/nvim-web-devicons",
	}
	use {
		"akinsho/nvim-bufferline.lua",
		requires = "kyazdani42/nvim-web-devicons",
	}
	use {
		"npxbr/gruvbox.nvim",
		requires = "rktjmp/lush.nvim",
	}

	-- Interfaces
	use "glepnir/dashboard-nvim"
	use "sindrets/diffview.nvim"
	use "norcalli/nvim-colorizer.lua"
	use {
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	}
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
	}
	use {
		"nvim-telescope/telescope-fzf-native.nvim",
		-- run = "make",
	}
	use {
		"folke/trouble.nvim",
		run = function()
			require("trouble").setup {}
		end,
	}
	use {
		"folke/which-key.nvim",
	}
end)

-- vi: foldmethod=marker
