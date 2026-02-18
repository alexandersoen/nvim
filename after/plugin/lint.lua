local lint = require("lint")
local lang_configs = require("config.languages").config

for ft, cfg in pairs(lang_configs) do
  if cfg.linter then
    lint.linters_by_ft[ft] = type(cfg.linter) == "table" and cfg.linter or { cfg.linter }
  end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = function()
    if lang_configs[vim.bo.filetype] then
      lint.try_lint()
    end
  end,
})
