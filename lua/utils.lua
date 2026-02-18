local M = {}

function M.safe_require(module)
  local success, res = pcall(require, module)
  if not success then
    vim.notify("Error loading " .. module .. "\n\n" .. res, vim.log.levels.ERROR)
  end
  return success, res
end

local NGRAPLINES = 0

function M.make_grapplelist(grapple_component, left_trunc, right_trunc)
  local ok, grapple = M.safe_require("grapple")
  if not ok then
    return { provider = "" }
  end

  left_trunc = left_trunc or { provider = "", hl = { fg = "gray" } }
  right_trunc = right_trunc or { provider = "", hl = { fg = "gray" } }

  NGRAPLINES = NGRAPLINES + 1

  left_trunc.on_click = {
    callback = function(self)
      local root = self._graplist[1]
      root._cur_page = root._cur_page - 1
      root._force_page = true
      vim.cmd("redrawtabline")
    end,
    name = "Heirline_tabline_prev_" .. NGRAPLINES,
  }

  right_trunc.on_click = {
    callback = function(self)
      local root = self._graplist[1]
      root._cur_page = root._cur_page + 1
      root._force_page = true
      vim.cmd("redrawtabline")
    end,
    name = "Heirline_tabline_next_" .. NGRAPLINES,
  }

  return {
    static = {
      _left_trunc = left_trunc,
      _right_trunc = right_trunc,
      _cur_page = 1,
      _force_page = false,
      _graplist = {},
    },
    init = function(self)
      if #self._graplist == 0 then
        table.insert(self._graplist, self)
      end

      if not self.left_trunc then self.left_trunc = self:new(self._left_trunc) end
      if not self.right_trunc then self.right_trunc = self:new(self._right_trunc) end

      if not self._once then
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
          callback = function() self._force_page = false end,
        })
        self._once = true
      end

      local tags = grapple.tags() or {}
      local current_path = vim.api.nvim_buf_get_name(0)

      for i, tag in ipairs(tags) do
        local filename = vim.fn.fnamemodify(tag.path, ":t")
        local child = self[i]

        if not (child and child.filename == filename) then
          self[i] = self:new(grapple_component, i)
          child = self[i]
          child.grapplenum = tostring(i)
          child.filename = filename
          child.path = tag.path
        end

        if tag.path == current_path then
          child.is_active = true
          self.active_child = i
        else
          child.is_active = false
        end
      end

      if #self > #tags then
        for i = #self, #tags + 1, -1 do
          self[i] = nil
        end
      end
    end,
  }
end

return M
