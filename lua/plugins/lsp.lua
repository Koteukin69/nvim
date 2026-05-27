return {
  {
    "williamboman/mason.nvim",
    version = "v1.11.0",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "csharpier",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    version = "v1.32.0",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = false,
      ensure_installed = {
        "lua_ls",
        "pyright",
        "vtsls",
        "eslint",
        "html",
        "cssls",
        "emmet_ls",
        "tailwindcss",
        "omnisharp",
        "bashls",
        "jsonls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    version = "v2.5.0",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.plugins.lsp").setup()
    end,
  },
}
