local M = {}

function M.setup()
  local previewers = require("telescope.previewers")
  local buffer_previewer_maker = previewers.buffer_previewer_maker

  require("telescope").setup({
    defaults = {
      buffer_previewer_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        opts.preview = opts.preview or {}
        opts.preview.treesitter = false
        return buffer_previewer_maker(filepath, bufnr, opts)
      end,
    },
    pickers = {
      find_files = {
        previewer = false,
      },
    },
  })
  pcall(require("telescope").load_extension, "fzf")
end

return M
