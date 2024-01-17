<?php
include("../src/RtmTokenBuilder2.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$user = "2882341273";
$expireTimeInSeconds = 3600;

echo "App Id: " . $appId . PHP_EOL;
echo "App Certificate: " . $appCertificate . PHP_EOL;
if ($appId == "" || $appCertificate == "") {
    echo "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" . PHP_EOL;
    exit;
}

$token = RtmTokenBuilder2::buildToken($appId, $appCertificate, $user, $expireTimeInSeconds);
echo 'Rtm Token: ' . $token . PHP_EOL;
