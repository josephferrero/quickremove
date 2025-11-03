# Changelog

All notable changes to quickremove.nvim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial release of quickremove.nvim
- Remove individual items from quickfix/location lists with `dd`
- Remove multiple items using visual selection
- `:QuickRemove` command for range-based removal
- `:QuickRemoveClear` command to clear all items
- `:QuickRemoveUndo` command to restore original list
- Automatic keymap setup for quickfix/location list windows
- Configurable keymaps
- Smart cursor positioning after removal
- Support for both quickfix and location lists
- Lua API for programmatic use
- Comprehensive documentation (README, help docs, examples)

## [1.0.0] - 2025-11-03

### Added

- Initial release

[Unreleased]: https://github.com/josephferrero/quickremove.nvim/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/josephferrero/quickremove.nvim/releases/tag/v1.0.0
