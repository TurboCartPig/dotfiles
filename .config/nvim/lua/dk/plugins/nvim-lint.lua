return {
	"mfussenegger/nvim-lint",
	ft = { "lua", "sh", "bash" },
	opts = {
		lua = { "selene" },
		sh = { "shellcheck" },
		bash = { "shellcheck" },
	},
	config = function(_, opts)
		local lint = require "lint"

		lint.linters_by_ft = opts

		local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost" }, {
			group = group,
			callback = function()
				vim.schedule(function()
					lint.try_lint()
				end)
			end,
		})
	end,
}
