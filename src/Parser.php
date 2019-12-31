<?php

namespace kluzny\ParcUrls;

class Parser {
  public $tracker;
  public $trackingNumber;
  public $url;

  private static $trackers = array(
    [
      'carrier' => 'UPS',
      'description' => 'United Parcel Service',
      'url'=>'http://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1=',
      'regex'=>'/\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|T\d{3} ?\d{4} ?\d{3})\b/i'
    ],
    [
      'carrier' => 'USPS',
      'description' => '',
      'url'=>'https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=',
      'regex'=>'/\b((420 ?\d{5} ?)?(91|92|93|94|01|03|04|70|23|13)\d{2} ?\d{4} ?\d{4} ?\d{4} ?\d{4}( ?\d{2,6})?)\b/i'
    ],
    [
      'carrier' => 'USPS',
      'description' => 'United States Postal Service',
      'url'=>'https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=',
      'regex'=>'/\b((M|P[A-Z]?|D[C-Z]|LK|E[A-C]|V[A-Z]|R[A-Z]|CP|CJ|LC|LJ) ?\d{3} ?\d{3} ?\d{3} ?[A-Z]?[A-Z]?)\b/i'
    ],
    [
      'carrier' => 'USPS',
      'description' => 'United States Postal Service',
      'url'=>'https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=',
      'regex'=>'/\b(82 ?\d{3} ?\d{3} ?\d{2})\b/i'
    ],
    [
      'carrier' => 'FEDEX',
      'description' => 'Federal Express',
      'url'=>'http://www.fedex.com/Tracking?language=english&cntry_code=us&tracknumbers=',
      'regex'=>'/\b(((96\d\d|6\d)\d{3} ?\d{4}|96\d{2}|\d{4}) ?\d{4} ?\d{4}( ?\d{3})?)\b/i'
    ],
    [
      'carrier' => 'OnTrac',
      'description' => 'OnTrac',
      'url'=>'http://www.ontrac.com/trackres.asp?tracking_number=',
      'regex'=>'/\b(C\d{14})\b/i'
    ],
    [
      'carrier' => 'DHL',
      'description' => 'DHL',
      'url'=>'http://www.dhl.com/content/g0/en/express/tracking.shtml?brand=DHL&AWB=',
      'regex'=>'/\b(\d{4}[- ]?\d{4}[- ]?\d{2}|\d{3}[- ]?\d{8}|[A-Z]{3}\d{7})\b/i'
    ],
  );

  public function __construct($trackingNumber) {
    $this->trackingNumber = ltrim($trackingNumber, '0');
    $this->resolve($this->trackingNumber);
  }

  private function resolve($trackingNumber) {
    if (empty($trackingNumber) || !(is_string($trackingNumber) || is_int($trackingNumber))) return false;

    foreach (self::$trackers as $item) {
      $match = array();
      preg_match($item['regex'], $trackingNumber, $match);
      if (count($match)) {
        $this->tracker = $item;
        $this->url = $item['url'] . preg_replace('/\s/', '', strtoupper($match[0]));
        return;
      }
    }

    $this->tracker = array(
      'carrier' => 'Missing',
      'description' => 'No matching pattern was found',
      'url'=>'',
      'regex'=>'/.*/'
    );
    $this->url = '';
  }
}
