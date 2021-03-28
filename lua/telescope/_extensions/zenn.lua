local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require'telescope.finders'
local path = require'telescope.path'
local pickers = require'telescope.pickers'
local utils = require'telescope.utils'

local os_home = vim.loop.os_homedir()

local M = {}

local function is_readable(filepath)
  local fd = vim.loop.fs_open(filepath, 'r', 438)
  local result = fd and true or false
  if result then
    vim.loop.fs_close(fd)
  end
  return result
end

local function search_readme(dir)
  for _, name in pairs{'README', 'README.md', 'README.markdown'} do
    local filepath = dir .. path.separator .. name
    if is_readable(filepath) then
      return filepath
    end
  end
  return nil
end

local function search_doc(dir)
  local doc_path = vim.fn.join({dir, 'doc', '**', '*.txt'}, path.separator)
  local maybe_doc = vim.split(vim.fn.glob(doc_path), '\n')
  for _, filepath in pairs(maybe_doc) do
    if is_readable(filepath) then
      return filepath
    end
  end
  return nil
end

local function gen_from_zenn(opts)
  local displayer = entry_display.create{
    items = {{}},
  }

  local function make_display(entry)
    return displayer{entry.slug .. ':\t' .. entry.title}
  end

  return function(line)
    local entry = vim.fn.json_decode(line)
    return {
      title = entry.title,
      slug = entry.slug,
      ordinal = entry.title,
      filename = path.normalize('articles' .. path.separator .. entry.slug .. '.md', opts.cwd),
      display = make_display,
    }
  end
end

M.articles = function(opts)
  if not opts then
    opts = {}
  end
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.fn.getcwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_zenn, opts)

  local results = utils.get_os_command_output(
    {'npx', 'zenn', 'list:articles', '--format', 'json'},
    opts.cwd
  )
  pickers.new(opts, {
    prompt_title = 'Articles in zenn',
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker,
    },
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return require('telescope').register_extension{
  exports = {
    articles = M.articles
  },
}
