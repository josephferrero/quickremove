# Tests

This directory contains the test suite for quickremove.nvim.

## Running Tests

### Quick Start

```bash
# Run all tests
make test

# Or directly
./tests/run_tests.sh
```

### Requirements

- Neovim >= 0.7.0
- Bash (for the test runner script)

## Test Files

- **`quickremove_spec.lua`** - Main test suite with all test cases
- **`minimal_init.lua`** - Minimal Neovim configuration for testing
- **`run_tests.sh`** - Shell script to run tests (can be used in CI)

## Writing Tests

Tests use a simple custom test framework. Example:

```lua
test('Description of test', function()
  -- Test code here
  assert_eq(actual, expected, 'Error message')
end)
```

### Available Assertions

- `assert(condition, message)` - Standard Lua assertion
- `assert_eq(actual, expected, message)` - Check equality with better error messages

## CI Integration

Tests automatically run on:
- Push to `main` or `dev` branches
- Pull requests to `main`

The CI workflow tests against:
- Ubuntu and macOS
- Neovim stable and nightly versions

## Development Workflow

```bash
# Run tests after making changes
make test

# Run linter
make lint

# Format code
make format

# Run all CI checks locally
make ci

# Watch for changes and auto-run tests (requires entr)
make watch
```

## Test Coverage

Current test coverage includes:

- ✓ Plugin loading
- ✓ Command registration
- ✓ Basic quickfix removal
- ✓ Range removal
- ✓ Undo functionality (single and multiple levels)
- ✓ Clear functionality
- ✓ Location list support
- ✓ Empty list handling
- ✓ Invalid range handling

## Troubleshooting

### Tests fail locally but pass in CI

Make sure you're using a compatible Neovim version:
```bash
nvim --version
```

Required: Neovim >= 0.7.0

### Permission denied when running tests

Make the test script executable:
```bash
chmod +x tests/run_tests.sh
```

### Tests hang or timeout

This might indicate an issue with the plugin. Check:
1. Neovim version compatibility
2. Plugin code for infinite loops
3. Test code for missing cleanup (e.g., unclosed windows)
