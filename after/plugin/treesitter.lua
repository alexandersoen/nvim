local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
  return
end

local parsers = {
  "bash",
  "bibtex",
  "c",
  "css",
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "vim",
  "vimdoc",
}

ts.setup()
ts.install(parsers)

vim.treesitter.language.register("bash", "sh")
vim.treesitter.language.register("bibtex", "bib")
vim.treesitter.language.register("latex", { "plaintex", "tex" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "bib",
    "c",
    "css",
    "lua",
    "markdown",
    "plaintex",
    "python",
    "query",
    "sh",
    "tex",
    "vim",
    "vimdoc",
  },
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match)
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    vim.treesitter.start(event.buf, lang)

    -- local win = vim.fn.bufwinid(event.buf)
    -- if win ~= -1 then
    --   vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --   vim.wo[win].foldmethod = "expr"
    -- end

    -- vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
