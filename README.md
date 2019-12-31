# ParcUrls

## About

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
# United States Postal Service
```

## Bugs

Feel free to create pull requests, but they must include passing test cases. I'm not particularly interested in maintaining this or any other PHP code.
