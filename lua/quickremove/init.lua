-- quickremove.nvim - Remove items from quickfix and location lists
-- Main module

local M = {}

-- Default configuration
M.config = {
  -- Keymaps for quickfix/loclist windows
  keymaps = {
    remove = 'dd',      -- Remove current item or visual selection
    remove_range = 'x', -- Alternative keymap for removal
  },
  -- Whether to automatically set up keymaps
  auto_setup_keymaps = true,
}

-- Internal state
local original_qf_list = {}
local original_loc_list = {}

--- Check if current window is a quickfix or location list window
--- @return string|nil 'qf' for quickfix, 'loc' for location list, nil for neither
local function get_list_type()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
  if not wininfo then
    return nil
  end

  if wininfo.quickfix == 1 then
    if wininfo.loclist == 1 then
      return 'loc'
    else
      return 'qf'
    end
  end

  return nil
end

--- Get the current quickfix or location list
--- @param list_type string 'qf' or 'loc'
--- @return table List items
local function get_list(list_type)
  if list_type == 'qf' then
    return vim.fn.getqflist()
  elseif list_type == 'loc' then
    return vim.fn.getloclist(0)
  end
  return {}
end

--- Set the quickfix or location list
--- @param list_type string 'qf' or 'loc'
--- @param items table List items
--- @param action string Action to perform ('r' for replace)
local function set_list(list_type, items, action)
  action = action or 'r'
  if list_type == 'qf' then
    vim.fn.setqflist(items, action)
  elseif list_type == 'loc' then
    vim.fn.setloclist(0, items, action)
  end
end

--- Remove items from the list by line numbers
--- @param start_line number Starting line number (1-indexed)
--- @param end_line number Ending line number (1-indexed)
local function remove_items(start_line, end_line)
  local list_type = get_list_type()

  if not list_type then
    vim.notify('quickremove: Not in a quickfix or location list window', vim.log.levels.WARN)
    return
  end

  -- Get current list
  local items = get_list(list_type)

  if #items == 0 then
    vim.notify('quickremove: List is empty', vim.log.levels.INFO)
    return
  end

  -- Validate line numbers
  if start_line < 1 or start_line > #items then
    vim.notify('quickremove: Invalid line number', vim.log.levels.ERROR)
    return
  end

  if end_line < start_line or end_line > #items then
    end_line = start_line
  end

  -- Save cursor position
  local cursor_pos = vim.fn.line('.')

  -- Create new list without the removed items
  local new_items = {}
  for i, item in ipairs(items) do
    if i < start_line or i > end_line then
      table.insert(new_items, item)
    end
  end

  -- Update the list
  set_list(list_type, new_items, 'r')

  -- Calculate new cursor position
  local new_cursor_pos = cursor_pos
  if cursor_pos >= start_line and cursor_pos <= end_line then
    -- Cursor was on a deleted line, move to the line that took its place
    new_cursor_pos = math.min(start_line, #new_items)
  elseif cursor_pos > end_line then
    -- Cursor was after deleted lines, adjust for removed items
    new_cursor_pos = cursor_pos - (end_line - start_line + 1)
  end

  -- Restore cursor position
  if #new_items > 0 then
    vim.fn.cursor(new_cursor_pos, 1)
  end

  -- Notify user
  local count = end_line - start_line + 1
  local msg = string.format(
    'quickremove: Removed %d item%s from %s list (%d remaining)',
    count,
    count == 1 and '' or 's',
    list_type == 'qf' and 'quickfix' or 'location',
    #new_items
  )
  vim.notify(msg, vim.log.levels.INFO)
end

--- Remove the current item or visual selection
M.remove = function()
  -- Get the range (works for both normal and visual mode)
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')

  -- Ensure start_line <= end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  remove_items(start_line, end_line)
end

--- Remove items by range (for command mode)
--- @param line1 number Starting line
--- @param line2 number Ending line
M.remove_range = function(line1, line2)
  remove_items(line1, line2)
end

--- Undo the last removal (restore original list)
M.undo = function()
  local list_type = get_list_type()

  if not list_type then
    vim.notify('quickremove: Not in a quickfix or location list window', vim.log.levels.WARN)
    return
  end

  local original = list_type == 'qf' and original_qf_list or original_loc_list

  if #original == 0 then
    vim.notify('quickremove: No original list to restore', vim.log.levels.WARN)
    return
  end

  set_list(list_type, original, 'r')
  vim.notify('quickremove: Restored original list', vim.log.levels.INFO)
end

--- Save the current list as the original (for undo functionality)
M.save_original = function()
  local list_type = get_list_type()

  if not list_type then
    return
  end

  local items = get_list(list_type)

  if list_type == 'qf' then
    original_qf_list = vim.deepcopy(items)
  elseif list_type == 'loc' then
    original_loc_list = vim.deepcopy(items)
  end
end

--- Clear all items from the current list
M.clear = function()
  local list_type = get_list_type()

  if not list_type then
    vim.notify('quickremove: Not in a quickfix or location list window', vim.log.levels.WARN)
    return
  end

  set_list(list_type, {}, 'r')

  local list_name = list_type == 'qf' and 'quickfix' or 'location'
  vim.notify(string.format('quickremove: Cleared %s list', list_name), vim.log.levels.INFO)
end

--- Setup keymaps for quickfix/loclist windows
M.setup_keymaps = function()
  local config = M.config

  -- Create an autocommand group
  local group = vim.api.nvim_create_augroup('QuickRemove', { clear = true })

  -- Set up keymaps when entering quickfix or location list
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'qf',
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()

      -- Save original list when opening
      M.save_original()

      -- Normal mode keymap
      if config.keymaps.remove then
        vim.keymap.set('n', config.keymaps.remove, function()
          M.remove()
        end, {
          buffer = bufnr,
          silent = true,
          desc = 'Remove current item from list',
        })
      end

      -- Visual mode keymap
      if config.keymaps.remove then
        vim.keymap.set('v', config.keymaps.remove, function()
          M.remove()
        end, {
          buffer = bufnr,
          silent = true,
          desc = 'Remove selected items from list',
        })
      end

      -- Alternative keymap
      if config.keymaps.remove_range then
        vim.keymap.set('n', config.keymaps.remove_range, function()
          M.remove()
        end, {
          buffer = bufnr,
          silent = true,
          desc = 'Remove current item from list',
        })

        vim.keymap.set('v', config.keymaps.remove_range, function()
          M.remove()
        end, {
          buffer = bufnr,
          silent = true,
          desc = 'Remove selected items from list',
        })
      end
    end,
  })
end

--- Setup the plugin with user configuration
--- @param opts table|nil Configuration options
M.setup = function(opts)
  -- Merge user config with defaults
  if opts then
    M.config = vim.tbl_deep_extend('force', M.config, opts)
  end

  -- Setup keymaps if enabled
  if M.config.auto_setup_keymaps then
    M.setup_keymaps()
  end

  -- Create user commands
  vim.api.nvim_create_user_command('QuickRemove', function(cmd_opts)
    M.remove_range(cmd_opts.line1, cmd_opts.line2)
  end, {
    range = true,
    desc = 'Remove items from quickfix/location list',
  })

  vim.api.nvim_create_user_command('QuickRemoveClear', function()
    M.clear()
  end, {
    desc = 'Clear all items from quickfix/location list',
  })

  vim.api.nvim_create_user_command('QuickRemoveUndo', function()
    M.undo()
  end, {
    desc = 'Restore original quickfix/location list',
  })
end

return M
