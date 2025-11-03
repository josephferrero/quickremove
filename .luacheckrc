-- Luacheck configuration for quickremove.nvim

-- Ignore vim global
globals = {
  "vim",
}

-- Read access to globals
read_globals = {
  "vim",
}

-- Ignore certain warnings
ignore = {
  "212", -- Unused argument
  "631", -- Line is too long
}

-- Exclude directories
exclude_files = {
  ".git/",
  "doc/",
}
