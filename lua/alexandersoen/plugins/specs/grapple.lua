-- Grapple for quick jumping.

return {
  "cbochs/grapple.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true }
  },
  config = function()
    local grapple = require("grapple")

    grapple.setup({
      scope = "git",
      icons = true,
      statusline = {
        active = "[%s]",   -- Format for the current file's tab
        inactive = " %s ", -- Format for other tabs
        include_icon = false,
      }
    })

    -- Keymaps for grapple
    vim.keymap.set("n", "<leader>a", function()
      grapple.toggle()

      -- Force /ui redraw
      vim.api.nvim_exec_autocmds("User", { pattern = "GrappleUpdate" })
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end, { desc = "Toggle Grapple Tag & Refresh UI" })
    vim.keymap.set("n", "<C-e>", grapple.toggle_tags)

    vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>")
    vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<cr>")
    vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<cr>")
    vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<cr>")
    vim.keymap.set("n", "<leader>5", "<cmd>Grapple select index=5<cr>")
    vim.keymap.set("n", "<leader>6", "<cmd>Grapple select index=6<cr>")
    vim.keymap.set("n", "<leader>7", "<cmd>Grapple select index=7<cr>")
    vim.keymap.set("n", "<leader>8", "<cmd>Grapple select index=8<cr>")
    vim.keymap.set("n", "<leader>9", "<cmd>Grapple select index=9<cr>")

    vim.keymap.set("n", "gt", function()
      grapple.cycle_tags("next")
    end)
    vim.keymap.set("n", "gT", function()
      grapple.cycle_tags("prev")
    end)
  end
}
