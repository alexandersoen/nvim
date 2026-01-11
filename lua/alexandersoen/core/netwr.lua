-- Netrw configurations

-- Netrw Configuration (Not used, but leave for fallback)
vim.g.netrw_banner = 1       -- Hide the help banner at the top
vim.g.netrw_liststyle = 3    -- Tree view
vim.g.netrw_winsize = 25     -- Set width to 25% of the screen
vim.g.netrw_browse_split = 4 -- Open files in previous window
vim.g.netrw_altv = 1         -- Open splits to the right


-- Open directory on `neovim`
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local path = vim.fn.argv(0)

    -- If no path given, use current directory
    if path == "" then
      path = vim.fn.getcwd()
      -- Schedule is to figure out load ordering.
      vim.schedule(function()
        vim.cmd("bwipeout!")
        vim.cmd("silent! edit " .. vim.fn.fnameescape(path))
      end)
    end
  end,
})
