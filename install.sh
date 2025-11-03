#!/bin/bash
# Quick installation script for testing quickremove.nvim

set -e

echo "quickremove.nvim - Quick Install Script"
echo "========================================"
echo ""

# Detect plugin manager
LAZY_PATH="$HOME/.local/share/nvim/lazy"
PACKER_PATH="$HOME/.local/share/nvim/site/pack/packer/start"
PLUG_PATH="$HOME/.vim/plugged"

if [ -d "$LAZY_PATH" ]; then
  echo "Detected: lazy.nvim"
  TARGET="$LAZY_PATH/quickremove.nvim"
elif [ -d "$PACKER_PATH" ]; then
  echo "Detected: packer.nvim"
  TARGET="$PACKER_PATH/quickremove.nvim"
elif [ -d "$PLUG_PATH" ]; then
  echo "Detected: vim-plug"
  TARGET="$PLUG_PATH/quickremove.nvim"
else
  echo "No plugin manager detected. Installing to manual location..."
  TARGET="$HOME/.local/share/nvim/site/pack/plugins/start/quickremove.nvim"
  mkdir -p "$(dirname "$TARGET")"
fi

echo "Install location: $TARGET"
echo ""

# Check if already installed
if [ -d "$TARGET" ]; then
  echo "Warning: quickremove.nvim already exists at $TARGET"
  read -p "Remove and reinstall? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$TARGET"
  else
    echo "Installation cancelled."
    exit 1
  fi
fi

# Copy plugin files
echo "Installing plugin..."
cp -r "$(dirname "$0")" "$TARGET"

# Remove installation script and git files from installed version
rm -f "$TARGET/install.sh"
rm -rf "$TARGET/.git"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Add to your config:"
echo "   require('quickremove').setup()"
echo ""
echo "2. Restart Neovim or source your config"
echo ""
echo "3. Test with:"
echo "   :cexpr ['file1.txt:1:Test 1', 'file2.txt:2:Test 2']"
echo "   :copen"
echo "   (press 'dd' to remove an item)"
echo ""
echo "4. Read the docs:"
echo "   :help quickremove"
echo ""
echo "For more information, see:"
echo "  - README.md for full documentation"
echo "  - DEMO.md for usage examples"
echo "  - TESTING.md for testing instructions"
