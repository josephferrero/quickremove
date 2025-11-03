-- Minimal init file for testing
-- Sets up the plugin path without loading user config

-- Add the plugin to runtimepath
local plugin_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
vim.opt.runtimepath:append(plugin_dir)

-- Disable swapfile and other unnecessary features for testing
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Set up a clean environment
vim.opt.compatible = false
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')
