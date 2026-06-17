require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<C-`>]],

  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,

  close_on_exit = true,
  persist_mode = true,

  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
  },
})

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
})
