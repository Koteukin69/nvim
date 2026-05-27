return {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = "n" } },
    opts = {
      pre_hook = function(...)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
      end,
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
