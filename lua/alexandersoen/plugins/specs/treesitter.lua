-- Tree sitter configuration

local utils = require("alexandersoen.utils")

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ok, ts_configs = utils.safe_require("nvim-treesitter.configs")
    if not ok then return end

    ts_configs.setup({
      -- Core parsers to always have ready
      ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "latex", "bibtex" },

      -- Automatically install parsers for new filetypes you open
      auto_install = true,

      highlight = {
        enable = true,
        -- Standard Vim regex highlighting can sometimes conflict
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true
      },

      -- The "Smart Selection" feature we discussed
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "+",
          node_incremental = "+",
          scope_incremental = "_",
          node_decremental = "-",
        }
      },
    })
  end,
}
