local function setup_telescope()
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			wrap_results = false,
			sorting_strategy = "ascending",
		},
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "TelescopePreviewerLoaded",
		callback = function()
			vim.wo.wrap = true
		end,
	})
end

vim.keymap.set("n", "<leader>ff", function()
	setup_telescope()
	vim.cmd("Telescope find_files")
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fg", function()
	setup_telescope()
	vim.cmd("Telescope live_grep")
end, { desc = "Live Grep" })

vim.keymap.set("n", "<leader>fs", function()
	setup_telescope()
	vim.cmd("Telescope spell_suggest")
end, { desc = "Spelling Suggestions" })
