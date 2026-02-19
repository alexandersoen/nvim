local mini_diff = require("mini.diff")

mini_diff.setup({
  view = {
    style = "number",
  },
  mappings = {
    apply = '',
    reset = '',
  }
})

vim.keymap.set("n", "<leader>gd", mini_diff.toggle_overlay, { desc = "(Toggle) git diffs" })
vim.keymap.set("n", "<leader>gH", function()
  mini_diff.do_hunks(0, "reset")
end, { desc = "Undo git hunk" })
