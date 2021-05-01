local vim = vim

-- Install packer if not already installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Load the packer pack
vim.cmd [[packadd packer.nvim]]

local packer = require("packer")

packer.startup(function(use)
	-- Let packer manage itself
	use "wbthomason/packer.nvim"

	-- Dependecies and utility libraries
	use "nvim-lua/popup.nvim"
	use "nvim-lua/plenary.nvim"

	-- Auto do stuff thingies
	use "sbdchd/neoformat"
	use "editorconfig/editorconfig-vim"

	-- Git
	use "f-person/git-blame.nvim"
	use "lewis6991/gitsigns.nvim"

	-- This isn't default?
	use "tpope/vim-sensible"
	use "tpope/vim-fugitive"
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
	use "sheerun/vim-polyglot"
	use { "fatih/vim-go", opt = true, ft = { "go", "gomod", "gosum", "godoc" } }
	use { "rust-lang/rust.vim", opt = true, ft = { "rust" } }

	-- LSP and autocompletions
	use "neovim/nvim-lspconfig"
	use "hrsh7th/nvim-compe"
	use "nvim-lua/lsp_extensions.nvim"
	use "nvim-lua/lsp-status.nvim"
	use "kosayoda/nvim-lightbulb"

	-- Treesitter
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/nvim-treesitter-refactor"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	-- NOTE: This is buggy for some reason
	-- use "romgrk/nvim-treesitter-context"

	-- Themes
	use "vim-airline/vim-airline"
	use "vim-airline/vim-airline-themes"
	use "ryanoasis/vim-devicons"
	use "kyazdani42/nvim-web-devicons"
	use "rktjmp/lush.nvim"
	use "npxbr/gruvbox.nvim"

	-- Interfaces
	use "mhinz/vim-startify"
	use "kyazdani42/nvim-tree.lua"
	use "nvim-telescope/telescope.nvim"
	use { "wfxr/minimap.vim", run = "!cargo install code-minimap" }
	use {
		"norcalli/nvim-colorizer.lua",
		opt = true,
		ft = { "css", "html" },
		config = function ()
			require("colorizer").setup { "css", "html" }
		end
	}
end)
