require("mason").setup()


local servers = {
  -- lsp servers
  "lua_ls",
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "emmet_ls",
  "eslint",
  "html",
  "jsonls",
  "csharp_ls",
  "basedpyright",
  "ruff",
  "tailwindcss",
  "ts_ls",
}

local tools = vim.list_extend(vim.deepcopy(servers), {
  -- formatters / linters
  "stylua",
  "prettier",
  "clang-format",
  "csharpier",
  "shfmt",
  "markdownlint",
  "shellcheck",
  "sqlfluff",
})


vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = {
      buffer = event.buf,
      silent = true,
    }

    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
      desc = "Code action",
    }))
  end,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config("ts_ls", {})
vim.lsp.config("html", {})
vim.lsp.config("cssls", {})
vim.lsp.config("jsonls", {})
vim.lsp.config("bashls", {})
vim.lsp.config("csharp_ls", {})

require("mason-lspconfig").setup({
  automatic_enable = servers,
})

require("mason-tool-installer").setup({
  ensure_installed = tools,

  run_on_start = false,
  auto_update = false,
})
