" quicker.nvim - Manage quickfix and location lists with ease
" Plugin entry point

" Prevent loading the plugin twice
if exists('g:loaded_quicker')
  finish
endif
let g:loaded_quicker = 1

" Ensure Neovim version is compatible
if !has('nvim-0.7.0')
  echohl WarningMsg
  echom 'quicker.nvim requires Neovim >= 0.7.0'
  echohl None
  finish
endif

" Auto-setup if not already configured
if !exists('g:quicker_no_default_setup')
  lua require('quicker').setup()
endif
