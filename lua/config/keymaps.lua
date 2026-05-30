vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-w>", "<cmd>bdelete<cr>", { desc = "Delete buffer", nowait = true })
vim.keymap.set("n", "<C-p>", function()
  require("config.features.projects").open()
end, { desc = "Open project" })

local mouse_click_passthrough_fts = {
  NvimTree = true,
  neo_tree = true,
  ["neo-tree"] = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  lazy = true,
  mason = true,
  help = true,
  [""] = false,
}

local function should_passthrough_left_click()
  local mouse_pos = vim.fn.getmousepos()
  if mouse_pos.winid == 0 then
    return true
  end

  local bufnr = vim.api.nvim_win_get_buf(mouse_pos.winid)
  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" then
    return true
  end

  return mouse_click_passthrough_fts[vim.bo[bufnr].filetype] == true
end

-- Prevent accidental touchpad taps from moving the cursor in normal file buffers.
vim.keymap.set("n", "<LeftMouse>", function()
  if should_passthrough_left_click() then
    return "<LeftMouse>"
  end
  return "<Ignore>"
end, { expr = true, silent = true, desc = "Ignore accidental left click in file buffers" })

vim.keymap.set("n", "<LeftDrag>", function()
  if should_passthrough_left_click() then
    return "<LeftDrag>"
  end
  return "<LeftDrag>"
end, { expr = true, silent = true, desc = "Keep drag selection in file buffers" })
