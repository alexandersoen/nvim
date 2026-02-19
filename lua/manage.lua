local M = {}
local plug_dir = vim.fn.stdpath("data") .. "/plugins"

local function ensure(spec)
  local repo = type(spec) == "string" and spec or spec[1]
  local name = repo:match(".+/(.+)$")
  local path = plug_dir .. "/" .. name

  if not vim.uv.fs_stat(path) then
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

local function source_plugin_files()
  local config_plugin = vim.fn.stdpath("config") .. "/plugin"
  if vim.uv.fs_stat(config_plugin) then
    for _, file in ipairs(vim.fn.glob(config_plugin .. "/**/*.lua", true, true)) do
      vim.cmd.source(file)
    end
  end
end

function M.setup()
  for _, spec in ipairs(require("plugins")) do
    ensure(spec)
  end
  source_plugin_files()
end

function M.update()
  local plugins = require("plugins")
  local total = #plugins
  local updated = {}
  local failed = {}
  local skipped = 0

  print("Checking " .. total .. " plugins for updates...")

  for i, spec in ipairs(plugins) do
    local repo = type(spec) == "string" and spec or spec[1]
    local name = repo:match(".+/(.+)$")
    local path = plug_dir .. "/" .. name

    vim.cmd("echohl Directory")
    vim.cmd("echon '[' .. (" .. i .. ") .. '/' .. " .. total .. " .. '] Checking " .. name .. "...'")
    vim.cmd("echohl None")

    if vim.uv.fs_stat(path) then
      local cmd = { "git", "-C", path, "pull", "--ff-only" }
      local result = vim.fn.systemlist(cmd)
      if vim.v.shell_error == 0 then
        if result[1] and not result[1]:match("Already up to date") then
          table.insert(updated, name)
          vim.cmd("echohl MoreMsg")
          vim.cmd("echon ' UPDATED'")
          vim.cmd("echohl None")
        else
          vim.cmd("echon ' (up to date)'")
          skipped = skipped + 1
        end
      else
        table.insert(failed, name)
        vim.cmd("echohl ErrorMsg")
        vim.cmd("echon ' FAILED'")
        vim.cmd("echohl None")
      end
    else
      vim.cmd("echon ' (not installed)'")
    end
    vim.cmd("redraw")
  end

  print("")
  print("=== Update Summary ===")
  print("Checked: " .. total .. " plugins")
  print("Updated: " .. #updated)
  if #updated > 0 then
    for _, name in ipairs(updated) do
      print("  - " .. name)
    end
  end
  print("Up to date: " .. skipped)
  if #failed > 0 then
    print("Failed: " .. #failed)
    for _, name in ipairs(failed) do
      print("  - " .. name)
    end
  end
end

vim.api.nvim_create_user_command("PluginUpdate", function()
  require("manage").update()
end, { desc = "Update all plugins" })

return M
