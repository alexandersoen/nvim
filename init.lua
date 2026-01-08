local utils = require("alexandersoen.utils")

-- List of modules to load in order
local modules = {
  "alexandersoen.core.options",
  "alexandersoen.core.keymaps",
  "alexandersoen.core.netwr",
  "alexandersoen.plugins", -- This triggers the Lazy.nvim setup
}

for _, module in ipairs(modules) do
  utils.safe_require(module)
end
