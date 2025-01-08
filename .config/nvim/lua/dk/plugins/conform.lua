return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
		},
		format_on_save = {
			timeout_ms = 800,
			lsp_format = "prefer",
		},
	},
	config = true,
}
