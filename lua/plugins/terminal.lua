return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
      { "<C-Space>", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
      { "<Nul>", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
    },
    opts = { direction = "float", open_mapping = { [[<C-Space>]], [[<Nul>]] } },
  },
}
