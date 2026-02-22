local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		tex = { "tex-fmt" },
		python = { "ruff_organize_imports", "ruff_format" },
	},
})

conform.formatters["tex-fmt"] = {
	prepend_args = { "--nowrap" },
}

vim.keymap.set("n", "gq", function()
	print("Formatting")
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format" })
