local loaded_99 = false

local function get_99()
	if not loaded_99 then
		loaded_99 = true
		local _99 = require("99")
		_99.setup({
			show_in_flight_requests = true,
			md_files = {
				"AGENTS.md",
			},
			completion = {
				custom_rules = {
					"scratch/custom_rules/",
				},
				source = "blink",
			},
			-- model = "opencode/minimax-m2.5-free",
      model = "openai/gpt-5.4",
		})
		return _99
	end
	return require("99")
end

vim.keymap.set("n", "<leader>9s", function()
	get_99().search()
end)
vim.keymap.set("v", "<leader>9v", function()
	get_99().visual()
end)
vim.keymap.set("n", "<leader>9x", function()
	get_99().stop_all_requests()
end)
vim.keymap.set("n", "<leader>9i", function()
	get_99().info()
end)
vim.keymap.set("n", "<leader>9l", function()
	get_99().view_logs()
end)
vim.keymap.set("n", "<leader>9n", function()
	get_99().next_request_logs()
end)
vim.keymap.set("n", "<leader>9p", function()
	get_99().prev_request_logs()
end)
