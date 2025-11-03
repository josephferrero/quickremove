#!/usr/bin/env bash
# Test runner script for quickremove.nvim
# Can be run locally or in CI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================="
echo "Running quickremove.nvim tests"
echo "======================================="
echo ""
echo "Project directory: $PROJECT_DIR"
echo "Neovim version: $(nvim --version | head -n1)"
echo ""

# Change to project directory
cd "$PROJECT_DIR"

# Run tests
echo "Running test suite..."
echo ""

if nvim --headless -u tests/minimal_init.lua \
  -c "lua require('tests.quickremove_spec')" 2>&1; then
  echo ""
  echo -e "${GREEN}✓ Tests completed successfully${NC}"
  exit 0
else
  EXIT_CODE=$?
  echo ""
  echo -e "${RED}✗ Tests failed with exit code $EXIT_CODE${NC}"
  exit $EXIT_CODE
fi
