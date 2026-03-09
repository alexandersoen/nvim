local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    tex = { "tex-fmt" },
    bib = { "bibtex-tidy" },
    python = { "ruff_organize_imports", "ruff_format" },
    nix = { "nixfmt" },
    go = { "goimports", "gofmt" },
  },
})

conform.formatters["tex-fmt"] = {
  prepend_args = { "--nowrap" },
}

conform.formatters["bibtex-tidy"] = {
  prepend_args = {
    "--curly",
    "--space=2",
    "--blank-lines",
    "--sort",
    "--duplicates",
    "--enclosing-braces",
    "--no-wrap",
    "--sort=-year,name",
  },
}

vim.keymap.set("n", "gq", function()
  print("Formatting")
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format" })
