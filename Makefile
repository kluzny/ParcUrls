.DEFAULT_GOAL := help

# Where dev tool binaries live (overridden inside the CI container)
BIN ?= vendor/bin

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
	@echo "CI (Docker):"
	@echo "  ci             Run lint, test and next in a PHP container (PHP=8.4 to pick the version)"
	@echo ""
	@echo "PHP 8 upgrade:"
	@echo "  next           Run all PHP 8 upgrade checks (use make -k to see every tool's output)"
	@echo "  next_phpstan   Static analysis as PHP 8.4"
	@echo "  next_cs        Check code style against PHP 8.4 migration rules (no changes)"
	@echo "  next_rector    Show Rector's PHP 8.4 refactors (no changes)"

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
	$(BIN)/phpstan analyse -c phpstan.neon --memory-limit=1G

# Check code style without changing files
cs:
	$(BIN)/php-cs-fixer fix --dry-run --diff

# Fix code style
fmt:
	$(BIN)/php-cs-fixer fix

# PHP 8 upgrade
.PHONY: next next_phpstan next_cs next_rector

# Run all PHP 8 upgrade checks
next: next_phpstan next_cs next_rector

# Static analysis as PHP 8.4
next_phpstan:
	$(BIN)/phpstan analyse -c phpstan-next.neon --memory-limit=1G

# Check code style against PHP 8.4 migration rules without changing files
next_cs:
	$(BIN)/php-cs-fixer fix --config=.php-cs-fixer.next.php --dry-run --diff

# Show Rector's PHP 8.4 refactors without changing files
next_rector:
	$(BIN)/rector process --dry-run

# CI (Docker)
.PHONY: ci

PHP ?= 8.4
CI_IMAGE = parcurls-ci:php$(PHP)
CI_STAMP = tmp/ci-php$(PHP).stamp

# Rebuild the image only when its inputs change
$(CI_STAMP): test/Dockerfile composer.json .dockerignore
	docker build -f test/Dockerfile --build-arg PHP=$(PHP) -t $(CI_IMAGE) .
	@mkdir -p tmp
	@touch $@

# Run lint, test and next in a container with the repo mounted
ci: $(CI_STAMP)
	docker run --rm --user $$(id -u):$$(id -g) -v "$(CURDIR)":/app $(CI_IMAGE) \
		make -k BIN=/opt/vendor/bin lint test next
