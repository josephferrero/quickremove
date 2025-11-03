# Contributing to quickremove.nvim

Thank you for your interest in contributing to quickremove.nvim! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful and constructive in all interactions. We're here to build something useful together.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:

1. A clear, descriptive title
2. Steps to reproduce the issue
3. Expected behavior vs actual behavior
4. Your Neovim version (`:version`)
5. Your quickremove.nvim configuration
6. Any error messages from `:messages`

### Suggesting Features

Feature requests are welcome! Please:

1. Check if the feature has already been requested
2. Explain the use case and why it would be valuable
3. Consider providing a mockup or example of how it would work

### Submitting Pull Requests

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/quickremove.nvim.git
   cd quickremove.nvim
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-fix-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed

4. **Test Your Changes**
   - Test manually using the scenarios in TESTING.md
   - Verify the plugin loads without errors
   - Test with both quickfix and location lists

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add awesome feature"
   # or
   git commit -m "fix: resolve issue with X"
   ```

   Commit message format:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `refactor:` for code refactoring
   - `test:` for test changes
   - `chore:` for maintenance tasks

6. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub.

## Development Setup

1. Clone the repository
2. Create a test Neovim configuration:
   ```bash
   mkdir -p ~/.config/nvim-quickremove-test
   ```

3. Create a minimal init.lua:
   ```lua
   -- ~/.config/nvim-quickremove-test/init.lua
   vim.opt.runtimepath:append('/path/to/quickremove.nvim')
   require('quickremove').setup()
   ```

4. Test with:
   ```bash
   nvim -u ~/.config/nvim-quickremove-test/init.lua
   ```

## Code Style Guidelines

### Lua Code

- Use 2 spaces for indentation
- Use snake_case for variables and functions
- Use PascalCase for modules (when appropriate)
- Add type annotations in comments where helpful
- Keep functions focused and single-purpose
- Maximum line length: 100 characters (soft limit)

Example:
```lua
--- Remove items from the list by line numbers
--- @param start_line number Starting line number (1-indexed)
--- @param end_line number Ending line number (1-indexed)
local function remove_items(start_line, end_line)
  -- Implementation
end
```

### Documentation

- Update README.md for user-facing changes
- Update doc/quickremove.txt for help documentation
- Add comments for non-obvious code
- Use clear, concise language

### Commit Messages

Good commit messages:
- `feat: add support for removing items with <leader>d`
- `fix: correct cursor position after removal`
- `docs: update README with new configuration options`
- `refactor: simplify list type detection logic`

## Project Structure

```
quickremove.nvim/
├── lua/
│   └── quickremove/
│       └── init.lua          # Main plugin code
├── plugin/
│   └── quickremove.vim       # Plugin entry point
├── doc/
│   └── quickremove.txt       # Vim help documentation
├── examples/
│   └── init.lua              # Example configurations
├── README.md                 # User documentation
├── CONTRIBUTING.md           # This file
├── TESTING.md                # Testing instructions
├── LICENSE                   # MIT License
└── .gitignore
```

## Adding New Features

When adding a feature:

1. **Design First**: Open an issue to discuss the feature
2. **API Design**: Consider how it fits with existing API
3. **Implement**: Write clean, commented code
4. **Document**: Update README.md and doc/quickremove.txt
5. **Test**: Add test scenarios to TESTING.md
6. **Examples**: Add usage examples if appropriate

## Testing

Currently, the plugin uses manual testing. See TESTING.md for test scenarios.

Future improvement: Add automated tests using a test framework like plenary.nvim.

## Documentation

All user-facing features should be documented in:

1. **README.md**: Installation, basic usage, configuration
2. **doc/quickremove.txt**: Detailed Vim help documentation
3. **Code comments**: For maintainers and contributors

## Questions?

If you have questions about contributing, feel free to:

1. Open an issue with the "question" label
2. Check existing issues and discussions
3. Read through TESTING.md for usage examples

## Recognition

Contributors will be recognized in the README.md and release notes.

Thank you for contributing!
