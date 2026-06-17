local ok, treesitter = pcall(require, "nvim-treesitter")

if not ok then
  return
end

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

treesitter.install({
  "lua",
  "vim",
  "vimdoc",
  "bash",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "python",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "c_sharp",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = languages,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)

    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
