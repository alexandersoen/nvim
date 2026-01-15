-- Linter setup.

return {
  "mfussenegger/nvim-lint",
  config = function()
    local lang_configs = require("alexandersoen.core.languages").config
    local lint = require("lint")

    -- Mapping linters from configs.
    for ft, cfg in pairs(lang_configs) do
      if cfg.linter then
        lint.linters_by_ft[ft] = type(cfg.linter) == "table" and cfg.linter or { cfg.linter }
      end
    end

    -- Optimized Autocmd
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
        -- Only lint if we have a linter specified in the languages config.
        -- if lang_configs[vim.bo.filetype] then
        --   lint.try_lint()
        -- end
      end,
    })
  end,
}
