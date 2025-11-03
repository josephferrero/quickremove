# quickremove.nvim

A Neovim plugin that allows you to remove items from the quickfix and location lists interactively.

## Features

- 🗑️ Remove individual items from quickfix/location lists with `dd`
- 📦 Remove multiple items using visual selection
- ↩️ Undo removals with full undo history (up to 50 levels)
- 🧹 Clear all items from the list
- ⚙️ Customizable keymaps
- 🎯 Works seamlessly with both quickfix and location lists
- 🚀 Zero dependencies, pure Lua implementation

## Why?

The quickfix and location lists in Neovim are powerful tools for navigating search results, compilation errors, and diagnostic messages. However, once populated, you cannot easily remove items you've already addressed or that aren't relevant. This plugin fills that gap, making your workflow more efficient.

## Requirements

- Neovim >= 0.7.0

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'josephferrero/quickremove.nvim',
  config = function()
    require('quickremove').setup({
      -- Optional: customize keymaps
      keymaps = {
        remove = 'dd',      -- Remove current item or visual selection
        remove_range = 'x', -- Alternative keymap
      },
    })
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'josephferrero/quickremove.nvim',
  config = function()
    require('quickremove').setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'josephferrero/quickremove.nvim'

" In your init.vim or after plug#end()
lua << EOF
require('quickremove').setup()
EOF
```

### Manual Installation

Clone the repository into your Neovim plugin directory:

```bash
git clone https://github.com/josephferrero/quickremove.nvim ~/.local/share/nvim/site/pack/plugins/start/quickremove.nvim
```

## Usage

### Default Keymaps

When you open a quickfix or location list window, the following keymaps are automatically available:

| Mode   | Keymap | Action                                  |
| ------ | ------ | --------------------------------------- |
| Normal | `dd`   | Remove the current item                 |
| Visual | `dd`   | Remove all selected items               |
| Normal | `x`    | Remove the current item (alternative)   |
| Visual | `x`    | Remove all selected items (alternative) |

### Commands

The plugin provides the following commands:

| Command             | Description                                                |
| ------------------- | ---------------------------------------------------------- |
| `:QuickRemove`      | Remove items in the given range (e.g., `:5,10QuickRemove`) |
| `:QuickRemoveClear` | Clear all items from the current list                      |
| `:QuickRemoveUndo`  | Undo the last removal (can be called multiple times)       |

### Example Workflow

1. Open a quickfix list (e.g., `:grep "TODO" **/*.lua`)
2. Navigate to an item you want to remove
3. Press `dd` to remove it
4. Select multiple items in visual mode and press `dd` to remove them all
5. If you make a mistake, use `:QuickRemoveUndo` to undo the last removal (supports up to 50 undo levels)

### Visual Selection Examples

```
" Remove items 5-10
:5,10QuickRemove

" In visual mode, select lines and press dd
V5j  " Select 6 lines
dd   " Remove them

" Remove all remaining items
:QuickRemoveClear
```

## Configuration

### Default Configuration

```lua
require('quickremove').setup({
  keymaps = {
    remove = 'dd',      -- Remove current item or visual selection
    remove_range = 'x', -- Alternative keymap for removal
  },
  -- Whether to automatically set up keymaps
  auto_setup_keymaps = true,
})
```

### Custom Configuration Examples

#### Disable Auto Keymaps

If you prefer to set up your own keymaps:

```lua
require('quickremove').setup({
  auto_setup_keymaps = false,
})

-- Set up your own keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<leader>qd', function()
      require('quickremove').remove()
    end, { buffer = bufnr, desc = 'Remove quickfix item' })
  end,
})
```

#### Change Default Keymaps

```lua
require('quickremove').setup({
  keymaps = {
    remove = '<leader>d',
    remove_range = '<leader>x',
  },
})
```

#### Disable Plugin Auto-Setup

If you want full control over when the plugin is initialized:

```vim
" In your init.vim
let g:quickremove_no_default_setup = 1
```

```lua
-- Then manually call setup in your Lua config
require('quickremove').setup()
```

## API

For advanced users, the plugin exposes the following Lua API:

```lua
local quickremove = require('quickremove')

-- Remove current item or visual selection
quickremove.remove()

-- Remove items by line range
quickremove.remove_range(start_line, end_line)

-- Clear all items from the list
quickremove.clear()

-- Undo the last removal
quickremove.undo()

-- Setup keymaps manually
quickremove.setup_keymaps()
```

## How It Works

- When you open a quickfix or location list, the plugin saves the original list
- When you remove items, it creates a new list without those items and updates the display
- The cursor position is automatically adjusted to stay in a sensible location
- You can undo removals one at a time using `:QuickRemoveUndo` (supports up to 50 undo levels)

## Troubleshooting

### Keymaps Not Working

1. Make sure you're in a quickfix or location list window (`:echo &filetype` should show `qf`)
2. Check that another plugin isn't overriding the keymaps
3. Try setting custom keymaps in your configuration

### Plugin Not Loading

1. Ensure you're running Neovim >= 0.7.0 (`:version`)
2. Verify the plugin is installed correctly (`:Lazy` or `:PackerStatus`)
3. Check for errors in `:messages`

## Development

### Running Tests

The plugin includes a comprehensive test suite:

```bash
# Run all tests
make test

# Or directly
./tests/run_tests.sh
```

See [tests/README.md](tests/README.md) for more information about testing.

### Making Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run the test suite: `make test`
5. Submit a pull request

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

When contributing code:
- Ensure all tests pass
- Add tests for new features
- Follow the existing code style
- Update documentation as needed

## License

MIT License - see LICENSE file for details

## Related Plugins

- [trouble.nvim](https://github.com/folke/trouble.nvim) - A pretty list for diagnostics and more
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Better quickfix window

## Acknowledgments

Inspired by the need for better quickfix list management in Neovim.
