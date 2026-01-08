-- Some utility functions.

local M = {}

-- Helper to safely load modules
function M.safe_require(module)
  local success, res = pcall(require, module)
  if not success then
    vim.notify("Error loading " .. module .. "\n\n" .. res, vim.log.levels.ERROR)
  end

  return success, res
end

-- Not currently used.
function M.confirm_and_install(tool_name, install_fn)
  local choices = { "Yes", "No" }
  vim.ui.select(choices, {
    prompt = "Install " .. tool_name .. "?",
  }, function(choice)
    if choice == "Yes" then
      install_fn()
      vim.notify("Installing " .. tool_name .. "...", vim.log.levels.INFO)
    end
  end)
end

return M
