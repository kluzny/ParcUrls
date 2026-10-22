<?php

$finder = PhpCsFixer\Finder::create()->in([__DIR__ . '/src', __DIR__ . '/test']);

return (new PhpCsFixer\Config())
  ->setFinder($finder)
  ->setIndent('  ')
  ->setRiskyAllowed(true)
  ->setRules([
    '@PSR12' => true,
    'curly_braces_position' => [
      'classes_opening_brace' => 'same_line',
      'functions_opening_brace' => 'same_line',
    ],
    '@PHP84Migration' => true,
    '@PHP82Migration:risky' => true,
    'declare_strict_types' => false,
  ]);
