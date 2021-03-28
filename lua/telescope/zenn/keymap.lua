local module = 'telescope.zenn.keymap'

local function load_package()
  return vim.fn.json_decode(vim.fn.readfile('package.json'))
end

local function has_zenn()
  local ok, package = pcall(load_package)
  if not ok then
    return false
  end
  return (package["dependencies"] or {})["zenn-cli"] ~= nil
end

local function set()
  local key = vim.g['telescope#zenn#_key_articles']
  if not key then
    return
  end
  if has_zenn() then
    vim.api.nvim_set_keymap('n', key, '<cmd>Telescope zenn articles<cr>', { noremap = true, silent = true })
  else
    pcall(function() vim.api.nvim_del_keymap('n', key) end)
  end
end

local function articles(key)
  vim.g['telescope#zenn#_key_articles'] = key
  vim.cmd('augroup telescope.zenn')
  vim.cmd('autocmd!')
  vim.cmd('autocmd DirChanged * lua require("' .. module .. '").set()')
  vim.cmd('augroup end')
  set()
end

return {
  set = set,
  articles = articles,
}
