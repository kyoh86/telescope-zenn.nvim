local actions = require'telescope.actions'
local from_entry = require'telescope.from_entry'

local A = {}

local function close_telescope_prompt(prompt_bufnr)
  local entry = actions.get_selected_entry(prompt_bufnr)
  actions.close(prompt_bufnr)
  return from_entry.path(entry)
end

-- open the target project
A.open = function(prompt_bufnr)
  local file = close_telescope_prompt(prompt_bufnr)
  require'telescope.builtin'.git_files{cwd = file}
end

return A
