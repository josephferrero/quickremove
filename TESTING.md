# Testing quickremove.nvim

This file provides instructions for testing the plugin functionality.

## Setup for Testing

1. Install the plugin using your preferred method (see README.md)
2. Restart Neovim or source your configuration

## Manual Testing Steps

### Test 1: Basic Removal

1. Create a test quickfix list:
   ```vim
   :cexpr ['file1.txt:1:Error 1', 'file2.txt:2:Error 2', 'file3.txt:3:Error 3']
   :copen
   ```

2. Navigate to the second item (line 2)
3. Press `dd`
4. Verify that "Error 2" is removed and only 2 items remain

### Test 2: Visual Selection Removal

1. Create a test quickfix list with multiple items:
   ```vim
   :cexpr ['file1.txt:1:Line 1', 'file2.txt:2:Line 2', 'file3.txt:3:Line 3', 'file4.txt:4:Line 4', 'file5.txt:5:Line 5']
   :copen
   ```

2. Move to line 2
3. Enter visual mode with `V`
4. Select lines 2-4 with `2j`
5. Press `dd`
6. Verify that lines 2-4 are removed, leaving only 2 items

### Test 3: Clear All

1. Create a test quickfix list:
   ```vim
   :cexpr ['file1.txt:1:Test 1', 'file2.txt:2:Test 2']
   :copen
   ```

2. Run `:QuickRemoveClear`
3. Verify that the quickfix list is empty

### Test 4: Undo

1. Create a test quickfix list:
   ```vim
   :cexpr ['file1.txt:1:Item 1', 'file2.txt:2:Item 2', 'file3.txt:3:Item 3']
   :copen
   ```

2. Remove the first item with `dd`
3. Run `:QuickRemoveUndo`
4. Verify that all 3 items are restored

### Test 5: Range Command

1. Create a test quickfix list:
   ```vim
   :cexpr ['file1.txt:1:A', 'file2.txt:2:B', 'file3.txt:3:C', 'file4.txt:4:D', 'file5.txt:5:E']
   :copen
   ```

2. Run `:2,4QuickRemove`
3. Verify that items B, C, and D are removed

### Test 6: Location List

1. Create a test location list:
   ```vim
   :lexpr ['file1.txt:1:Loc 1', 'file2.txt:2:Loc 2', 'file3.txt:3:Loc 3']
   :lopen
   ```

2. Press `dd` on the second item
3. Verify that the location list item is removed

### Test 7: Cursor Position

1. Create a test quickfix list with 5 items
2. Move to item 3
3. Press `dd`
4. Verify cursor stays on line 3 (which is now the old item 4)

### Test 8: Edge Cases

**Empty List:**
1. Open quickfix: `:copen`
2. Try to remove with `dd`
3. Verify appropriate message is shown

**Single Item:**
1. Create single-item list: `:cexpr ['file.txt:1:Only']`
2. Open quickfix: `:copen`
3. Remove with `dd`
4. Verify list becomes empty

**Last Item:**
1. Create multi-item list
2. Navigate to last item
3. Remove with `dd`
4. Verify cursor moves to new last item

## Automated Testing

While this plugin doesn't include automated tests, you can create your own
test script:

```lua
-- test_quickremove.lua
local quickremove = require('quickremove')

-- Test setup
local function test_remove()
  vim.fn.setqflist({
    {filename = 'test1.txt', lnum = 1, text = 'Error 1'},
    {filename = 'test2.txt', lnum = 2, text = 'Error 2'},
    {filename = 'test3.txt', lnum = 3, text = 'Error 3'},
  })

  vim.cmd('copen')

  -- Remove second item
  vim.fn.cursor(2, 1)
  quickremove.remove()

  local qf_list = vim.fn.getqflist()
  assert(#qf_list == 2, 'Should have 2 items after removal')
  assert(qf_list[1].text == 'Error 1', 'First item should be Error 1')
  assert(qf_list[2].text == 'Error 3', 'Second item should be Error 3')

  print('✓ Test passed: Basic removal')
end

-- Run tests
pcall(test_remove)
```

## Expected Behavior

- **Notifications:** After each operation, you should see a notification indicating:
  - Number of items removed
  - Whether it was from quickfix or location list
  - Number of items remaining

- **Cursor Position:** The cursor should intelligently adjust after removal:
  - If you delete the current line, cursor moves to the line that takes its place
  - If you delete lines after the cursor, cursor position stays the same
  - If you delete lines before the cursor, cursor adjusts accordingly

- **List Type Detection:** The plugin should automatically detect whether you're
  in a quickfix or location list and operate on the correct one.

## Troubleshooting Tests

If tests fail:

1. Check Neovim version: `:version` (need >= 0.7.0)
2. Verify plugin is loaded: `:lua print(vim.inspect(require('quickremove')))`
3. Check for errors: `:messages`
4. Verify you're in a quickfix window: `:echo &filetype` (should be `qf`)
5. Check keymap conflicts: `:nmap dd` in a quickfix window

## Performance Testing

For large quickfix lists:

```vim
" Generate large quickfix list
:cexpr system('find ~ -type f 2>/dev/null | head -n 1000 | xargs -I{} echo "{}:1:Line"')
:copen

" Test removal performance
:normal! 500G
:normal dd

" Test visual selection performance
:normal! gg
:normal V100j
:normal dd
```

The operations should be instant even with thousands of items.
