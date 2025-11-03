# Quick Start Guide

Get up and running with quickremove.nvim in 5 minutes.

## Installation

### Option 1: lazy.nvim (Recommended)

Add to your `~/.config/nvim/lua/plugins/quickremove.lua`:

```lua
return {
  'josephferrero/quickremove.nvim',
  config = function()
    require('quickremove').setup()
  end,
}
```

Or add to your existing plugin list in `init.lua`:

```lua
{
  'josephferrero/quickremove.nvim',
  config = function()
    require('quickremove').setup()
  end,
}
```

Then run `:Lazy sync`

### Option 2: packer.nvim

Add to your `~/.config/nvim/lua/plugins.lua`:

```lua
use {
  'josephferrero/quickremove.nvim',
  config = function()
    require('quickremove').setup()
  end
}
```

Then run `:PackerSync`

### Option 3: vim-plug

Add to your `~/.config/nvim/init.vim`:

```vim
Plug 'josephferrero/quickremove.nvim'
```

And in your config (after `plug#end()`):

```vim
lua << EOF
require('quickremove').setup()
EOF
```

Then run `:PlugInstall`

### Option 4: Manual Installation

```bash
cd ~/data/personal/quickremove
./install.sh
```

## First Test

1. Open Neovim
2. Create a test quickfix list:
   ```vim
   :cexpr ['file1.txt:1:Error 1', 'file2.txt:2:Error 2', 'file3.txt:3:Error 3']
   ```
3. Open quickfix window:
   ```vim
   :copen
   ```
4. Navigate to line 2
5. Press `dd`
6. Watch line 2 disappear!

## Basic Usage

| Action                | Keys                | Description                  |
| --------------------- | ------------------- | ---------------------------- |
| Remove current item   | `dd`                | Delete the line under cursor |
| Remove multiple items | `Vjj` then `dd`     | Select 3 lines, delete them  |
| Remove with range     | `:2,5QuickRemove`   | Delete lines 2-5             |
| Clear all             | `:QuickRemoveClear` | Remove everything            |
| Undo removals         | `:QuickRemoveUndo`  | Restore original list        |

## Real Example

Try this common workflow:

```vim
" Search for all TODOs in your project
:grep "TODO" **/*.lua

" Open the quickfix list
:copen

" Remove TODOs you've completed or don't care about
" Just navigate to each one and press 'dd'

" Or select multiple and delete them
Vjjj  " Select 4 lines
dd    " Remove them

" Made a mistake? Undo it
:QuickRemoveUndo
```

## Configuration

### Customize Keymaps

```lua
require('quickremove').setup({
  keymaps = {
    remove = '<leader>d',  -- Use leader+d instead of dd
    remove_range = '<leader>x',
  },
})
```

### Disable Auto Keymaps

```lua
require('quickremove').setup({
  auto_setup_keymaps = false,  -- Don't set up keymaps automatically
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

## Common Workflows

### Workflow 1: Filtering Grep Results

```vim
:grep "function" src/**/*.lua
:copen
" Use dd to remove functions you don't care about
" Keep only the ones you want to refactor
```

### Workflow 2: Cleaning Up LSP Diagnostics

```vim
:lua vim.diagnostic.setqflist()
:copen
" Remove warnings you want to ignore
" Focus only on errors
```

### Workflow 3: Progressive TODO List

```vim
:grep "TODO" **/*
:copen
" As you complete each TODO, remove it with dd
" Your quickfix list becomes your TODO tracker
```

## Getting Help

- `:help quickremove` - Full documentation
- `:help quickremove-commands` - Command reference
- `:help quickremove-api` - API documentation

Or read the markdown docs:

- `README.md` - Complete documentation
- `DEMO.md` - Visual examples
- `TESTING.md` - How to test the plugin

## Troubleshooting

### Keymaps not working?

Check you're in a quickfix window:

```vim
:echo &filetype
" Should show: qf
```

### Plugin not loading?

Check your Neovim version:

```vim
:version
" Need Neovim >= 0.7.0
```

### Still stuck?

Check for errors:

```vim
:messages
```

## Next Steps

- Read the full README: `README.md`
- Try the demos: `DEMO.md`
- Explore configuration options
- Share with your team!

## Quick Reference Card

```
╔════════════════════════════════════════════╗
║       quickremove.nvim Quick Reference      ║
╠════════════════════════════════════════════╣
║ NORMAL MODE                                ║
║   dd             Remove current item       ║
║   x              Remove current item (alt) ║
║                                            ║
║ VISUAL MODE                                ║
║   dd             Remove selected items     ║
║   x              Remove selected items     ║
║                                            ║
║ COMMANDS                                   ║
║   :QuickRemove           Remove range      ║
║   :QuickRemoveClear      Clear all         ║
║   :QuickRemoveUndo       Restore original  ║
║                                            ║
║ EXAMPLES                                   ║
║   Vjj dd         Remove 3 lines            ║
║   :5,10QuickRemove  Remove lines 5-10      ║
║   ggVG dd        Remove all (or :Clear)    ║
╚════════════════════════════════════════════╝
```

---

**That's it! You're ready to use quickremove.nvim.**

For more details, see the [full README](README.md).
