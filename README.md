# telescope-zenn.nvim

`telescope-zenn` is an extension for
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that
provides its users with operating [zenn.dev](https://zenn.dev).

## Installation

```lua
use{
  'nvim-telescope/telescope-zenn.nvim',
  config = function()
    require('telescope').load_extension('zenn')
    require('telescope.zenn.keymap').articles('<leader>a') -- set keymap `<leader>a` for `:Telescope zenn articles`
  end,
}
```

## Usage

### articles

`:Telescope zenn articles`
Listup articles and edit it with an enter key.

# LICENSE

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg)](http://www.opensource.org/licenses/MIT)

This is distributed under the [MIT License](http://www.opensource.org/licenses/MIT).
