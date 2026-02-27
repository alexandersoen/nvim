-- Some horrible mess to make a 'tabline' which interfaces with grapple.

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

local function get_hl_color(name, attribute, fallback)
	local hl = utils.get_highlight(name)
	if hl and hl[attribute] then
		return hl[attribute]
	end
	for _, fallback_name in ipairs(fallback or {}) do
		local fb_hl = utils.get_highlight(fallback_name)
		if fb_hl and fb_hl[attribute] then
			return fb_hl[attribute]
		end
	end
	return nil
end

local function setup_colours()
	local function c(name, attr, fallback)
		return get_hl_color(name, attr, fallback)
	end
	return {
		bright_bg = c("ColorColumn", "bg", { "Normal", "CursorLine" }),
		bright_fg = c("Folded", "fg", { "Comment", "Normal" }),
		red = c("DiagnosticError", "fg", { "Error", "Red" }),
		dark_red = c("DiffDelete", "bg", { "DiffDelete", "Error" }),
		green = c("String", "fg", { "Green", "MoreMsg" }),
		blue = c("Function", "fg", { "Blue", "Type" }),
		gray = c("Comment", "fg", { "Grey", "Normal" }),
		orange = c("Constant", "fg", { "Orange", "PreProc" }),
		purple = c("Statement", "fg", { "Purple", "Statement" }),
		cyan = c("Special", "fg", { "Cyan", "SpecialChar" }),
		diag_warn = c("DiagnosticWarn", "fg", { "Warning", "Yellow" }),
		diag_error = c("DiagnosticError", "fg", { "Error", "Red" }),
		diag_hint = c("DiagnosticHint", "fg", { "Hint", "Cyan" }),
		diag_info = c("DiagnosticInfo", "fg", { "Info", "Blue" }),
		git_del = c("diffRemoved", "fg", { "DiffDelete", "Error" }),
		git_add = c("diffAdded", "fg", { "DiffAdd", "Green" }),
		git_change = c("diffChanged", "fg", { "DiffChange", "Yellow" }),
	}
end

heirline.load_colors(setup_colours())
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		utils.on_colorscheme(setup_colours)
	end,
	group = "Heirline",
})

local function get_grapple()
	local ok, grapple = pcall(require, "grapple")
	return ok and grapple or nil
end

local function grapple_exists()
	local grapple = get_grapple()
	return grapple and grapple.exists()
end

local ContextTab = {
	init = function(self)
		self.filename = vim.fn.expand("%:t")
		if self.filename == "" then
			self.filename = "[No Name]"
		end
	end,

	provider = function(self)
		if grapple_exists() then
			return " -- GRAPPLE -- "
		end
		return " " .. self.filename .. " "
	end,
	hl = function()
		return grapple_exists() and { fg = "gray", italic = true } or { fg = "green", bold = true }
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

local grapple_list = require("utils").make_grapplelist(utils.surround({ "", "" }, "bright_bg", GrappleTabTemplate))

heirline.setup({
	tabline = {
		utils.surround({ "", "" }, "bright_bg", ContextTab),
		{ provider = " " },
		grapple_list,
		{ provider = "%=" },
	},
})
