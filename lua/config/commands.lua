require("config.features.projects").setup()

-- Remove only the default mouse hint entry from right-click popup.
vim.cmd([[silent! aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[silent! aunmenu PopUp.-1-]])
