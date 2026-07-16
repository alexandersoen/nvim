vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"
-- vim.g.vimtex_quickfix_mode = 0
-- vim.g.vimtex_fold_enabled = 0
vim.g.vimtex_mappings_prefix = "\\"

local function init_vimtex()
  if vim.b.vimtex or vim.fn.exists("*vimtex#init") == 0 then
    return
  end

  pcall(vim.fn["vimtex#init"])
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "bib" },
  callback = init_vimtex,
})

if vim.tbl_contains({ "tex", "plaintex", "bib" }, vim.bo.filetype) then
  init_vimtex()
end
