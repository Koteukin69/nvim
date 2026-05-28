local M = {}

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = {
    python = { "ruff" },
    sh = { "shellcheck" },
    -- markdown = { "markdownlint" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
