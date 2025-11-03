# Development Workflow

This document describes the standard workflow for making changes to quickremove.nvim.

## Standard Workflow

Every change should follow these steps:

### 1. Create a new branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make your changes

Edit the relevant files:
- **Plugin code**: `lua/quickremove/init.lua`
- **Plugin loader**: `plugin/quickremove.vim`
- **Tests**: `tests/quickremove_spec.lua`
- **Documentation**: `README.md`, `doc/quickremove.txt`

### 3. Run tests

**Always run tests before committing:**

```bash
make test
```

All tests must pass. If tests fail, fix the issues before proceeding.

### 4. Update documentation

Update relevant documentation if your changes affect:
- User-facing features → Update `README.md`
- Commands/API → Update `doc/quickremove.txt`
- Development process → Update this file
- Test behavior → Update `tests/README.md`

### 5. Commit changes

```bash
git add .
git commit -m "Brief description of change"
```

**Commit message guidelines:**
- Start with a verb: "Add", "Fix", "Update", "Remove", "Refactor"
- Keep it concise (50 chars or less)
- Example: "Fix undo stack overflow bug"
- Example: "Add support for custom keymaps"

### 6. Push and create PR

```bash
git push -u origin feature/your-feature-name
```

Then create a pull request on GitHub.

### 7. CI will automatically run

The CI workflow will:
- Run all tests on Ubuntu and macOS
- Test with both Neovim stable and nightly
- Report results on your PR

## Quick Reference

```bash
# Complete workflow
git checkout -b feature/my-feature
# ... make changes ...
make test
git add .
git commit -m "Add my feature"
git push -u origin feature/my-feature
```

## Project Structure

```
quickremove/
├── lua/quickremove/
│   └── init.lua          # Main plugin code
├── plugin/
│   └── quickremove.vim   # Plugin entry point
├── tests/
│   ├── quickremove_spec.lua  # Test suite
│   ├── minimal_init.lua      # Test config
│   └── run_tests.sh          # Test runner
├── doc/
│   └── quickremove.txt   # Vim help documentation
└── README.md             # User documentation
```

## Common Tasks

### Running tests
```bash
make test
```

### Adding a new test
Edit `tests/quickremove_spec.lua` and add:
```lua
test('Description of test', function()
  -- Test code here
  assert_eq(actual, expected, 'Error message')
end)
```

### Adding a new feature
1. Update `lua/quickremove/init.lua` with your feature
2. Add tests in `tests/quickremove_spec.lua`
3. Update `README.md` with usage instructions
4. Update `doc/quickremove.txt` if adding commands/API

### Fixing a bug
1. Add a test that reproduces the bug
2. Fix the bug in `lua/quickremove/init.lua`
3. Verify the test passes
4. Update documentation if behavior changed

## For AI Agents

When working on this project:
1. **Always create a new branch** before making changes
2. **Always run `make test`** after changes
3. **Always update documentation** if user-facing behavior changes
4. **Check CI passes** after pushing

Key files to understand:
- `lua/quickremove/init.lua` - All plugin logic is here
- `tests/quickremove_spec.lua` - All tests are here
- `README.md` - User-facing documentation

## Testing Philosophy

- Every feature should have a test
- Every bug fix should have a test that would have caught it
- Tests should be fast and deterministic
- All tests must pass before merging

## Questions?

See also:
- `tests/README.md` - Detailed testing documentation
- `README.md` - User documentation
- `CONTRIBUTING.md` - Contribution guidelines
