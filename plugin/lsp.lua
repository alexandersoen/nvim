require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ruff", "texlab", "typos_lsp", "ltex" }
})

vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.diagnostic.config({
  virtual_text  = true,
  severity_sort = true,
  float         = {
    style  = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
  signs         = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.HINT]  = '⚑',
      [vim.diagnostic.severity.INFO]  = '»',
    },
  },
})

local caps = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
  caps = vim.tbl_deep_extend('force', caps, blink.get_lsp_capabilities({}, false))
  caps = vim.tbl_deep_extend('force', caps, {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  })
end

vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  capabilities = caps,
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.config['pyright'] = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
  capabilities = caps,
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = "standard",
        diagnosticSeverityOverrides = {
          reportUnknownParameterType = "error",
          reportMissingParameterType = "error",
          reportArgumentType = "warning",
          reportMissingTypeStubs = "none",
          reportUnknownMemberType = "none",
          reportUnusedImport = "none",
          reportUnusedVariable = "none",
          reportShadowedVariable = "none",
        },
      },
    },
  },
}

vim.lsp.config['ruff'] = {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  capabilities = caps,
  settings = {
    args = { "--config=~/.config/ruff/ruff.toml" },
  },
}

vim.lsp.config['texlab'] = {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.latexmkrc', '.texlabrc', 'texlab.toml', '.git' },
  capabilities = caps,
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
}

vim.lsp.config['typos_lsp'] = {
  cmd = { 'typos-lsp' },
  filetypes = { '*' },
  root_markers = { '_typos.toml', '.typos.toml', 'typos.toml', '.git' },
  capabilities = caps,
}

vim.lsp.config['ltex'] = {
  cmd = { 'ltex-ls' },
  filetypes = { 'bib', 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex', 'pandoc', 'quarto', 'rmd', 'context' },
  root_markers = { '.ltexrc', '.git' },
  capabilities = caps,
}

vim.lsp.config['html'] = {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'htmldjango' },
  root_markers = { 'package.json', '.git' },
  capabilities = caps,
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
  },
}

vim.lsp.config['htmx'] = {
  cmd = { 'htmx-lsp' },
  filetypes = { 'html', 'htmldjango' },
  root_markers = { '.git' },
  capabilities = caps,
}

vim.lsp.config['djlsp'] = {
  cmd = { 'djlsp' },
  filetypes = { 'htmldjango', 'html' },
  root_markers = { '.git' },
  capabilities = caps,
}

vim.opt.spell = false
vim.api.nvim_set_hl(0, "TyposUnderline", { undercurl = true, sp = "LightGrey" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>e", vim.diagnostic.open_float, "Show Diagnostic Error")

    if client and (client.name == "typos_lsp" or client.name == "ltex") then
      local ns = vim.lsp.diagnostic.get_namespace(client.id)
      vim.diagnostic.config({
        underline = {
          severity_highlight = {
            [vim.diagnostic.severity.HINT] = "SpellingUnderline",
            [vim.diagnostic.severity.INFO] = "SpellingUnderline",
            [vim.diagnostic.severity.WARN] = "SpellingUnderline",
          },
        },
        virtual_text = false,
        signs = false,
      }, ns)
    end
  end,
})

vim.lsp.enable({
  'lua_ls',
  'pyright',
  'ruff',
  'texlab',
  'typos_lsp',
  'ltex',
  'html',
  'htmx',
  'djlsp',
})
