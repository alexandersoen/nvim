local lazysnippets = {
	"luasnip.loaders.from_vscode",
	"luasnip.loaders.from_snipmate",
	"luasnip.loaders.from_lua",
	"luasnip.loaders",
}

vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		for _, mod in ipairs(lazysnippets) do
			pcall(require, mod)
		end
	end,
})
