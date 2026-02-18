-- Colour schemes.

-- return {
--   "nvim-mini/mini.hues",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     local hues = require("mini.hues")
--     local palette = "miniwinter"
-- 
--     vim.cmd("colorscheme " .. palette)
-- 
--     local base_colours = hues.get_palette(palette)
-- 
--     hues.setup({
--       background = base_colours.bg,
--       foreground = base_colours.fg,
--       saturation = "high",
--       n_hues = 8,
--       accent = "bg",
--     })
--     vim.cmd("colorscheme " .. palette)
--   end,
-- }

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd("colorscheme tokyonight")
  end
}
