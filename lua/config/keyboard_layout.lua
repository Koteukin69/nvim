local M = {}

local layout = "--"
local running = false
local monitor_job

local query_script = table.concat({
  "for qdbus in qdbus6 qdbus; do",
  "  command -v \"$qdbus\" >/dev/null 2>&1 || continue",
  "  index=$(\"$qdbus\" org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getLayout 2>/dev/null || \"$qdbus\" org.kde.keyboard /Layouts getLayout 2>/dev/null)",
  "  layouts=$(\"$qdbus\" --literal org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getLayoutsList 2>/dev/null || \"$qdbus\" --literal org.kde.keyboard /Layouts getLayoutsList 2>/dev/null)",
  "  if [ -n \"$index\" ] && [ -n \"$layouts\" ]; then",
  "    printf 'kde_index=%s\\n' \"$index\"",
  "    printf 'kde_layouts=%s\\n' \"$layouts\"",
  "    exit 0",
  "  fi",
  "  \"$qdbus\" org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getCurrentLayout 2>/dev/null && exit 0",
  "  \"$qdbus\" org.kde.keyboard /Layouts getCurrentLayout 2>/dev/null && exit 0",
  "done",
  "if command -v fcitx5-remote >/dev/null 2>&1; then",
  "  fcitx5-remote -n 2>/dev/null && exit 0",
  "fi",
  "if command -v ibus >/dev/null 2>&1; then",
  "  ibus engine 2>/dev/null && exit 0",
  "fi",
  "if command -v xkblayout-state >/dev/null 2>&1; then",
  "  xkblayout-state print %s 2>/dev/null && exit 0",
  "fi",
}, "\n")

local monitor_script = table.concat({
  "if command -v dbus-monitor >/dev/null 2>&1; then",
  "  dbus-monitor --session \"type='signal',interface='org.kde.KeyboardLayouts',member='layoutChanged'\" 2>/dev/null",
  "fi",
}, "\n")

local function parse_kde_layout(value)
  local index = tonumber(value:match("kde_index=(%d+)"))
  if not index then
    return nil
  end

  local layouts = {}
  for code in value:gmatch('%(sss%)%s+"([^"]+)"') do
    layouts[#layouts + 1] = code
  end

  return layouts[index + 1]
end

local function normalize(value)
  local raw = value or ""
  value = (parse_kde_layout(raw) or raw):lower():gsub("^%s+", ""):gsub("%s+$", "")
  value = value:gsub("[\"'(),]", "")

  if value == "" then
    return nil
  end

  if value:match("ru") or value:match("russian") then
    return "ru"
  end

  if value:match("us") or value:match("en") or value:match("english") then
    return "en"
  end

  return value:match("^[%a_%-]+") or value
end

function M.update()
  if running then
    return
  end

  running = true

  local output = {}

  vim.fn.jobstart({ "sh", "-c", query_script }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      output = data or {}
    end,
    on_exit = function()
      running = false

      local next_layout = normalize(table.concat(output, " "))
      if not next_layout or next_layout == layout then
        return
      end

      layout = next_layout
      vim.schedule(function()
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.refresh({ place = { "statusline" } })
        else
          vim.cmd("redrawstatus")
        end
      end)
    end,
  })
end

local function start_monitor()
  if monitor_job then
    return
  end

  monitor_job = vim.fn.jobstart({ "sh", "-c", monitor_script }, {
    stdout_buffered = false,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        if line:match("layoutChanged") or line:match("uint32") then
          M.update()
          return
        end
      end
    end,
    on_exit = function()
      monitor_job = nil
    end,
  })

  if monitor_job <= 0 then
    monitor_job = nil
  end
end

function M.setup()
  if monitor_job then
    return
  end

  M.update()
  start_monitor()

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "FocusGained", "ModeChanged" }, {
    callback = M.update,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if monitor_job then
        vim.fn.jobstop(monitor_job)
        monitor_job = nil
      end
    end,
  })
end

function M.component()
  return layout
end

return M
