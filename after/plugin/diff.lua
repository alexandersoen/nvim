local mini_diff = require("mini.diff")

mini_diff.setup({
	delay = {
		-- Recompute after a typing pause instead of competing with LaTeX LSPs
		-- and Tree-sitter on nearly every edit of a large tracked document.
		text_change = 750,
	},
	view = {
		style = "number",
	},
	mappings = {
		apply = "",
		reset = "",
	},
})

vim.keymap.set("n", "<leader>gd", mini_diff.toggle_overlay, { desc = "(Toggle) git diffs" })
vim.keymap.set("n", "<leader>gH", function()
	mini_diff.do_hunks(0, "reset")
end, { desc = "Undo git hunk" })
