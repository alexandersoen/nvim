return {
  "rebelot/heirline.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
    "rebelot/kanagawa.nvim",
  },
  config = function()
    local heirline = require("heirline")
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")

    local grapple = require("grapple")
    local grapple_update_cond = {
      "BufEnter", "User", pattern = { "GrappleUpdate", "GrappleTag", "GrappleUntag" }
    }

    -- Setup colours
    local function setup_colours()
      return {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }
    end

    heirline.load_colors(setup_colours)
    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(setup_colours)
      end,
      group = "Heirline",
    })

    -- Visual separator
    local big_sep = { provider = " │││ ", hl = { fg = "bright_fg" } }
    local small_sep = { provider = " │ ", hl = { fg = "bright_fg" } }

    -- Context tab
    local context_tab = {
      init = function(self)
        self.filename = vim.fn.expand("%:t")
        if self.filename == "" then self.filename = "[No Name]" end
      end,

      -- Update also on grapple add
      update = grapple_update_cond,

      -- Fixed width logic: ensuring the dummy and filename slot are consistent
      hl = function()
        if grapple.exists() then
          return { fg = "gray", italic = true } -- Grayed out
        else
          return { fg = "green", bold = true }  -- Active/Visible
        end
      end,

      {
        provider = function(self)
          if grapple.exists() then
            -- The "Dummy" tab: Fixed size (e.g., 13 chars wide)
            return " -- EMPTY -- "
          else
            -- Display actual filename (truncated if too long to maintain 'dummy' feel)
            local name = self.filename
            if #name > 10 then
              name = string.sub(name, 1, 10) .. "…"
            elseif #name <= 11 then
              name = name .. string.rep(" ", 11 - #name)
            end
            return " " .. name .. " "
          end
        end,
      },
    }

    context_tab = utils.surround({ "", "" }, "bright_fg", context_tab)

    -- Grapple List (The rest of the tabs)
    local grapple_tabs = {
      update = grapple_update_cond,

      provider = function()
        local status = grapple.statusline()

        if status == nil or status == "" then
          return "" -- Hide if no tags exist
        end

        return status
      end,
    }

    heirline.setup({
      winbar = {
        context_tab,
        big_sep,
        grapple_tabs,
      },
      opts = {
        -- if the callback returns true, the winbar will be disabled for that window
        -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
          }, args.buf)
        end,
      },
    })
  end
}
