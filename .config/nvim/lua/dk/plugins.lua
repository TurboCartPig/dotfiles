-- Setup packer {{{1

-- Install packer if not already installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

-- Load the packer pack
vim.cmd [[packadd packer.nvim]]

-- Compile plugins on change
vim.cmd [[
 	augroup Packer
 		autocmd!
		autocmd BufWritePost plugins.lua luafile <afile>
 		autocmd BufWritePost plugins.lua PackerCompile
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
	use "windwp/nvim-autopairs"
	use "lewis6991/gitsigns.nvim"

	-- This isn't default?
	use "tpope/vim-surround"
	use "tpope/vim-commentary"
	use "tpope/vim-repeat"
	use "tpope/vim-sleuth"
	use "airblade/vim-rooter"

	-- Motion(s)
	use "wellle/targets.vim"
	use "karb94/neoscroll.nvim"
	use "christoomey/vim-tmux-navigator"

	-- Language support
	use "tpope/vim-git"
	use "kristijanhusak/orgmode.nvim"
	use {
		"tikhomirov/vim-glsl",
		ft = { "glsl" },
	}
	use {
		"plasticboy/vim-markdown",
		ft = { "markdown" },
	}
	use {
		"elzr/vim-json",
		ft = { "json" },
	}
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
	use "simrat39/rust-tools.nvim"
	use "jose-elias-alvarez/null-ls.nvim"
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

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require "dk.plugins.treesitter"
		end,
	}
	use "nvim-treesitter/nvim-treesitter-refactor"
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "windwp/nvim-ts-autotag"
	-- FIXME: Broken on windows due to upstream bug neovim/neovim#15063
	-- use "romgrk/nvim-treesitter-context"

	-- Dap (Debugging)
	-- use "mfussenegger/nvim-dap"
	-- use "theHamsta/nvim-dap-virtual-text"

	-- Themes
	use "ryanoasis/vim-devicons"
	use {
		"glepnir/galaxyline.nvim",
		branch = "main",
		config = function()
			require "dk.plugins.galaxyline"
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
	use {
		"akinsho/org-bullets.nvim",
		config = function()
			require("org-bullets").setup {}
		end,
	}

	-- Interfaces
	use "sindrets/diffview.nvim"
	use "norcalli/nvim-colorizer.lua"
	use "folke/trouble.nvim"
	use "folke/which-key.nvim"
	use "folke/todo-comments.nvim"
	use "nvim-telescope/telescope-fzf-native.nvim"
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require "dk.plugins.telescope"
		end,
	}
end)

-- vi: foldmethod=marker
