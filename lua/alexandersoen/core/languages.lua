-- LSP server table.
-- All (hopefully) configs for languages should be here.

local M = {}

-- Add any server you want here.
-- If it needs special config, add a table; otherwise, just leave it empty.
M.config = {
  -- Lua
  lua = {
    lsp = "lua_ls",
    formatter = "stylua",
    -- linter = "selene",
    lsp_opts = {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, },
          },
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

  -- LaTeX
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
            onOpenAndSave = true,
            onEdit = true,
            additionalArgs = { "-n1", "-n2", "-n3", "-n9", "-n13" }
          },
          formatterLineLength = 80,
        },
      },
    },
    formatter = "tex-fmt",
    formatter_opts = { "--nowrap" },
  },

  -- Python
  python = {
    lsp = "pyright",
    lsp_opts = {
      settings = {
        pyright = {
          -- Let Ruff handle organizing imports
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- "None" or "OpenedFilesOnly" avoids Pyright bloating memory
            -- on large projects. "Standard" is best for safety.
            typeCheckingMode = "standard",
            -- Tell Pyright to ignore these because Ruff handles them better/faster:
            diagnosticSeverityOverrides = {
              -- FORCE types for my code
              reportUnknownParameterType = "error",
              reportMissingParameterType = "error",

              -- For untyped libraries zzz
              reportArgumentType = "warning",

              -- Ignore untyped external libraries
              reportMissingTypeStubs = "none",
              reportUnknownMemberType = "none",

              reportUnusedImport = "none",
              reportUnusedVariable = "none",
              reportShadowedVariable = "none",
            },
          },
        },
      },
    },
  },
  python_ruff = {
    lsp = "ruff",
    lsp_opts = {
      init_options = {
        settings = {
          -- Any extra CLI arguments for ruff go here
          args = {
            "--config=~/.config/ruff/ruff.toml",
          },
        }
      },
    }
  },

  -- Django Template LSP
  django_html = {
    lsp = "djlsp",
    lsp_opts = {
      filetypes = { "htmldjango", "html" },
      init_options = {
      }
    }
  },

  -- Standard HTML + HTMX
  html = {
    lsp = "html",
    lsp_opts = {
      filetypes = { "html", "htmldjango" },
    }
  },

  htmx = {
    lsp = "htmx",
    lsp_opts = {
      filetypes = { "html", "htmldjango" },
    }
  }
}

return M
