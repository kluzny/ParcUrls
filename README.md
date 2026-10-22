# ParcUrls

ParcUrls ( read as "parcels", so clever ) is a small utility class to help resolve tracking numbers into tracking urls from several of the larger parcel services. This is a direct fork of
[darkain/php-tracking-urls](https://github.com/darkain/php-tracking-urls) with the goals of:

* Autoloading
* Namespacing
* Classes, because classes
* Preference of spaces vs tabs
* Access to metadata like carrier

Supported shippers:
* United States Postal Service (USPS)
* United Parcel Service (UPS)
* Federal Express (FedEx)
* OnTrac
* DHL

## Install

Note that the package names are lowercase

```bash
composer require kluzny/parcurls
```

Version support:

| PHP | Version | Install |
|-----|---------|---------|
| 8.0+ | 1.0.2 and later | `composer require kluzny/parcurls:^1.0.2` |
| 7.x | 1.0.1 (no longer updated) | `composer require kluzny/parcurls:1.0.1` |

## Example
Usage:

```php
use kluzny\ParcUrls\Parser;

$parser = new Parser("92748963438592543475924253");

echo $parser->url;
# https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=92748963438592543475924253

echo $parser->tracker['carrier'];
# USPS

echo $parser->tracker['description'];
# (empty: this USPS pattern has no description; others do, e.g. "United Parcel Service")
```

## Development

Run `make help` to list every target. The main ones:

| Target | What it does |
|--------|--------------|
| `make deps` | Install Composer dependencies, including the dev tools |
| `make test` | Run the test suite (`php test/index.php`) |
| `make lint` | Static analysis and a code style check, without changing files |
| `make fmt` | Fix code style |
| `make next` | Check the code against PHP 8.4 upgrade rules, without changing files |
| `make ci` | Run `lint`, `test` and `next` in Docker (see below) |

To add a test, add a tracking number and the expected URL substring (such as `'ups.com'`) to the `$numbers` array in `test/index.php`.

### CI

`make ci` runs `lint`, `test` and `next` inside a PHP container, so you can check a PHP version you don't have installed. It needs Docker and `make`, but no local PHP.

```bash
make ci            # PHP 8.4
make ci PHP=8.0    # any PHP version with a php:<version>-cli-alpine image
```

- **Image:** it is built from `test/Dockerfile` and tagged `parcurls-ci:php<version>`. The dev tools are installed into the image, separate from your local `vendor/`, so your local PHP version doesn't matter.
- **Repo:** your working copy is mounted into the container, so it checks your uncommitted changes. The container runs as your user, so no root-owned files appear in your tree.
- **Rebuilds:** the image is rebuilt only when `composer.json`, `test/Dockerfile` or `.dockerignore` change. Otherwise repeat runs start right away. To force a rebuild, for example to pick up new releases of the dev tools, delete `tmp/ci-php*.stamp`.
- **Results:** it runs every check even if an earlier one fails, then exits non-zero if any failed. All three are read-only, so use `make fmt` to fix style problems.

## Bugs

Feel free to create pull requests, but they must include passing test cases. I'm not particularly interested in maintaining this or any other PHP code.
