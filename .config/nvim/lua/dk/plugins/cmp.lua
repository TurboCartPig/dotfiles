return {
	{
		"hrsh7th/nvim-cmp",
		version = false,
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require "cmp"
			local lspkind = require "lspkind"
			local luasnip = require "luasnip"

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
			end

			cmp.setup {
				formatting = {
					format = lspkind.cmp_format(),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<c-n>"] = cmp.mapping.select_next_item(),
					["<c-p>"] = cmp.mapping.select_prev_item(),
					["<c-e>"] = cmp.mapping.close(),
					["<c-y>"] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					["<cr>"] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					["<tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<s-tab>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "spell" },
				},
			}

			-- FIXME: cmdline is broken somehow

			-- Setup cmp in cmdline
			-- cmp.setup.cmdline(":", {
			-- 	sources = {
			-- 		{ name = "cmdline" },
			-- 	},
			-- })

			-- Setup cmp in search
			-- cmp.setup.cmdline("/", {
			-- 	sources = {
			-- 		{ name = "buffer" },
			-- 	},
			-- })
		end,
	},
}
