<?php
include("../src/RtmTokenBuilder.php");

// Need to set environment variable AGORA_APP_ID
$appID = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$user = "test_user_id";
$role = RtmTokenBuilder::RoleRtmUser;
$expireTimeInSeconds = 3600;
$currentTimestamp = (new DateTime("now", new DateTimeZone('UTC')))->getTimestamp();
$privilegeExpiredTs = $currentTimestamp + $expireTimeInSeconds;

$token = RtmTokenBuilder::buildToken($appID, $appCertificate, $user, $role, $privilegeExpiredTs);
echo 'Rtm Token: ' . $token . PHP_EOL;
