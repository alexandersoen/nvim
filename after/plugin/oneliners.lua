require("markdown-plus").setup()
require("nvim-highlight-colors").setup({
	-- Color literals are useful in code, but scanning large prose buffers on
	-- every change adds work without contributing LaTeX editing features.
	exclude_filetypes = { "tex", "plaintex", "bib" },
})
