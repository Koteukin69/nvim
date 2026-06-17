local cmp = require("cmp")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
  enabled = true,

  preselect = cmp.PreselectMode.None,

  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
    },
    completeopt = "menu,menuone,noselect",
  },

  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },

  mapping = {
    ["<C-Space>"] = cmp.mapping(function()
      cmp.complete()
    end, { "i" }),

    ["<C-e>"] = cmp.mapping(function()
      cmp.abort()
    end, { "i" }),
    ["<CR>"] = cmp.mapping.confirm({
      select = false,
    }),

    ["<Tab>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
    }),

    ["<S-Tab>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
    }),

    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  },

  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      keyword_length = 1,
    },
    {
      name = "path",
    },
  }, {
    {
      name = "buffer",
      keyword_length = 1,
    },
  }),
})
