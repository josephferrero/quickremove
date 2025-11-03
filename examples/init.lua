-- Example configuration for quicker.nvim

-- Basic setup with defaults
require('quicker').setup()

-- Custom configuration
require('quicker').setup({
  keymaps = {
    remove = 'dd', -- Remove current item or selection
    remove_range = 'x', -- Alternative removal keymap
  },
  auto_setup_keymaps = true,
})

-- Advanced: Disable auto keymaps and set up manually
require('quicker').setup({
  auto_setup_keymaps = false,
})

-- Set up custom keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local quicker = require('quicker')

    -- Custom keymap: leader+d to remove
    vim.keymap.set('n', '<leader>qd', function()
      quicker.remove()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Remove quickfix item',
    })

    -- Custom keymap: leader+c to clear all
    vim.keymap.set('n', '<leader>qc', function()
      quicker.clear()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Clear quickfix list',
    })

    -- Custom keymap: leader+u to undo
    vim.keymap.set('n', '<leader>qu', function()
      quicker.undo()
    end, {
      buffer = bufnr,
      silent = true,
      desc = 'Undo quickfix removals',
    })
  end,
})

-- Example: Use with lazy.nvim
-- {
--   'josephferrero/quicker.nvim',
--   event = 'VeryLazy',
--   config = function()
--     require('quicker').setup({
--       keymaps = {
--         remove = 'dd',
--         remove_range = 'x',
--       },
--     })
--   end,
-- }

-- Example: Use with packer.nvim
-- use {
--   'josephferrero/quicker.nvim',
--   config = function()
--     require('quicker').setup()
--   end
-- }
