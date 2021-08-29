local conf = require "telescope.config".values
local entry_display = require "telescope.pickers.entry_display"
local finders = require "telescope.finders"
local Path = require "plenary.path"
local pickers = require "telescope.pickers"
local utils = require "telescope.utils"

local M = {}

local function gen_from_zenn(opts)
  local displayer =
    entry_display.create {
    items = {{}}
  }

  local function make_display(entry)
    return displayer {entry.slug .. ":\t" .. entry.title}
  end

  return function(line)
    local entry = vim.fn.json_decode(line)
    return {
      title = entry.title,
      slug = entry.slug,
      ordinal = entry.title,
      filename = Path:new({"articles", entry.slug .. ".md"}):normalize(opts.cwd),
      display = make_display
    }
  end
end

M.articles = function(opts)
  if not opts then
    opts = {}
  end
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.fn.getcwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_zenn, opts)

  local results = utils.get_os_command_output({"npx", "zenn", "list:articles", "--format", "json"}, opts.cwd)
  pickers.new(
    opts,
    {
      prompt_title = "Articles in zenn",
      finder = finders.new_table {
        results = results,
        entry_maker = opts.entry_maker
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts)
    }
  ):find()
end

return require("telescope").register_extension {
  exports = {
    articles = M.articles
  }
}
