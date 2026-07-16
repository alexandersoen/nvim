local M = {}

local function format_row(spec)
  local row = {}
  if type(spec) == "string" then
    row["src"] = "https://github.com/" .. spec
  else
    row["src"] = "https://github.com/" .. spec[1]
  end

  if spec.version then
    row["version"] = spec.version
  end

  return row
end

function M.setup()
  local plugs = require("plugins")

  local payload = {}
  for _, spec in ipairs(plugs) do
    local row = format_row(spec)
    table.insert(payload, row)
  end

  vim.pack.add(payload)
end

return M
