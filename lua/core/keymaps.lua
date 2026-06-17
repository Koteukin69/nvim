vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
