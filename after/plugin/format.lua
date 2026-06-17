local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "prettier", stop_after_first = true },
    typescript = { "prettier", stop_after_first = true },
    javascriptreact = { "prettier", stop_after_first = true },
    typescriptreact = { "prettier", stop_after_first = true },

    html = { "prettier", stop_after_first = true },
    css = { "prettier", stop_after_first = true },
    scss = { "prettier", stop_after_first = true },
    json = { "prettier", stop_after_first = true },
    yaml = { "prettier", stop_after_first = true },
    markdown = { "prettier", stop_after_first = true },

    sh = { "shfmt" },

    c = { "clang_format" },
    cpp = { "clang_format" },
    h = { "clang_format" },
    hpp = { "clang_format" },

    cs = { "csharpier" },

    python = {
      "ruff_fix",
      "ruff_format",
      "ruff_organize_imports",
    },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },

  notify_on_error = true,
  notify_no_formatters = false,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, {
  desc = "Format buffer",
})
