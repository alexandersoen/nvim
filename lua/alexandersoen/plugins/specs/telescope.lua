-- Setting for telescope.

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",    desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",     desc = "Live Grep" },
    { "<leader>fs", "<cmd>Telescope spell_suggest<cr>", desc = "Spelling Suggestions" },
  },
  config = function()
    require("telescope").setup({
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
  end,
}
