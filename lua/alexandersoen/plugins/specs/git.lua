return {
  'nvim-mini/mini.diff',
  config = function()
    local mini_diff = require("mini.diff")

    mini_diff.setup({
      -- Use icons in the sign column
      view = {
        style = 'sign',
        signs = {
          add = '▎',
          change = '▎',
          delete = ' ',
        },
      },
      mappings = {
        -- Disable, just do it the usual way
        apply = '',
        reset = '',
      }
    })

    vim.keymap.set("n", "<leader>gd", function()
      mini_diff.toggle_overlay()
    end, { desc = "(Toggle) git diffs" })
  end
}
