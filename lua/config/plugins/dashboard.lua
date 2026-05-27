local M = {}

local function reset_terminal(section)
  section.opts = section.opts or {}
  section.opts.redraw = true
  section.parent_id = nil
  section.wininfo = nil
end

function M.setup()
  if vim.fn.argc() > 0 then
    return
  end

  local alpha = require("alpha")
  require("alpha.term")
  local dashboard = require("alpha.themes.dashboard")
  local has_neofetch = vim.fn.executable("neofetch") == 1

  if has_neofetch then
    reset_terminal(dashboard.section.terminal)
    dashboard.section.terminal.command = "neofetch --color_blocks off"
    dashboard.section.terminal.width = 86
    dashboard.section.terminal.height = 18
    dashboard.section.header.val = {}
  else
    dashboard.section.header.val = {
      "neofetch is not installed",
    }
  end

  dashboard.section.buttons.val = {
    dashboard.button("f", "Find File", "<cmd>Telescope find_files<cr>"),
    dashboard.button("n", "New File", "<cmd>ene <bar> startinsert<cr>"),
    dashboard.button("R", "Projects", "<cmd>ProjectOpen<cr>"),
    dashboard.button("g", "Find Text", "<cmd>Telescope live_grep<cr>"),
    dashboard.button("r", "Recent Files", "<cmd>Telescope oldfiles<cr>"),
    dashboard.button("s", "Restore Session", "<cmd>lua require('persistence').load()<cr>"),
    dashboard.button("q", "Quit", "<cmd>qa<cr>"),
  }

  dashboard.opts.opts = dashboard.opts.opts or {}
  dashboard.opts.opts.keymap = dashboard.opts.opts.keymap or {}
  dashboard.opts.opts.keymap.press = { "<CR>", "<Space>" }

  local neofetch_section = has_neofetch and dashboard.section.terminal or dashboard.section.header
  local button_spacing = dashboard.section.buttons.opts.spacing or 0
  local dashboard_height = (has_neofetch and dashboard.section.terminal.height or #dashboard.section.header.val)
      + 2
      + #dashboard.section.buttons.val
      + (#dashboard.section.buttons.val * button_spacing)

  dashboard.opts.layout = {
    {
      type = "padding",
      val = function()
        return math.max(0, math.floor((vim.api.nvim_win_get_height(0) - dashboard_height) / 2))
      end,
    },
    neofetch_section,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
  }

  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaClosed",
    callback = function()
      reset_terminal(dashboard.section.terminal)
    end,
  })

  alpha.setup(dashboard.opts)
end

return M
