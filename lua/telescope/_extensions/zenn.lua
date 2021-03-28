local actions = require'telescope.actions'
local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local path = require'telescope.path'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local utils = require'telescope.utils'
local zenn_a = require'telescope._extensions.zenn_actions'
local zenn_c = require'telescope._extensions.zenn_config'

local os_home = vim.loop.os_homedir()

local M = {}

local config = zenn_c.default()

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
    local filepath = dir..path.separator..name
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
  opts = zenn_c.merge(config, opts or {})
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.fn.getcwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_zenn, opts)

  local results = utils.get_os_command_output(
    opts.cmd,
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
  setup = function(ext_config)
    config = zenn_c.merge(config, ext_config)
  end,
  exports = {
    articles = M.articles
  },
}
