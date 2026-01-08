-- Formatter

return {
  "stevearc/conform.nvim",
  opts = function()
    local lang_configs = require("alexandersoen.core.languages").config
    local formatters = {}

    for ft, cfg in pairs(lang_configs) do
      if cfg.formatter then formatters[ft] = { cfg.formatter } end
    end

    return {
      formatters_by_ft = formatters,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    }
  end,
}
