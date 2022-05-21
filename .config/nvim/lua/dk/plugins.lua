-- Setup packer {{{1

-- Install packer if not already installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

-- Load the packer pack
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]

-- Compile plugins on change
vim.cmd [[
	augroup Packer
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]]

-- Define plugins {{{1

return require("packer").startup(function(use)
	-- Let packer manage itself
	use { "wbthomason/packer.nvim", opt = true }

	use { "lewis6991/impatient.nvim" }

	-- Misc
	use "sbdchd/neoformat"
	use "editorconfig/editorconfig-vim"
	use {
		"windwp/nvim-autopairs",
		config = function()
			require("dk.plugins.misc").autopairs()
		end,
	}
	use {
		"eraserhd/parinfer-rust",
		ft = { "lisp", "clojure", "fennel" },
		run = "cargo build --release",
	}
	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("dk.plugins.misc").gitsigns()
		end,
	}

	-- This isn't default?
	use "tpope/vim-surround"
	use "tpope/vim-commentary"
	use "tpope/vim-repeat"
	-- use "tpope/vim-sleuth"
	use "airblade/vim-rooter"

	-- Motion(s)
	use "wellle/targets.vim"
	use {
		"karb94/neoscroll.nvim",
		config = function()
			require("dk.plugins.misc").neoscroll()
		end,
	}
	use "christoomey/vim-tmux-navigator"

	-- Language support
	use "tpope/vim-git"
	use {
		"kristijanhusak/orgmode.nvim",
		config = function()
			require("dk.plugins.misc").orgmode()
		end,
	}
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
	use {
		"vlime/vlime",
		ft = "lisp",
		rtp = "vim/",
	}

	-- LSP and autocompletions
	use "neovim/nvim-lspconfig"
	use "onsails/lspkind-nvim"
	use "kosayoda/nvim-lightbulb"
	use "b0o/schemastore.nvim"
	use "simrat39/rust-tools.nvim"
	use {
		"ray-x/lsp_signature.nvim",
		config = function()
			require("dk.plugins.misc").lsp_signature()
		end,
	}
	use {
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("dk.plugins.misc").null()
		end,
	}
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("dk.plugins.misc").cmp()
		end,
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
	use "nvim-treesitter/playground"
	use "p00f/nvim-ts-rainbow"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "windwp/nvim-ts-autotag"
	use "lewis6991/spellsitter.nvim"
	-- FIXME: Broken on windows due to upstream bug neovim/neovim#15063
	-- use "romgrk/nvim-treesitter-context"

	-- Dap (Debugging)
	use "mfussenegger/nvim-dap"
	use "theHamsta/nvim-dap-virtual-text"
	use {
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").test_runner = "pytest"
			require("dap-python").setup "/usr/bin/python"
		end,
	}
	use {
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	}

	-- Themes
	use "ryanoasis/vim-devicons"
	use {
		"NTBBloodbath/galaxyline.nvim",
		branch = "main",
		config = function()
			require "dk.plugins.galaxyline"
		end,
		requires = "kyazdani42/nvim-web-devicons",
	}
	use {
		"akinsho/nvim-bufferline.lua",
		branch = "main",
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
	use {
		"lukas-reineke/headlines.nvim",
	}

	-- Interfaces
	use {
		"chentoast/marks.nvim",
		config = function()
			require("dk.plugins.misc").marks()
		end,
	}
	use {
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require "notify"
		end,
	}
	use {
		"folke/which-key.nvim",
		config = function()
			require("dk.plugins.misc").which_key()
		end,
	}
	use {
		"folke/trouble.nvim",
		config = function()
			require("dk.plugins.misc").trouble()
		end,
	}
	use {
		"folke/todo-comments.nvim",
		config = function()
			require("dk.plugins.misc").todo()
		end,
	}
	use {
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("dk.plugins.misc").colorizer()
		end,
	}
	use { "junegunn/goyo.vim", cmd = "Goyo" }
	use {
		"akinsho/toggleterm.nvim",
		config = function()
			require("dk.plugins.misc").toggleterm()
		end,
	}
	use {
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewToggleFiles" },
		config = function()
			require("dk.plugins.misc").diffview()
		end,
	}
	use {
		"stevearc/dressing.nvim",
		config = function()
			require("dk.plugins.misc").dressing()
		end,
	}
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-project.nvim",
		},
		config = function()
			require "dk.plugins.telescope"
		end,
	}
end)

-- vi: foldmethod=marker
