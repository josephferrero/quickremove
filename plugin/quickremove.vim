" quickremove.nvim - Remove items from quickfix and location lists
" Plugin entry point

" Prevent loading the plugin twice
if exists('g:loaded_quickremove')
  finish
endif
let g:loaded_quickremove = 1

" Ensure Neovim version is compatible
if !has('nvim-0.7.0')
  echohl WarningMsg
  echom 'quickremove.nvim requires Neovim >= 0.7.0'
  echohl None
  finish
endif

" Auto-setup if not already configured
if !exists('g:quickremove_no_default_setup')
  lua require('quickremove').setup()
endif
