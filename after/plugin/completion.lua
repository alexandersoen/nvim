local blink = require('blink.cmp')

blink.setup({
  fuzzy = { implementation = "lua" },

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
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    menu = { auto_show = false },
    ghost_text = { enabled = true, show_with_menu = true }
  },
  signature = {
    enabled = true,
  },
})

vim.keymap.set('i', '<C-x><C-o>', function()
  blink.show()
  blink.show_documentation()
  blink.hide_documentation()
end, { silent = false })
