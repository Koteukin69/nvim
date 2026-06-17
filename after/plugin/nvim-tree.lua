local api = require("nvim-tree.api")

require("nvim-tree").setup({
  view = {
    width = 30,
  },

  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "C", api.tree.change_root_to_node, {
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    })

    vim.keymap.set("n", "<Space>", api.node.open.edit, {
      buffer = bufnr,
      desc = "Open",
      noremap = true,
      silent = true,
      nowait = true,
    })

    vim.keymap.set("n", "<Tab>", "<C-w>p", {
      buffer = bufnr,
      desc = "Focus previous window",
      noremap = true,
      silent = true,
      nowait = true,
    })

    vim.keymap.set("n", "e", "<cmd>NvimTreeToggle<cr>", {
      buffer = bufnr,
      desc = "Toggle nvim-tree",
      noremap = true,
      silent = true,
      nowait = true,
    })
  end,
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>", {
  desc = "Find current file in tree",
})
