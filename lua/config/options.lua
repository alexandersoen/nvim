local set = vim.opt

set.number = true
set.relativenumber = true

set.ignorecase = true
set.smartcase = true
set.hlsearch = false
set.incsearch = true

set.expandtab = true
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2

set.termguicolors = true
set.cursorline = true
set.scrolloff = 8
set.signcolumn = "yes:1"
set.mouse = "a"
set.clipboard = "unnamedplus"

set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

set.showtabline = 2
set.shortmess:append("I")
set.winborder = "rounded"

set.autoread = true -- Configured in an autocmd

vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
