# accidentslipt.nvim


https://github.com/SomesOver/accidentslipt/assets/160035610/2c8ad939-bb42-4a45-997b-a164e2c43108
> configurable window separtor

## Motivation

Currently in Neovim, we can not make the active window distinguishable via the window separator.
This plugin will color the border of active window, like what tmux does for its different panes.

## Requirements

+ Neovim 0.8.3+
+ [Nerd Fonts](https://www.nerdfonts.com/)

## Install
### Using a plugin manager

Using vim-plug:

```lua
Plug 'SomesOver/accidentslipt'
```

Using Packer.nvim:

```lua
use {
    "SomesOver/accidentslipt",
    config = function ()
        require('accidentslipt').setup()
    end
}
```

Using lazy.nvim

```lua
{
  "SomesOver/accidentslipt",
  config = true,
  event = { "WinNew" },
}
```

## Default configuration

```lua
require("accidentslipt").setup({
  -- highlight for Window separator
  hi = {
    bg = "#16161E",
    fg = "#1F3442",
  },
  -- This plugin will not be activated for filetype in the following table.
  no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
  -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
  symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
  anchor = {
	left = { height = 1, x = -1, y = -1 },
	right = { height = 1, x = -1, y = 0 },
	up = { width = 0, x = -1, y = 0 },
    bottom = { width = 0, x = 1, y = 0 },
 },
})
```


## License

This plugin is released under the MIT License.
# accidentslipt
