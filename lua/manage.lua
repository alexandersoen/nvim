local M = {}
local plug_dir = vim.fn.stdpath("data") .. "/plugins"

local function get_latest_tag(repo, version_pattern)
  local cmd = "git ls-remote --tags https://github.com/" .. repo .. " 2>/dev/null"
  local handle = io.popen(cmd)
  if not handle then return nil end

  local tags = {}
  for line in handle:lines() do
    local tag = line:match("refs/tags/(.+)$")
    if tag and not tag:match("%^") then
      table.insert(tags, tag)
    end
  end
  handle:close()

  if version_pattern then
    local pattern = version_pattern:gsub("%*", ".*"):gsub("%.", "%%.")
    for _, tag in ipairs(tags) do
      if tag:match("^" .. pattern .. "$") then
        return tag
      end
    end
  end

  return tags[#tags]
end

local function ensure(spec)
  local repo = type(spec) == "string" and spec or spec[1]
  local name = repo:match(".+/(.+)$")
  local path = plug_dir .. "/" .. name

  if not vim.uv.fs_stat(path) then
    vim.fn.mkdir(plug_dir, "p")
    local cmd = { "git", "clone", "--depth=1" }

    if spec.version then
      local tag = get_latest_tag(repo, spec.version)
      if tag then
        table.insert(cmd, "-b")
        table.insert(cmd, tag)
      end
    elseif spec.branch then
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

function M.clean()
  local plugins = require("plugins")
  local wanted = {}
  for _, spec in ipairs(plugins) do
    local repo = type(spec) == "string" and spec or spec[1]
    local name = repo:match(".+/(.+)$")
    wanted[name] = true
  end

  local removed = {}
  local handle = vim.uv.fs_scandir(plug_dir)
  if handle then
    while true do
      local name = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if not wanted[name] then
        local path = plug_dir .. "/" .. name
        vim.fn.delete(path, "rf")
        table.insert(removed, name)
        print("Removed: " .. name)
      end
    end
  end

  if #removed == 0 then
    print("No unused plugins to remove")
  else
    print("Removed " .. #removed .. " unused plugins")
  end
end

function M.status()
  local plugins = require("plugins")
  print("=== Plugin Status ===")
  print("")
  for _, spec in ipairs(plugins) do
    local repo = type(spec) == "string" and spec or spec[1]
    local name = repo:match(".+/(.+)$")
    local path = plug_dir .. "/" .. name

    if vim.uv.fs_stat(path) then
      local handle = io.popen("git -C " .. path .. " log -1 --format='%h %cr' 2>/dev/null")
      local info = handle and handle:read("*l") or "unknown"
      if handle then handle:close() end
      print(string.format("  ✓ %-25s %s", name, info))
    else
      print(string.format("  ✗ %-25s (not installed)", name))
    end
  end
end

function M.install()
  local plugins = require("plugins")
  local installed = 0

  for _, spec in ipairs(plugins) do
    local repo = type(spec) == "string" and spec or spec[1]
    local name = repo:match(".+/(.+)$")
    local path = plug_dir .. "/" .. name

    if not vim.uv.fs_stat(path) then
      print("Installing " .. name .. "...")
      ensure(spec)
      installed = installed + 1
    end
  end

  if installed == 0 then
    print("All plugins already installed")
  else
    print("Installed " .. installed .. " plugins")
  end
end

vim.api.nvim_create_user_command("PluginUpdate", function()
  require("manage").update()
end, { desc = "Update all plugins" })

vim.api.nvim_create_user_command("PluginClean", function()
  require("manage").clean()
end, { desc = "Remove unused plugins" })

vim.api.nvim_create_user_command("PluginStatus", function()
  require("manage").status()
end, { desc = "Show plugin status" })

vim.api.nvim_create_user_command("PluginInstall", function()
  require("manage").install()
end, { desc = "Install missing plugins" })

return M
