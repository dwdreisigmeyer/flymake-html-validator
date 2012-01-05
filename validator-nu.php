#!/usr/bin/env php

<?php
#
# Make sure to chmod +x this
#

$html_patterns = array();
$html_patterns[0] = '/<code>/';
$html_patterns[1] = '/<\/code>/';
$html_patterns[2] = '/&lt;/';
$html_patterns[3] = '/&gt;/';

$html_replace = array();
$html_replace[0] = '';
$html_replace[1] = '';
$html_replace[2] = '<';
$html_replace[3] = '>';

$fileName = $argv[1];
$validatorAddress = $argv[2];

$theCall = sprintf("curl -sF 'uploaded_file=@%s' %s", $fileName, $validatorAddress);
exec($theCall, $validatorOutput);
$validationString = implode($validatorOutput);
$validationString = preg_replace($html_patterns, $html_replace, $validationString);

$error_pattern = "/<li class=\"error\">(.*?)<span>(.*?)<\/span>(.*?)<span class=\"last-line\">(.*?)<\/span>(.*?)<\/li>/";
preg_match_all($error_pattern, $validationString, $errors);

$outErrors = "";
for ($i = 0; $i < count($errors[2]); $i++) {
  $outErrors = $outErrors . $errors[4][$i] . " :-: " . $errors[2][$i] . "\n";
}

print_r($outErrors);

?>

