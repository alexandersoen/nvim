vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd.redrawtabline()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "GrappleUpdate", "GrappleTag", "GrappleUntag" },
  callback = function()
    vim.cmd.redrawtabline()
  end,
})

local heirline = require("heirline")
local utils = require("heirline.utils")
local grapple = require("grapple")

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

local ContextTab = {
  init = function(self)
    self.filename = vim.fn.expand("%:t")
    if self.filename == "" then self.filename = "[No Name]" end
  end,

  provider = function(self)
    if grapple.exists() then return " -- GRAPPLE -- " end
    return " " .. self.filename .. " "
  end,
  hl = function()
    return grapple.exists() and { fg = "gray", italic = true } or { fg = "green", bold = true }
  end,
}

local GrappleTabTemplate = {
  provider = function(self)
    return " [" .. self.grapplenum .. ": " .. (self.filename or "???") .. "] "
  end,

  hl = function(self)
    return self.is_active and { fg = "green", bold = true } or { fg = "gray" }
  end,
}

local grapple_list = require("utils").make_grapplelist(GrappleTabTemplate)

heirline.setup({
  tabline = {
    utils.surround({ "", "" }, "bright_bg", ContextTab),
    { provider = " " },
    grapple_list,
    { provider = "%=" },
  },
})
