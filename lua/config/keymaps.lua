vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-w>", "<cmd>bdelete<cr>", { desc = "Delete buffer", nowait = true })
vim.keymap.set("n", "<C-r>", function()
  require("config.features.projects").open()
end, { desc = "Open project" })
