local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

ts_configs.setup({
  ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "latex", "bibtex", "css" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
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
