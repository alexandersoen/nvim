-- Formatter

return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    local lang_configs = require("alexandersoen.core.languages").config

    local formatters = {}
    local formatter_opts = {}

    for ft, cfg in pairs(lang_configs) do
      if cfg.formatter then
        formatters[ft] = { cfg.formatter }

        if cfg.formatter_opts then
          formatter_opts[cfg.formatter] = {
            prepend_args = cfg.formatter_opts
          }
        end
      end
    end


    conform.setup({
      formatters_by_ft = formatters,
      formatters = formatter_opts,
      -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
    })

    vim.keymap.set("n", "gq",
      function()
        print("Formatting")
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500
        })
      end,
      { desc = "Format" })
  end
}
