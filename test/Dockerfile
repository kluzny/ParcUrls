# CI image: PHP plus dev tools. Build from the repo root (see `make ci`).
# Only composer.json is copied in, so the dependency layer is rebuilt only when it changes.
# The repo itself is volume-mounted at run time.
ARG PHP=8.4
FROM php:${PHP}-cli

RUN apt-get update \
  && apt-get install -y --no-install-recommends git make unzip \
  && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Outside /app so the mounted repo (and its host vendor/) never hides it
ENV COMPOSER_VENDOR_DIR=/opt/vendor
WORKDIR /opt/deps
COPY composer.json ./
# composer.json still pins php ^7.0; drop the ignore flag once it is ^8.0
RUN composer install --no-interaction --prefer-dist --no-scripts \
  --ignore-platform-req=php

WORKDIR /app
