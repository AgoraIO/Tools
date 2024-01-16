<?php
include("../src/RtmTokenBuilder2.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$user = "2882341273";
$expireTimeInSeconds = 3600;

$token = RtmTokenBuilder2::buildToken($appId, $appCertificate, $user, $expireTimeInSeconds);
echo 'Rtm Token: ' . $token . PHP_EOL;
