local M = {}

local projects_file = vim.fn.stdpath("data") .. "/projects.json"

local function normalize_path(path)
  if path == nil or path == "" then
    path = vim.fn.getcwd()
  end

  path = vim.fn.expand(path)
  path = vim.fn.fnamemodify(path, ":p")
  return path:gsub("/$", "")
end

local function read_projects()
  if vim.fn.filereadable(projects_file) == 0 then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(projects_file), "\n"))
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  return decoded
end

local function write_projects(projects)
  vim.fn.mkdir(vim.fn.fnamemodify(projects_file, ":h"), "p")
  vim.fn.writefile(vim.split(vim.json.encode(projects), "\n"), projects_file)
end

function M.add(path)
  path = normalize_path(path)

  if vim.fn.isdirectory(path) == 0 then
    vim.notify("Project path is not a directory: " .. path, vim.log.levels.ERROR)
    return
  end

  local projects = read_projects()
  local next_projects = { path }

  for _, project in ipairs(projects) do
    if project ~= path then
      table.insert(next_projects, project)
    end
  end

  write_projects(next_projects)
  vim.notify("Project added: " .. path)
end

function M.open_project(path)
  path = normalize_path(path)

  if vim.fn.isdirectory(path) == 0 then
    vim.notify("Project path is not a directory: " .. path, vim.log.levels.ERROR)
    return
  end

  vim.cmd("cd " .. vim.fn.fnameescape(path))

  pcall(function()
    local api = require("nvim-tree.api")
    api.tree.change_root(path)
    api.tree.open()
  end)

  vim.notify("Project opened: " .. path)
end

function M.open()
  local projects = read_projects()

  if vim.tbl_isempty(projects) then
    vim.notify("No projects yet. Use :ProjectAdd or :ProjectAdd /path/to/project", vim.log.levels.WARN)
    return
  end

  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    lazy.load({ plugins = { "telescope.nvim" } })
  end

  local ok_telescope, pickers = pcall(require, "telescope.pickers")
  if ok_telescope then
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
      prompt_title = "Projects",
      finder = finders.new_table({ results = projects }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            M.open_project(selection.value)
          end
        end)

        return true
      end,
    }):find()

    return
  end

  vim.ui.select(projects, { prompt = "Projects" }, function(choice)
    if choice then
      M.open_project(choice)
    end
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("ProjectAdd", function(opts)
    M.add(opts.args)
  end, {
    nargs = "*",
    complete = "dir",
  })

  vim.api.nvim_create_user_command("ProjectOpen", function()
    M.open()
  end, {})
end

return M
