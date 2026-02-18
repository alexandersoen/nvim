local trouble = require("trouble")

trouble.setup({
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
})

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble spelling toggle filter.buf=0 focus=false<cr>", { desc = "Buffer Spell Check" })
vim.keymap.set("n", "<leader>tS", function()
  vim.cmd("SpellingScan")
  vim.cmd("Trouble spelling toggle focus=false")
end, { desc = "Global Spell Check" })
