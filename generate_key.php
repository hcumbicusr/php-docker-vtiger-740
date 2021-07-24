<?php
error_reporting('');
/**
 * Genera una application unique key para vtiger
*/
$key = md5(time() + rand(1,9999999) + md5( getcwd()."/" ));
$searchF  = '{APPLICATION_UNIQUE_KEY}';
$replaceW = $key;

$file = file_get_contents("./config.inc.php", FILE_USE_INCLUDE_PATH);
$file = str_replace($searchF, $replaceW, $file);
file_put_contents("config.inc.php", $file);
print("\nAPPLICATION_UNIQUE_KEY=$key\n");

/**
 * Genera un secret csrf para vtiger
*/
require_once 'libraries/csrf-magic/csrf-magic.php';
unlink('config.csrf-secret.php');
$secret = csrf_get_secret();
print("\nSECRET-CSRF=$secret\n");