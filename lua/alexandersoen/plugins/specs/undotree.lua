-- Undotree

return {
  "mbbill/undotree",

  config = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 40

    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
  end
}
