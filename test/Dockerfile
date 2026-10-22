# CI image: PHP plus dev tools. Build from the repo root (see `make ci`).
# Only composer.json is copied in, so the dependency layer is rebuilt only when it changes.
# The repo itself is volume-mounted at run time.
ARG PHP=8.4
# Alpine: the Debian base of php:8.0 is EOL and its apt mirrors 404
FROM php:${PHP}-cli-alpine

RUN apk add --no-cache git make unzip

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Outside /app so the mounted repo (and its host vendor/) never hides it
ENV COMPOSER_VENDOR_DIR=/opt/vendor
WORKDIR /opt/deps
COPY composer.json ./
RUN composer install --no-interaction --prefer-dist --no-scripts

WORKDIR /app
