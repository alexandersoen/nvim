-- Core keymaps.

local keymap = vim.keymap

-- Set leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw
keymap.set("n", "<leader>pv", vim.cmd.Lexplore, { desc = "Toggle Explorer" })
keymap.set("n", "<leader>pe", vim.cmd.Ex, { desc = "Open Explorer" })
