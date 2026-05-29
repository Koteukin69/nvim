local M = {}

function M.opts()
  return {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "C", api.tree.change_root_to_node, {
        buffer = bufnr,
        desc = "CD",
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

      vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", {
        buffer = bufnr,
        desc = "Next buffer",
        noremap = true,
        silent = true,
      })

      vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", {
        buffer = bufnr,
        desc = "Previous buffer",
        noremap = true,
        silent = true,
      })

      vim.keymap.set("n", "e", "<C-w>p", {
        buffer = bufnr,
        desc = "Focus previous window",
        noremap = true,
        silent = true,
        nowait = true,
      })
    end,
    view = { width = 35 },
    renderer = { group_empty = true },
    filters = {
      dotfiles = false,
      custom = require("config.ignore").nvim_tree,
    },
  }
end

function M.setup(opts)
  require("nvim-tree").setup(opts)

  if vim.fn.argc() == 0 then
    vim.schedule(function()
      require("nvim-tree.api").tree.open()
      vim.cmd("wincmd p")
    end)
  end
end

return M
