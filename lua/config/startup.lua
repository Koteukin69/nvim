if vim.fn.argc() == 0 then
  local default_project_dir = vim.fn.expand("~/Documents/GitHub")

  if vim.fn.isdirectory(default_project_dir) == 1 then
    vim.cmd("cd " .. vim.fn.fnameescape(default_project_dir))
  end
end
