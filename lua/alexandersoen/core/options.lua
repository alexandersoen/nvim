-- Core options.

local opt = vim.opt

-- Line numbers
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative numbers help with jumping (e.g., 10j)

-- Search behavior
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true  -- ...unless search has a capital letter
opt.hlsearch = false  -- Don't keep search results highlighted forever
opt.incsearch = true  -- shows replacement as we are making them

-- Tabs & Indentation
opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 2   -- Size of an indent
opt.tabstop = 2      -- Number of spaces tabs count for
opt.softtabstop = 2  -- Same but for editing

-- Quality of Life
opt.termguicolors = true      -- Enable 24-bit RGB colors
opt.cursorline = true         -- Highlight the line the cursor is on
opt.scrolloff = 8             -- Keep 8 lines above/below cursor when scrolling
opt.signcolumn = "yes:1"      -- Always show gutter (prevents shifting text)
opt.mouse = "a"               -- Allow mouse usage (useful for scrolling)
opt.clipboard = "unnamedplus" -- Default clipboard

-- Undo
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- UI
opt.showtabline = 2
opt.shortmess:append("I")
opt.winborder = "rounded"

-- Force specifically for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Djangoing
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "**/templates/*.html",
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})
