-- LSP setup. Currently just looping through our config.
-- Also includes keybinds for LSP related items.

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },

  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Setup Mason first
    mason.setup()
    mason_lspconfig.setup()

    -- Build your servers table
    local langconfigs = require("alexandersoen.core.languages").config

    -- Setup capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_cmp, cmp_lsp = pcall(require, "blink.cmp")
    if has_cmp then
      -- Merge
      capabilities = vim.tbl_deep_extend('force', capabilities,
        cmp_lsp.get_lsp_capabilities({}, false)
      )

      -- Other stuff in "blink.cmp" docs
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        }
      })
    end

    -- Set up the LSP configs
    for _, cfg in pairs(langconfigs) do
      local server_name = cfg.lsp

      if server_name then
        -- Check if lspconfig actually supports this server
        if vim.lsp.config[server_name] then
          local opts = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
          }, cfg.lsp_opts or {})

          vim.lsp.config(cfg.lsp, opts)
        else
          vim.notify("LSP Config: Server " .. server_name .. " not found in lspconfig", vim.log.levels.WARN)
        end
      end
    end

    -- Autocmd keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to Definition")
        map("gr", require("telescope.builtin").lsp_references, "Go to References")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

        map("<leader>e", vim.diagnostic.open_float, "Show Diagnostic Error")
        map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
      end,
    })
  end,
}
