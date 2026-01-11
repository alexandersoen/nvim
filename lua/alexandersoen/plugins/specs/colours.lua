-- Colour schemes.

return {
  "shaunsingh/nord.nvim",
  config = function()
    vim.g.nord_contrast = true

    require("nord").set()
  end
}
