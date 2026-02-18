local telescope = require("telescope")

telescope.setup({
  defaults = {
    wrap_results = false,
    sorting_strategy = "ascending"
  }
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.wrap = true
  end,
})

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>", { desc = "Spelling Suggestions" })
