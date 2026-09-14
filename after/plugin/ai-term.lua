local Terminal = require("toggleterm.terminal").Terminal

local term

local function close_map(t)
  vim.keymap.set({ "n", "t" }, [[<C-`>]], function()
    t:close()
  end, { buffer = t.bufnr, silent = true, desc = "Close Claude" })

  -- глобальный <Esc> из toggleterm.lua выходит из terminal mode; здесь отдаём его в claude
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = t.bufnr, noremap = true, silent = true })
end

local function alive()
  return term and term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr)
end

local function toggle_claude()
  if alive() and term:is_open() then
    term:close()
    return
  end

  local cwd = vim.fn.getcwd()

  -- терминал привязан к каталогу, в котором создан: при смене проекта делаем новый
  if alive() and term.dir ~= cwd then
    term:shutdown()
  end

  if not alive() then
    term = Terminal:new({
      cmd = "claude",
      dir = cwd,
      count = 99, -- вне диапазона обычных терминалов
      hidden = true,
      direction = "float",
      on_create = close_map,
    })
  end

  term:open()
end

vim.keymap.set("n", "<leader>o", toggle_claude, { desc = "Toggle Claude" })
