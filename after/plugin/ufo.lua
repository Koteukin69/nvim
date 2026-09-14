vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

require("ufo").setup({
  provider_selector = function()
    return {
      "treesitter",
      "indent",
    }
  end,

  fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
    local first_line = vim.api.nvim_buf_get_lines(
      0,
      lnum - 1,
      lnum,
      false
    )[1]

    local last_line = vim.api.nvim_buf_get_lines(
      0,
      end_lnum - 1,
      end_lnum,
      false
    )[1]

    if not first_line then
      return virt_text
    end

    if not last_line or end_lnum == lnum then
      return {
        { truncate(first_line, width), "Normal" },
      }
    end

    local text = first_line .. "..." .. vim.trim(last_line)

    if vim.fn.strdisplaywidth(text) > width then
      text = truncate(text, width)
    end

    return {
      { text, "Normal" },
    }
  end,
})
