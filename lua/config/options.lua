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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "**/templates/*.html",
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})

set.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  command = "if mode() !~ '\\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  pattern = '*',
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
