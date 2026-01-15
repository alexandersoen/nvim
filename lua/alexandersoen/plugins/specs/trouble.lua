-- Trouble (Diagnostics)

return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      spelling = {
        mode = "diagnostics",
        filter = function(items)
          return vim.tbl_filter(function(item)
            local source = item["item.source"]
            return source == "typos" or source == "LTeX"
          end, items)
        end
      },
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>tT",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>tl",
      "<cmd>Trouble lsp toggle focus=false<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>tq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    -- Doesn't work :(
    -- Appears in quick fix at least
    { "<leader>ts", "<cmd>Trouble spelling toggle filter.buf=0 focus=false<cr>", desc = "Buffer Spell Check" },
    {
      "<leader>tS",
      function()
        vim.cmd("SpellingScan")
        vim.cmd("Trouble spelling toggle focus=false")
      end,
      desc = "Global Spell Check"
    },
  },
}
