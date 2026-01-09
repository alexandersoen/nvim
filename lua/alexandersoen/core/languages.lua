-- LSP server table.
-- All (hopefully) configs for languages should be here.

local M = {}

-- Add any server you want here.
-- If it needs special config, add a table; otherwise, just leave it empty.
M.config = {
  lua = {
    lsp = "lua_ls",
    formatter = "stylua",
    -- linter = "selene",
    lsp_opts = {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            }
          },
        },
      }
    },
  },
  tex = {
    lsp = "texlab",
    lsp_opts = {
      settings = {
        texlab = {
          build = {
            onSave = true,
            executable = "latexmk",
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
          },
          forwardSearch = {
            executable = "zathura",
            args = { "--synctex-forward", "%l:1:%f", "%p" },
          },
          latexFormatter = "none",
          chktex = {
            onOpenAndSave = true, -- This replaces your "missing" linter
            onEdit = true,
          },
          formatterLineLength = 80,
        },
      },
    },
    formatter = "tex-fmt",
    formatter_opts = { "--nowrap" }
  }
}

return M
