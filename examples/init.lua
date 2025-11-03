-- Example configuration for quickremove.nvim

-- Basic setup with defaults
require('quickremove').setup()

-- Custom configuration
require('quickremove').setup({
  keymaps = {
    remove = 'dd', -- Remove current item or selection
    remove_range = 'x', -- Alternative removal keymap
  },
  auto_setup_keymaps = true,
})

-- Advanced: Disable auto keymaps and set up manually
require('quickremove').setup({
  auto_setup_keymaps = false,
})

-- Set up custom keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local quickremove = require('quickremove')

    -- Custom keymap: leader+d to remove
    vim.keymap.set('n', '<leader>qd', function()
      quickremove.remove()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Remove quickfix item',
    })

    -- Custom keymap: leader+c to clear all
    vim.keymap.set('n', '<leader>qc', function()
      quickremove.clear()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Clear quickfix list',
    })

    -- Custom keymap: leader+u to undo
    vim.keymap.set('n', '<leader>qu', function()
      quickremove.undo()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Undo quickfix removals',
    })
  end,
})

-- Example: Use with lazy.nvim
-- {
--   'josephferrero/quickremove.nvim',
--   event = 'VeryLazy',
--   config = function()
--     require('quickremove').setup({
--       keymaps = {
--         remove = 'dd',
--         remove_range = 'x',
--       },
--     })
--   end,
-- }

-- Example: Use with packer.nvim
-- use {
--   'josephferrero/quickremove.nvim',
--   config = function()
--     require('quickremove').setup()
--   end
-- }
