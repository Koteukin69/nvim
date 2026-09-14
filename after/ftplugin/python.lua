if vim.fn.expand("%:e") ~= "pyj" then
  return
end

vim.diagnostic.enable(false, { bufnr = 0 })
vim.treesitter.start(0, "python")
