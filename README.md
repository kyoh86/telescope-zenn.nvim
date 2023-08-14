# telescope-zenn.nvim

I'm no longer using telescope. So active development has decelerated on the repository, and I'm predominantly addressing bug fixes.

`telescope-zenn` is an extension for
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that
provides its users with operating [zenn.dev](https://zenn.dev).

![](https://user-images.githubusercontent.com/5582459/112757542-1eceef80-9025-11eb-8940-02c0776c11c8.gif)

## Config

```lua
require('telescope').load_extension('zenn')
```

## Usage

### articles

`:Telescope zenn articles`
Listup articles and edit it with an enter key.

## Call it with keymap

```vim
nnoremap <silent> <leader>fza <cmd>Telescope zenn articles<cr>
```

You can use `kyoh86/vim-zenn-autocmd` to enable/disable map when enter into/leave from zenn directory.

```vim
call zenn_autocmd#enable()
augroup my-zenn-autocmd
  autocmd!
  autocmd User ZennEnter nnoremap <silent> <leader>fza <cmd>Telescope zenn articles<cr>
  autocmd User ZennLeave silent! unnmap! <leader>fza
augroup end
```

# LICENSE

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg)](http://www.opensource.org/licenses/MIT)

This is distributed under the [MIT License](http://www.opensource.org/licenses/MIT).
