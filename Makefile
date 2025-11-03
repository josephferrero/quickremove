.PHONY: test lint format clean help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

test: ## Run test suite
	@./tests/run_tests.sh

lint: ## Run luacheck linter
	@if command -v luacheck >/dev/null 2>&1; then \
		echo "Running luacheck..."; \
		luacheck lua/ --globals vim; \
	else \
		echo "luacheck not installed. Install with: luarocks install luacheck"; \
		exit 1; \
	fi

format: ## Format code with stylua
	@if command -v stylua >/dev/null 2>&1; then \
		echo "Formatting code with stylua..."; \
		stylua lua/ tests/; \
	else \
		echo "stylua not installed. Install from: https://github.com/JohnnyMorganz/StyLua"; \
		exit 1; \
	fi

format-check: ## Check code formatting
	@if command -v stylua >/dev/null 2>&1; then \
		echo "Checking code format..."; \
		stylua --check lua/ tests/; \
	else \
		echo "stylua not installed. Install from: https://github.com/JohnnyMorganz/StyLua"; \
		exit 1; \
	fi

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	@find . -type f -name "*.swp" -delete
	@find . -type f -name "*.swo" -delete
	@find . -type f -name "*~" -delete
	@echo "Done!"

watch: ## Run tests on file change (requires entr)
	@if command -v entr >/dev/null 2>&1; then \
		echo "Watching for changes..."; \
		find lua/ tests/ -name "*.lua" | entr -c make test; \
	else \
		echo "entr not installed. Install with: apt install entr / brew install entr"; \
		exit 1; \
	fi

ci: lint format-check test ## Run all CI checks

.DEFAULT_GOAL := help
