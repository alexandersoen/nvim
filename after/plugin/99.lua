local _99 = require("99")

_99.setup({
  show_in_flight_requests = true,
  md_files = {
    "AGENTS.md",
  },
  model = "opencode/glm-5-free"
})

vim.keymap.set("n", "<leader>9s", _99.search)
vim.keymap.set("v", "<leader>9v", _99.visual)
-- vim.keymap.set("v", "<leader>9vp", _99.visual_prompt)
vim.keymap.set("n", "<leader>9x", _99.stop_all_requests)
vim.keymap.set("n", "<leader>9i", _99.info)
vim.keymap.set("n", "<leader>9l", _99.view_logs)
vim.keymap.set("n", "<leader>9n", _99.next_request_logs)
vim.keymap.set("n", "<leader>9p", _99.prev_request_logs)
