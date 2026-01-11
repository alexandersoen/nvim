-- Completition setup. Usin blink.cmp at the moment.

return {
  'saghen/blink.cmp',
  version = '*',

  opts = {
    -- 'default' for mappings similar to vscode
    -- 'super-tab' for the behavior we discussed
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-y>'] = { 'accept', 'fallback' },

      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback'
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    -- Default list of enabled providers
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    completion = {
      menu = { border = 'single' },
      documentation = { window = { border = 'single' } },
    },

    -- Signature help (parameter hints)
    signature = {
      enabled = true,
      window = { border = 'single' }
    },
  },
  opts_extend = { "sources.default" }
}
