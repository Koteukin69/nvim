local ok, alpha = pcall(require, "alpha")
if not ok then
  return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "NVIM",
}

dashboard.section.buttons.val = {
  dashboard.button("f", "Find file", "<cmd>Telescope find_files<cr>"),
  dashboard.button("r", "Recent files", "<cmd>Telescope oldfiles<cr>"),
  dashboard.button("n", "New file", "<cmd>enew<cr>"),
  dashboard.button("c", "Config", "<cmd>edit ~/.config/nvim/init.lua<cr>"),
  dashboard.button("q", "Quit", "<cmd>qa<cr>"),
}

dashboard.section.footer.val = ""

dashboard.config.layout = {
  {
    type = "group",
    val = {
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
    },
    opts = {
      position = "v_center",
    },
  },
}

alpha.setup(dashboard.config)
