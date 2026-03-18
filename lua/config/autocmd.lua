vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.textwidth = 88
    vim.opt_local.formatoptions:append("croqj")
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "**/templates/*.html",
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.tcss",
  callback = function()
    vim.bo.filetype = "css"
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() !~ '\\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex", "plaintex" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
