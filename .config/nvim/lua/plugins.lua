local vim = vim

-- Setup packer {{{1

-- Install packer if not already installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Load the packer pack
vim.cmd [[packadd packer.nvim]]

-- Compile pluins on change
vim.cmd [[
	augroup Packer
		autocmd!
		autocmd BufWritePost plugins.lua PackerCompile
		autocmd BufWritePost plugins.lua PackerInstall
	augroup end
]]

-- Define plugins {{{1

local packer = require("packer")

packer.startup(function(use)
	-- Let packer manage itself
	use { "wbthomason/packer.nvim", opt = true }

	-- Auto do stuff thingies
	use "sbdchd/neoformat"
	use "editorconfig/editorconfig-vim"

	-- Git
	use "f-person/git-blame.nvim"
	use "lewis6991/gitsigns.nvim"

	-- This isn't default?
	use "tpope/vim-surround"
	use "tpope/vim-commentary"
	use "tpope/vim-endwise"
	use "tpope/vim-repeat"
	use "kana/vim-operator-user"
	use "airblade/vim-rooter"
	use "windwp/nvim-autopairs"

	-- Motion(s)
	use "wellle/targets.vim"
	use "karb94/neoscroll.nvim"
	use "christoomey/vim-tmux-navigator"

	-- Language support
	use {
		"sheerun/vim-polyglot",
		opt = true, -- Explicitly loaded later
	}
	use "elzr/vim-json" -- Bundeled version is broken
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
	use "hrsh7th/nvim-compe"
	use "kosayoda/nvim-lightbulb"
	use "simrat39/rust-tools.nvim"
	use {
		"onsails/lspkind-nvim",
		config = function ()
			require("lspkind").init {}
		end
	}

	-- Treesitter
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/nvim-treesitter-refactor"
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	-- NOTE: This is buggy for some reason
	-- use "romgrk/nvim-treesitter-context"

	-- Themes
	use "ryanoasis/vim-devicons"
	use {
		"glepnir/galaxyline.nvim",
		branch = "main",
		config = function() require("statusline") end,
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
	use "mhinz/vim-startify"
	use {
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	}
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim"
		},
	}
	use {
		"wfxr/minimap.vim",
		run = "cargo install code-minimap",
	}
	use {
		"norcalli/nvim-colorizer.lua",
		opt = true,
		ft = { "css", "html" },
		config = function()
			require("colorizer").setup { "css", "html" }
		end,
	}
end)

-- vi: foldmethod=marker
