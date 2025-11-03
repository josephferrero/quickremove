-- Test suite for quickremove.nvim
-- Can be run with: nvim --headless -u tests/minimal_init.lua -c "lua require('tests.quickremove_spec')"

local M = {}

-- Test framework
local tests_passed = 0
local tests_failed = 0
local current_test = nil

local function test(name, fn)
  current_test = name
  local success, err = pcall(fn)
  if success then
    print('✓ ' .. name)
    tests_passed = tests_passed + 1
  else
    print('✗ ' .. name)
    print('  Error: ' .. tostring(err))
    tests_failed = tests_failed + 1
  end
  current_test = nil
end

local function assert_eq(actual, expected, msg)
  if actual ~= expected then
    local error_msg = msg or string.format('Expected %s, got %s', tostring(expected), tostring(actual))
    error(error_msg, 2)
  end
end

-- Setup
local quickremove = require('quickremove')
quickremove.setup()

print('=== QUICKREMOVE.NVIM TEST SUITE ===\n')

-- Test 1: Plugin loads
test('Plugin loads without errors', function()
  assert(quickremove ~= nil, 'quickremove module not loaded')
  assert(quickremove.setup ~= nil, 'setup function not found')
  assert(quickremove.remove ~= nil, 'remove function not found')
  assert(quickremove.undo ~= nil, 'undo function not found')
  assert(quickremove.clear ~= nil, 'clear function not found')
end)

-- Test 2: Commands registered
test('Commands are registered', function()
  local commands = vim.api.nvim_get_commands({})
  assert(commands.QuickRemove ~= nil, 'QuickRemove command not registered')
  assert(commands.QuickRemoveClear ~= nil, 'QuickRemoveClear command not registered')
  assert(commands.QuickRemoveUndo ~= nil, 'QuickRemoveUndo command not registered')
end)

-- Test 3: Basic removal from quickfix
test('Basic quickfix removal works', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = 'Error 1' },
    { filename = 'test2.txt', lnum = 2, text = 'Error 2' },
    { filename = 'test3.txt', lnum = 3, text = 'Error 3' },
  })
  vim.cmd('copen')
  vim.fn.cursor(2, 1)
  quickremove.remove_range(2, 2)
  local count = #vim.fn.getqflist()
  assert_eq(count, 2, 'Expected 2 items after removal')
  vim.cmd('cclose')
end)

-- Test 4: Undo works
test('Undo restoration works', function()
  vim.cmd('copen')
  quickremove.undo()
  local count = #vim.fn.getqflist()
  assert_eq(count, 3, 'Expected 3 items after undo')
  vim.cmd('cclose')
end)

-- Test 5: Multiple removals
test('Multiple sequential removals work', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = 'Test 1' },
    { filename = 'test2.txt', lnum = 2, text = 'Test 2' },
    { filename = 'test3.txt', lnum = 3, text = 'Test 3' },
    { filename = 'test4.txt', lnum = 4, text = 'Test 4' },
    { filename = 'test5.txt', lnum = 5, text = 'Test 5' },
  }, 'r')
  vim.cmd('copen')

  quickremove.remove_range(1, 1)
  assert_eq(#vim.fn.getqflist(), 4, 'Expected 4 items after first removal')

  quickremove.remove_range(1, 1)
  assert_eq(#vim.fn.getqflist(), 3, 'Expected 3 items after second removal')

  quickremove.remove_range(1, 1)
  assert_eq(#vim.fn.getqflist(), 2, 'Expected 2 items after third removal')

  vim.cmd('cclose')
end)

-- Test 6: Multiple undo levels
test('Multiple undo levels work', function()
  vim.cmd('copen')

  quickremove.undo()
  assert_eq(#vim.fn.getqflist(), 3, 'Expected 3 items after first undo')

  quickremove.undo()
  assert_eq(#vim.fn.getqflist(), 4, 'Expected 4 items after second undo')

  quickremove.undo()
  assert_eq(#vim.fn.getqflist(), 5, 'Expected 5 items after third undo')

  vim.cmd('cclose')
end)

-- Test 7: Range removal
test('Range removal works', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = '1' },
    { filename = 'test2.txt', lnum = 2, text = '2' },
    { filename = 'test3.txt', lnum = 3, text = '3' },
    { filename = 'test4.txt', lnum = 4, text = '4' },
    { filename = 'test5.txt', lnum = 5, text = '5' },
  }, 'r')
  vim.cmd('copen')

  quickremove.remove_range(2, 4)
  local count = #vim.fn.getqflist()
  assert_eq(count, 2, 'Expected 2 items after range removal')

  local items = vim.fn.getqflist()
  assert_eq(items[1].text, '1', 'First item should be "1"')
  assert_eq(items[2].text, '5', 'Second item should be "5"')

  vim.cmd('cclose')
end)

-- Test 8: Clear function
test('Clear function works', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = 'Test' },
    { filename = 'test2.txt', lnum = 2, text = 'Test' },
  }, 'r')
  vim.cmd('copen')

  quickremove.clear()
  assert_eq(#vim.fn.getqflist(), 0, 'List should be empty after clear')

  vim.cmd('cclose')
end)

-- Test 9: Undo after clear
test('Undo after clear restores list', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = 'Test 1' },
    { filename = 'test2.txt', lnum = 2, text = 'Test 2' },
  }, 'r')
  vim.cmd('copen')

  quickremove.clear()
  assert_eq(#vim.fn.getqflist(), 0, 'List should be empty after clear')

  quickremove.undo()
  assert_eq(#vim.fn.getqflist(), 2, 'Undo should restore cleared list')

  vim.cmd('cclose')
end)

-- Test 10: Location list support
test('Location list works', function()
  vim.fn.setloclist(0, {
    { filename = 'test1.txt', lnum = 1, text = 'Loc 1' },
    { filename = 'test2.txt', lnum = 2, text = 'Loc 2' },
    { filename = 'test3.txt', lnum = 3, text = 'Loc 3' },
  })
  vim.cmd('lopen')

  quickremove.remove_range(2, 2)
  local count = #vim.fn.getloclist(0)
  assert_eq(count, 2, 'Expected 2 items in location list')

  quickremove.undo()
  count = #vim.fn.getloclist(0)
  assert_eq(count, 3, 'Expected 3 items after undo')

  vim.cmd('lclose')
end)

-- Test 11: Empty list handling
test('Empty list handling works', function()
  vim.fn.setqflist({}, 'r')
  vim.cmd('copen')

  -- Should not crash on empty list
  quickremove.remove_range(1, 1)
  assert_eq(#vim.fn.getqflist(), 0, 'List should still be empty')

  vim.cmd('cclose')
end)

-- Test 12: Invalid range handling
test('Invalid range handling works', function()
  vim.fn.setqflist({
    { filename = 'test1.txt', lnum = 1, text = 'Test 1' },
    { filename = 'test2.txt', lnum = 2, text = 'Test 2' },
  }, 'r')
  vim.cmd('copen')

  -- Should not crash on out of bounds
  quickremove.remove_range(10, 20)
  -- List should be unchanged
  assert_eq(#vim.fn.getqflist(), 2, 'List should be unchanged')

  vim.cmd('cclose')
end)

-- Print summary
print('\n=== TEST SUMMARY ===')
print('Passed: ' .. tests_passed)
print('Failed: ' .. tests_failed)
print('Total:  ' .. (tests_passed + tests_failed))

if tests_failed == 0 then
  print('\n✓✓✓ ALL TESTS PASSED ✓✓✓')
  vim.cmd('qall!')
else
  print('\n✗✗✗ SOME TESTS FAILED ✗✗✗')
  vim.cmd('cquit')
end

return M
