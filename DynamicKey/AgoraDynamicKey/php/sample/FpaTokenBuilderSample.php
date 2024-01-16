<?php
require_once("../src/FpaTokenBuilder.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$token = FpaTokenBuilder::buildToken($appId, $appCertificate);
echo 'Token with FPA service: ' . $token . PHP_EOL;
