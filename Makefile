.DEFAULT_GOAL := help

# Utilities
.PHONY: help

# Print usage
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Utilities:"
	@echo "  help           Show this help"
	@echo ""
	@echo "Dependencies:"
	@echo "  deps           Install dependencies, including dev tools"
	@echo ""
	@echo "Testing:"
	@echo "  test           Run the test suite"
	@echo ""
	@echo "Lint (current version):"
	@echo "  lint           Run phpstan and cs"
	@echo "  phpstan        Static analysis"
	@echo "  cs             Check code style (no changes)"
	@echo "  fmt            Fix code style"
	@echo ""
	@echo "PHP 8 upgrade:"
	@echo "  next           Run all PHP 8 upgrade checks (use make -k to see every tool's output)"
	@echo "  next_phpstan   Static analysis as PHP 8.0"
	@echo "  next_cs        Check code style against PHP 8.0 migration rules (no changes)"
	@echo "  next_rector    Show Rector's PHP 8.0 refactors (no changes)"

# Dependencies
.PHONY: deps

# Install composer dependencies, including dev tools
deps:
	composer install --no-interaction --prefer-dist

# Testing
.PHONY: test

# Run the test suite
test:
	php test/index.php

# Lint
.PHONY: lint phpstan cs fmt

# Run all lints for the current version
lint: phpstan cs

# Static analysis
phpstan:
	vendor/bin/phpstan analyse -c phpstan.neon --memory-limit=1G

# Check code style without changing files
cs:
	vendor/bin/php-cs-fixer fix --dry-run --diff

# Fix code style
fmt:
	vendor/bin/php-cs-fixer fix

# PHP 8 upgrade
.PHONY: next next_phpstan next_cs next_rector

# Run all PHP 8 upgrade checks
next: next_phpstan next_cs next_rector

# Static analysis as PHP 8.0
next_phpstan:
	vendor/bin/phpstan analyse -c phpstan-next.neon --memory-limit=1G

# Check code style against PHP 8.0 migration rules without changing files
next_cs:
	vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.next.php --dry-run --diff

# Show Rector's PHP 8.0 refactors without changing files
next_rector:
	vendor/bin/rector process --dry-run
