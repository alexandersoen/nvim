vim.api.nvim_create_user_command("SpellingScan", function()
  local ignore_patterns = {
    "%.gitignore$",
    "%.pdf$",
    "%.png$",
    "%.jpg$",
    "%.jpeg$",
    "%.gif$",
    "%.svg$",
    "%.bib$",
    "%.lock$",
  }
  local handle = io.popen("git ls-files --cached --others --exclude-standard")
  if not handle then
    vim.notify("Not a git repository or git not found", vim.log.levels.ERROR)
    return
  end

  local result = handle:read("*a")
  handle:close()

  local count = 0
  for file in result:gmatch("[^\r\n]+") do
    local should_ignore = false

    for _, pattern in ipairs(ignore_patterns) do
      if file:match(pattern) then
        should_ignore = true
        break
      end
    end

    if not should_ignore and vim.fn.isdirectory(file) == 0 then
      local bufnr = vim.fn.bufadd(file)
      pcall(vim.fn.bufload, bufnr)
      count = count + 1
    end
  end

  vim.notify("Scanning " .. count .. " files (respecting .gitignore)...")
end, { desc = "Load all non-ignored files for LSP scanning" })
