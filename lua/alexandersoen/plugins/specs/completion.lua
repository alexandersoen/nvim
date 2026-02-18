-- Completion setup. Usinh blink.cmp at the moment.

return {
  'saghen/blink.cmp',
  dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  version = '*',

  opts = {
    -- 'default' for mappings similar to vscode
    -- 'super-tab' for the behavior we discussed
    keymap = {
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-y>'] = { 'accept', 'fallback' },

      ['<C-k>'] = { 'snippet_forward', 'fallback' },
      ['<C-j>'] = { 'snippet_backward', 'fallback' },

      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    snippets = { preset = 'luasnip' },

    -- Default list of enabled providers
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    completion = {
      menu = { auto_show = false },
      ghost_text = { enabled = true, show_with_menu = true }
    },

    -- Signature help (parameter hints)
    signature = {
      enabled = true,
    },

  },
  opts_extend = { "sources.default" },
  init = function()
    local blink = require('blink.cmp')

    -- Setup completion keybind (remap from default omni)
    vim.keymap.set('i', '<C-x><C-o>', function()
      blink.show()
      blink.show_documentation()
      blink.hide_documentation()
    end, { silent = false })
  end,
}
