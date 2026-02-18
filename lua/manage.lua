local M = {}
local plug_dir = vim.fn.stdpath("data") .. "/plugins"

local function ensure(spec)
  local repo = type(spec) == "string" and spec or spec[1]
  local name = repo:match(".+/(.+)$")
  local path = plug_dir .. "/" .. name
  local is_new = not vim.uv.fs_stat(path)

  if is_new then
    vim.fn.mkdir(plug_dir, "p")
    local cmd = { "git", "clone", "--depth=1" }
    if spec.branch then
      table.insert(cmd, "-b")
      table.insert(cmd, spec.branch)
    end
    table.insert(cmd, "https://github.com/" .. repo)
    table.insert(cmd, path)
    print("Installing " .. name .. "...")
    vim.fn.system(cmd)
  end

  vim.opt.rtp:append(path)
  local lua_path = path .. "/lua"
  if vim.uv.fs_stat(lua_path) then
    package.path = package.path .. ";" .. lua_path .. "/?.lua;" .. lua_path .. "/?/init.lua"
  end
end

function M.setup()
  for _, spec in ipairs(require("plugins")) do
    ensure(spec)
  end
end

return M
