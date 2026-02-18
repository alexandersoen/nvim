local oil = require("oil")
local detail = false
local root_dir = vim.fs.root(0, '.git')

oil.setup({
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          oil.set_columns({ "icon", "permissions", "size", "mtime" })
        else
          oil.set_columns({ "icon" })
        end
      end,
    },
    ["<leader>pE"] = { "actions.close", mode = "n" },
  }
})

vim.keymap.set("n", "<leader>pe", ":Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>pE", function()
  oil.open(root_dir)
end, { desc = "Open root directory" })
