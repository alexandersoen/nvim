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

vim.keymap.set("n", "<leader>gd", function()
  mini_diff.toggle_overlay()
end, { desc = "(Toggle) git diffs" })
